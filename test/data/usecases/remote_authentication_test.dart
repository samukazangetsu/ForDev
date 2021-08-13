import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/core/http/http_exports.dart';
import 'package:for_dev/data/data_source/usecase_exports.dart';
import 'package:for_dev/domain/usecases/usecases_exports.dart';
import 'package:for_dev/domain/helpers/helpers_export.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  MockHttpClient httpClient;
  String url;
  AuthenticationParams params;
  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
  });

  test(
    'Should call [HttpClient] with correct values',
    () async {
      //assert

      //act
      await sut.auth(params);

      // expect
      verify(
        httpClient.request(
          url: url,
          method: 'post',
          body: {
            'email': params.email,
            'password': params.password,
          },
        ),
      );
    },
  );

  test(
    'Should throw [unexpected] if HttpClient returns 400',
    () async {
      //assert
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      ).thenThrow(HttpError.badRequest);

      //act

      final response = sut.auth(params);

      // expect
      expect(response, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw [unexpected] if HttpClient returns 404',
    () async {
      //assert
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      ).thenThrow(HttpError.notFound);

      //act

      final response = sut.auth(params);

      // expect
      expect(response, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw [unexpected] if HttpClient returns 500',
    () async {
      //assert
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      ).thenThrow(HttpError.serverError);

      //act

      final response = sut.auth(params);

      // expect
      expect(response, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw [InvalidCredentialsError] if HttpClient returns 401',
    () async {
      //assert
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      ).thenThrow(HttpError.unauthorized);

      //act

      final response = sut.auth(params);

      // expect
      expect(response, throwsA(DomainError.invalidCredentials));
    },
  );
}
