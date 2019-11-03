import '../../aqueduct_base.dart';

class ArticleController extends ResourceController{
  ArticleController(this.context);
  ManagedContext context;

  @Operation.get()
  FutureOr<Response> register() async {
    final authorization = request.authorization;
    
    return Result.successMsg(authorization.ownerID.toString());

  }
}