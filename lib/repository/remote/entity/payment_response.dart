import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_response.freezed.dart';
part 'payment_response.g.dart';

@freezed
class PaymentResponse with _$PaymentResponse {
  factory PaymentResponse({
    @JsonKey(name: 'result') required bool result,
  }) = _PaymentResponse;

  factory PaymentResponse.fromJson(Map<String, Object?> json) => _$PaymentResponseFromJson(json);
}
