import 'package:aqueduct_base/src/entity/user.dart';
import 'package:aqueduct_base/src/utils/utils.dart';

import '../../aqueduct_base.dart';

class UserController extends ResourceController {
  UserController(this.context, this.authServer);

  AuthServer authServer;

  @Bind.header(HttpHeaders.authorizationHeader)
  String authHeader;

  ManagedContext context;

  @Operation.post("name")
  FutureOr<Response> userFunction(@Bind.path("name") String name) async {
    switch (name) {
      case "login": //登录
        return login();
      case "register": //注册
        return register();
      case "forgetPwd": //忘记密码
        return forgetPwd();
      case "getValidateCode": //验证码
        return getValidateCode();
      case "refreshToken":
        return refreshToken(); //刷新token;
      default:
        return Response.notFound();
    }
  }

  FutureOr<Response> login() async {
    final body = await request.body.decode();
    final password = body['password'] as String;
    final username = body['username'] as String;

    AuthBasicCredentials basicRecord;
    const _parser = AuthorizationBasicParser();
    try {
      basicRecord = _parser.parse(authHeader);
    } on AuthorizationParserException catch (_) {
      return Utils.handlerAuthError();
    }
    final query = Query<User>(context)
      ..where((item) => item.username).equalTo(username);
    final user = await query.fetchOne();

    if (user == null) {
      return Result.error(Error.loginPwdError);
    }

    try {
      final token = await authServer.authenticate(
          username, password, basicRecord.username, basicRecord.password,
          requestedScopes: null);
      query.values.lastTime = DateTime.now();

      return Result.data({
        "token": token.accessToken,
        "expiration": token.expirationDate.millisecondsSinceEpoch,
        "refreshToken": token.refreshToken,
        "user": await query.updateOne(),
      });
    } on AuthServerException catch (_) {
      return Result.error(Error.loginPwdError);
    }
  }

  FutureOr<Response> register() async {
    final body = await request.body.decode();
    final password = body['password'] as String;
    final username = body['username'] as String;

    if (password == null || password.isEmpty) {
      return Result.error(Error.pleaseEditPwd);
    }
    if (username == null || username.isEmpty) {
      return Result.error(Error.pleaseEditPhone);
    }

    AuthBasicCredentials basicRecord;
    const _parser = AuthorizationBasicParser();
    try {
      basicRecord = _parser.parse(authHeader);
    } on AuthorizationParserException catch (_) {
      return Utils.handlerAuthError();
    }

    final user = User()
      ..username = username
      ..phone = username
      ..createTime = DateTime.now()
      ..salt = AuthUtility.generateRandomSalt();
    user.hashedPassword = authServer.hashPassword(password, user.salt);
    final query = Query<User>(
      context,
    )..where((user) => user.username).equalTo(username);
    final existUser = await query.fetchOne();
    if (existUser != null) {
      return Result.error(Error.userExists);
    } else {
      query.values = user;
      await query.insert();
      return Result.successMsg();
    }
  }

  FutureOr<Response> forgetPwd() async {
    final body = await request.body.decode();
    final password = body['password'] as String;
    final username = body['username'] as String;
    if (password == null || password.isEmpty) {
      return Result.error(Error.pleaseEditPwd);
    }
    if (username == null || username.isEmpty) {
      return Result.error(Error.pleaseEditPhone);
    }
    final user = User()
      ..username = username
      ..phone = username
      ..updateTime = DateTime.now()
      ..salt = AuthUtility.generateRandomSalt();
    user.hashedPassword = authServer.hashPassword(password, user.salt);
    final query = Query<User>(context, values: user)
      ..where((item) => item.username).equalTo(user.username);

    if (await query.fetchOne() == null) {
      return Result.error(Error.userNoExists);
    } else {
      await query.updateOne();
      return Result.successMsg("更新成功");
    }
  }

  FutureOr<Response> refreshToken() async {
    final body = await request.body.decode();
    final refreshToken = body['refreshToken'] as String;

    AuthBasicCredentials basicRecord;
    const _parser = AuthorizationBasicParser();
    try {
      basicRecord = _parser.parse(authHeader);
    } on AuthorizationParserException catch (_) {
      return Utils.handlerAuthError();
    }
    final token = await authServer.refresh(
        refreshToken, basicRecord.username, basicRecord.password,
        requestedScopes: null);
    return Result.data({
      "token": token.accessToken,
      "refreshToken": token.refreshToken,
      "expiration": token.expirationDate.millisecondsSinceEpoch,
    });
  }

  FutureOr<Response> getValidateCode() async {
    return Result.successMsg("获取成功");
  }
}
