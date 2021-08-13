import 'package:meta/meta.dart';

import '../../domain/usecases/usecases_exports.dart';

import '../http/http_exports.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });
  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(
      url: url,
      method: 'post',
      body: params.toJson(),
    );
  }
}
