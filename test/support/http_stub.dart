import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class HttpStub implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions) respond;
  HttpStub(this.respond);
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => respond(options);
  @override
  void close({bool force = false}) {}
}

ResponseBody jsonResponse(Object data, [int status = 200]) =>
    ResponseBody.fromString(
      jsonEncode(data),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

String testToken({int? expires, String userId = 'us-test'}) {
  final payload = {
    'sub': userId,
    'email': 'staff@example.test',
    'exp':
        expires ??
        DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
            1000,
  };
  return 'header.${base64Url.encode(utf8.encode(jsonEncode(payload))).replaceAll('=', '')}.signature';
}
