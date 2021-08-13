import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });
  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void> request({
    @required String url,
  });
}

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  test(
    'Should call HttpClient with correct URL',
    () async {
      //arange
      final httpClient = MockHttpClient();
      final url = faker.internet.httpUrl();
      final sut = RemoteAuthentication(httpClient: httpClient, url: url);

      //assert
      await sut.auth();

      //act
      verify(httpClient.request(url: url));
    },
  );
}
