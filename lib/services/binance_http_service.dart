import 'dart:convert';
import 'dart:io';

import 'package:base_interactive_test_case/exceptions/binance_http_exception.dart';
import 'package:base_interactive_test_case/models/http_response_model.dart';
import 'package:http/http.dart' as http;


class BinanceHttpService {
  static const _baseUrl = 'https://api.binance.com';

  final http.Client _client;

  BinanceHttpService({http.Client? client})
      : _client = client ?? http.Client();

  Future<List<HttpResponseModel>> fetch24hTickers() async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/api/v3/ticker/24hr'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded
              .map((e) => HttpResponseModel.fromJson(e))
              .toList();
        }
        throw BinanceHttpException('Unexpected response format');
      }

      if (response.statusCode >= 400 && response.statusCode < 500) {
        throw BinanceHttpException(
          'Client error',
          statusCode: response.statusCode,
        );
      }

      if (response.statusCode >= 500) {
        throw BinanceHttpException(
          'Server error',
          statusCode: response.statusCode,
        );
      }

      throw BinanceHttpException(
        'Unexpected status code',
        statusCode: response.statusCode,
      );
    } on SocketException {
      throw BinanceHttpException('No internet connection. Please check your connection or try using a VPN.');
    } catch (e) {
      throw BinanceHttpException('Failed to fetch data: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
