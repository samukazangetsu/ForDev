import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:for_dev/domain/usecases/authentication.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });
  Future<void> auth(AuthenticationParams params) async {
    final body = {
      'email': params.email,
      'password': params.password,
    };
    await httpClient.request(
      url: url,
      method: 'post',
      body: body,
    );
  }
}

abstract class HttpClient {
  Future<void> request({
    @required String url,
    @required method,
    Map body,
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

      //act
      final params = AuthenticationParams(
        email: faker.internet.email(),
        password: faker.internet.password(),
      );
      await sut.auth(params);

      // expect
      verify(httpClient.request(
        url: url,
        method: 'post',
        body: {
          'email': params.email,
          'password': params.password,
        },
      ));
    },
  );
}
