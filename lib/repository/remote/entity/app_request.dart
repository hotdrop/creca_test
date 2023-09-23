import 'dart:convert';

///
/// それぞれのAPIのRequestクラスを実装する際は必ずこのクラスをextendsします
///
abstract class AppRequest {
  const AppRequest({
    required this.host,
    required this.endpoint,
    required this.idempotencyId,
  });

  final String host;
  final String endpoint;
  final String idempotencyId;

  Map<String, String> get header => {
        'Authorization': 'Basic ${createAuthorization()}',
        'Content-type': 'application/json;charset=UTF-8',
      };

  ///
  /// ここで各々のサービスの認証情報を生成して返す
  ///
  String createAuthorization() {
    final str = 'StaginTest$idempotencyId';
    return base64Encode(utf8.encode(str));
  }

  ///
  /// Requestのbodyに値を設定する場合はここで指定してください。
  /// Map型をjson.encodeしてString型として返してください。
  ///
  /// [example]
  /// return json.encode({
  ///   'item1': 'itemValue'
  /// });
  ///
  String body();
}
