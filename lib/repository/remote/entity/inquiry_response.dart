import 'package:freezed_annotation/freezed_annotation.dart';

part 'inquiry_response.freezed.dart';
part 'inquiry_response.g.dart';

@freezed
class InquiryResponse with _$InquiryResponse {
  factory InquiryResponse({
    @JsonKey(name: 'cardId') String? id,
    @JsonKey(name: 'cardNumber') String? cardNumber,
    @JsonKey(name: 'expiryDate') String? expiryDate,
    @JsonKey(name: 'cardHolderName') String? cardHolderName,
  }) = _InquiryResponse;

  factory InquiryResponse.fromJson(Map<String, Object?> json) => _$InquiryResponseFromJson(json);
}
