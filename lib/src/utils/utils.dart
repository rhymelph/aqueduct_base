


import '../../aqueduct_base.dart';

class Utils{

  static Response handlerAuthError(){
    String errorString(AuthRequestError error) {
      switch (error) {
        case AuthRequestError.invalidRequest:
          return "无效请求";
        case AuthRequestError.invalidClient:
          return "无效的客户端";
        case AuthRequestError.invalidGrant:
          return "invalid_grant";
        case AuthRequestError.invalidScope:
          return "无效请求范围";
        case AuthRequestError.invalidToken:
          return "登录已过期";
        case AuthRequestError.unauthorizedClient:
          return "经过身份验证的客户端无权使用此授权授予类型";
        case AuthRequestError.accessDenied:
          return "资源所有者或授权服务器拒绝了该请求。";
        case AuthRequestError.serverError:
          return "服务器在处理请求过程中遇到错误";
        case AuthRequestError.temporarilyUnavailable:
          return "服务器暂时无法完成请求";
        case AuthRequestError.unsupportedGrantType:
          return "授权服务器不支持授权授予类型。";
        case AuthRequestError.unsupportedResponseType:
          return "授权服务器不支持使用该方法获得授权代码。";
      }
      return null;
    }
    return Result.errorMsg(errorString(AuthRequestError.invalidClient));
  }
}