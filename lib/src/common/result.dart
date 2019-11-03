import 'package:aqueduct/aqueduct.dart';

class Result {
  static dynamic _formatBody(dynamic data) {
    dynamic body;
    if (data is Serializable) {
      body = data.asMap();
    } else if (data is List<Serializable>) {
      body = data.map((value) => value.asMap()).toList();
    } else if (data is Map) {
      body = {};
      for (final item in data.entries) {
        body[item.key] = _formatBody(item.value);
      }
    } else {
      body = data;
    }
    return body;
  }

  static Response ok([String msg, int code, dynamic data]) {
    return Response.ok({
      "code": code,
      "msg": msg,
      "data": _formatBody(data),
    });
  }

  static Response data(dynamic data) => ok("success", 0, data);

  static Response errorMsg([String msg = 'error', int code = -1]) =>
      ok(msg, code);

  static Response successMsg([String msg = 'success']) => ok(msg, 0);
}
