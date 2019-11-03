
import '../../aqueduct_base.dart';

class AuthorizerController extends Controller{
  AuthorizerController(this.validator);

  final AuthorizationParser parser=const AuthorizationBearerParser();
  final AuthValidator validator;


  @override //authorization
  FutureOr<RequestOrResponse> handle(Request request) async{
    final authData = request.raw.headers.value(HttpHeaders.authorizationHeader);
    if (authData == null) {
      return Result.errorMsg("访问失败",401);
    }
    try {
      final value = parser.parse(authData);
      request.authorization =
          await validator.validate(parser, value, requiredScope: null);
      if (request.authorization == null) {
        return Result.errorMsg("访问失败",401);
      }

    } on AuthorizationParserException catch (e) {
      return _responseFromParseException(e);
    } on AuthServerException catch (_) {
      return Result.errorMsg("访问失败",401);
    }

    return request;
  }

  Response _responseFromParseException(AuthorizationParserException e) {
    switch (e.reason) {
      case AuthorizationParserExceptionReason.malformed:
        return Result.errorMsg("访问失败，未授权的token",400);
      case AuthorizationParserExceptionReason.missing:
        return Result.errorMsg("访问失败",401);
      default:
        return Result.errorMsg("内部错误",500);
    }
  }

}