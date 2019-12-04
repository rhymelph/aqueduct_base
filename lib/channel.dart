import 'package:aqueduct/managed_auth.dart';
import 'package:aqueduct_base/src/controller/article_controller.dart';
import 'package:aqueduct_base/src/controller/user_controller.dart';

import 'aqueduct_base.dart';
import 'src/common/app_config.dart';
import 'src/common/pretty_logging.dart';
import 'src/controller/authorizer_controller.dart';
import 'src/entity/user.dart';

class AqueductBaseChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer _authServer;

  @override
  Future prepare() async {
    //执行初始化任务的方法

    /********************** 获取配置 **********************/

    final AppConfig _config = AppConfig(options.configurationFilePath);
    options.port = _config.port;
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();

    /********************** 设置数据库 **********************/

    final psc = PostgreSQLPersistentStore.fromConnectionInfo(
        _config.database.username,
        _config.database.password,
        _config.database.host,
        _config.database.port,
        _config.database.databaseName);
    context = ManagedContext(dataModel, psc);

    /********************** 用户授权 **********************/

    final delegate = ManagedAuthDelegate<User>(context, tokenLimit: 20);
    _authServer = AuthServer(delegate);

    /********************** 打印日志 **********************/
    logger.onRecord.listen(prettyLog);
  }

  @override
  Controller get entryPoint => Router()
    ..route('/example').linkFunction((res) => Response.ok({'ok': 'hello'}))
    ..route("/article/[:name]")
        .link(() => AuthorizerController(_authServer))
        .link(() => ArticleController(context))
    ..route("/user/[:name]").link(
      () => UserController(context, _authServer),
    );
}
