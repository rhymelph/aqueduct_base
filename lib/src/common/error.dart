class Error {
  const Error._(this.code, this.message);

  final int code;
  final String message;

  static const Error loginPwdError = Error._(1000, '用户不存在或密码错误');
  static const Error loginTokenError = Error._(1001, 'token已失效');
  static const Error userExists = Error._(1002, '用户已存在');
  static const Error userNoExists = Error._(1003, '用户不存在');
  static const Error pleaseEditPwd = Error._(1004, '请输入密码');
  static const Error pleaseEditPhone = Error._(1005, '请输入手机号');
}
