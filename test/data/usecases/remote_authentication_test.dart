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

  Map mockValidData() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  PostExpectation mockRequest() => when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      );

  void mockHttpData(Map data) {
    mockRequest().thenAnswer(
      (_) async => data,
    );
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

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
      mockHttpData(mockValidData());

      //act
      await sut.auth(params: params);

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
      mockHttpError(HttpError.badRequest);

      //act

      final response = sut.auth(params: params);

      // expect
      expect(response, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw [unexpected] if HttpClient returns 404',
    () async {
      //assert
      mockHttpError(HttpError.notFound);

      //act
      final response = sut.auth(params: params);

      // expect
      expect(response, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw [unexpected] if HttpClient returns 500',
    () async {
      //assert
      mockHttpError(HttpError.serverError);

      //act
      final response = sut.auth(params: params);

      // expect
      expect(response, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw [InvalidCredentialsError] if HttpClient returns 401',
    () async {
      //assert
      mockHttpError(HttpError.unauthorized);

      //act
      final response = sut.auth(params: params);

      // expect
      expect(response, throwsA(DomainError.invalidCredentials));
    },
  );

  test(
    'Should return an [AccountEntity] if HttpClient returns 200',
    () async {
      //assert
      final validData = mockValidData();
      mockHttpData(validData);

      //act
      final account = await sut.auth(params: params);

      // expect
      expect(account.token, validData['accessToken']);
    },
  );

  // test(
  //   'Should throw [UnexpectedError] if HttpClient returns 200 with invalid data',
  //   () async {
  //     //assert
  //     mockHttpData({'invalid_key': 'invalid_value'});

  //     //act
  //     final future = await sut.auth(params: params);

  //     // expect

  //     expectLater(future, throwsA(DomainError.unexpected));
  //   },
  // );
}
