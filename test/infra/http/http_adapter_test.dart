import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:meta/meta.dart';

import 'package:for_dev/core/http/http_client.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);
  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final uri = Uri.parse(url);
    final headers = {
      'content-type': 'application/json',
      'accept': 'aaplication/json',
    };
    final jsonParsedBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(
      uri,
      headers: headers,
      body: jsonParsedBody,
    );
    return response.body.isEmpty ? null : jsonDecode(response.body);
  }
}

class MockClient extends Mock implements Client {}

HttpAdapter sut;
MockClient client;
String url;

void main() {
  setUp(() {
    client = MockClient();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });
  group(
    'post',
    () {
      PostExpectation mockRequest() => when(
            client.post(
              any,
              body: anyNamed('body'),
              headers: anyNamed('headers'),
            ),
          );

      void mockResponse(
        int statusCode, {
        String body = '{"any_key":"any_value"}',
      }) {
        mockRequest().thenAnswer(
          (_) async => Response(
            body,
            statusCode,
          ),
        );
      }

      setUp(
        () {
          mockResponse(200);
        },
      );
      test(
        'Should call post with correct values',
        () async {
          //arange

          //assert
          await sut.request(
            url: url,
            method: 'post',
            body: {'any_key': 'any_value'},
          );

          //act
          verify(
            client.post(
              Uri.parse(url),
              headers: {
                'content-type': 'application/json',
                'accept': 'aaplication/json',
              },
              body: '{"any_key":"any_value"}',
            ),
          );
        },
      );

      test(
        'Should call post without body with correct values',
        () async {
          //arange

          //assert
          await sut.request(url: url, method: 'post');

          //act
          verify(
            client.post(Uri.parse(url), headers: anyNamed('headers')),
          );
        },
      );

      test(
        'Should return data if post resturns 200',
        () async {
          //arange

          //assert
          final response = await sut.request(url: url, method: 'post');

          //act
          expect(response, {'any_key': 'any_value'});
        },
      );

      test(
        'Should return null if post resturns 200 without data',
        () async {
          //arange
          mockResponse(200, body: '');

          //assert
          final response = await sut.request(url: url, method: 'post');

          //act
          expect(response, null);
        },
      );
    },
  );
}
