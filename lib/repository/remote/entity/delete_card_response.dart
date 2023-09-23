import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_card_response.freezed.dart';
part 'delete_card_response.g.dart';

@freezed
class DeleteCardResponse with _$DeleteCardResponse {
  factory DeleteCardResponse({
    @JsonKey(name: 'result') required bool result,
  }) = _DeleteCardResponse;

  factory DeleteCardResponse.fromJson(Map<String, Object?> json) => _$DeleteCardResponseFromJson(json);
}
