import 'dart:async';
import 'dart:convert';
// ignore: unused_import
import 'dart:developer';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Network {
  final String _url = 'https://boobook.company/api/v1';
  // final String _url = 'https://fiou_backend.test/api/v1';
  //if you are using android studio emulator, change localhost to 10.0.2.2

  // ignore: prefer_typing_uninitialized_variables
  var token;
  Map<String, Object>? result;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: 10000,
      // receiveTimeout: 10000,
    ),
  );

  // _getToken() async {
  //   token = await SharedPref().getToken();
  //   (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
  //       (client) {
  //     client.badCertificateCallback =
  //         (X509Certificate cert, String host, int port) {
  //       return true;
  //     };
  //   };
  // }

  Future<dynamic> authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    // debugPrint('authData:' + fullUrl);
    _checkSSl();
    _setDioHeaders();
    try {
      var response = await _dio.post(fullUrl, data: jsonEncode(data));
      return json.decode(response.toString());
    } on DioError catch (e) {
      result = {
        'success': false,
      };
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        EasyLoading.showError('網路有些不穩喔，請稍後再試！',
            duration: const Duration(seconds: 2), dismissOnTap: true);
        result = {
          'success': false,
          'message': {
            'error': ['網路有些不穩喔，請稍後再試！']
          },
        };
      } else {
        result = {
          'success': false,
          'message': {
            'error': ['目前沒有您的環境沒有網路，請連結網路後再試看看！']
          },
        };
        debugPrint(e.message);
        if (e.response != null) {
          debugPrint('response:' + e.response.toString());
        }
      }

      return result;
    }
  }

  Future<dynamic> getData(apiUrl) async {
    // debugPrint('get date from: $apiUrl');
    var fullUrl = _url + apiUrl;
    _checkSSl();

    _setDioHeaders();
    try {
      final response = await _dio.get(fullUrl);
      debugPrint(response.toString());

      return json.decode(response.toString());
    } on DioError catch (e) {
      result = {
        'success': false,
        'message': e.message,
      };

      if (e.type == DioErrorType.connectTimeout) {
        EasyLoading.showError('網路有些不穩喔，請稍後再試！',
            duration: const Duration(seconds: 2), dismissOnTap: true);
        result = {
          'success': false,
          'message': {
            'error': ['網路有些不穩喔，請稍後再試！']
          },
        };
      }
      if (e.type == DioErrorType.other) {
        EasyLoading.showError('目前沒有您的環境沒有網路，請連結網路後再試看看！',
            duration: const Duration(seconds: 4), dismissOnTap: true);
        result = {
          'success': false,
          'message': {
            'error': ['網路有些不穩喔，請稍後再試！']
          },
        };
      }

      if (e.response?.statusCode == 401) {
        EasyLoading.showError('身份驗證敗，請重新登入！',
            duration: const Duration(seconds: 2), dismissOnTap: true);

        throw Exception("Auth false on server");
      }
      return result;
    }
  }

  Future<dynamic> postData(data, apiUrl) async {
    debugPrint('post date from: $apiUrl');
    // inspect(data);
    var fullUrl = _url + apiUrl;
    _checkSSl();

    _setDioHeaders();
    try {
      // debugPrint(jsonEncode(data));
      final response = await _dio.post(fullUrl, data: jsonEncode(data));

      debugPrint('response: $response');
      EasyLoading.dismiss();
      return json.decode(response.toString());
    } on DioError catch (e) {
      result = {
        'success': false,
        'message': e.message,
      };
      if (e.type == DioErrorType.connectTimeout) {
        EasyLoading.showError('網路有些不穩喔，請稍後再試！',
            duration: const Duration(seconds: 2), dismissOnTap: true);
        result = {
          'success': false,
          'message': {
            'error': ['網路有些不穩喔，請稍後再試！']
          },
        };
      }
      if (e.type == DioErrorType.other) {
        EasyLoading.showError('目前沒有您的環境沒有網路，請連結網路後再試看看！',
            duration: const Duration(seconds: 4), dismissOnTap: true);
        result = {
          'success': false,
          'message': {
            'error': ['網路有些不穩喔，請稍後再試！']
          },
        };
      }
      if (e.response?.statusCode == 401) {
        EasyLoading.showError('身份驗證敗，請重新登入！',
            duration: const Duration(seconds: 2), dismissOnTap: true);

        throw Exception("Auth false on server");
      }
      debugPrint('response: $result');
      return result;
    }
  }

  postUnData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    _checkSSl();
    _setDioHeaders();
    try {
      final response = await _dio.post(fullUrl, data: jsonEncode(data));
      return json.decode(response.toString());
    } on DioError catch (e) {
      debugPrint(e.message);
      result = {
        'success': false,
        'message': e.message,
      };
      if (e.response != null) {
        debugPrint('response:' + e.response.toString());
      }

      return result;
    }
  }

  _setDioHeaders() {
    _dio.options.headers["Authorization"] = "Bearer $token";
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
  }

  _checkSSl() {
    if (_url == 'https://fiou_backend.test/api/v1') {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      };
    }
  }
}
