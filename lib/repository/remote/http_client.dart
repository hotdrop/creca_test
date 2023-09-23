import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:creca_test/repository/remote/entity/app_response.dart';
import 'package:creca_test/repository/remote/entity/error_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:creca_test/repository/remote/entity/app_request.dart';
import 'package:creca_test/repository/remote/entity/result_response.dart';

final httpClientProvider = Provider((_) => HttpClient());

class HttpClient {
  Future<ResultResponse> post(AppRequest request) async {
    final url = Uri.https(request.host, request.endpoint);
    final response = await http.post(url, headers: request.header, body: request.body());
    final responseWithParse = _parseResponse(response);

    if (response.isSuccess()) {
      final appResponse = AppResponse(responseWithParse);
      return ResultResponse.success(appResponse);
    } else {
      final errorResponse = ErrorResponse.fromJson(responseWithParse);
      return ResultResponse.error(errorResponse);
    }
  }

  Map<String, Object?> _parseResponse(http.Response response) {
    final dynamic jsonDecode = convert.jsonDecode(response.body);
    return jsonDecode as Map<String, Object?>;
  }
}

extension HttpResponse on http.Response {
  bool isSuccess() {
    return statusCode >= 200 && statusCode < 400;
  }
}
