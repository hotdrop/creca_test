import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_response.freezed.dart';
part 'error_response.g.dart';

@freezed
class ErrorResponse with _$ErrorResponse {
  factory ErrorResponse({
    @JsonKey(name: 'statusCode') required int statusCode,
    @JsonKey(name: 'overview') required String overview,
    @JsonKey(name: 'detail') required String detail,
  }) = _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, Object?> json) => _$ErrorResponseFromJson(json);
}
