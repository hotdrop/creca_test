import 'package:creca_test/repository/remote/entity/app_response.dart';
import 'package:creca_test/repository/remote/entity/error_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_response.freezed.dart';

@freezed
class ResultResponse with _$ResultResponse {
  const factory ResultResponse.success(AppResponse response) = OnResultResponseSuccess;
  const factory ResultResponse.error(ErrorResponse error) = OnResultResponseError;
}
