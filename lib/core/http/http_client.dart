import 'package:meta/meta.dart';

abstract class HttpClient {
  Future<void> request({
    @required String url,
    @required method,
    Map body,
  });
}
