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
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({
    @required String url,
    @required method,
  });
}

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  MockHttpClient httpClient;
  String url;
  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test(
    'Should call HttpClient with correct values',
    () async {
      //assert
      await sut.auth();

      //act
      verify(httpClient.request(
        url: url,
        method: 'post',
      ));
    },
  );
}
