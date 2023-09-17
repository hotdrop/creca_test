# creca_test
クレカ決済のUIを実装するときどんな感じになるのか検証するために作成したアプリです。

# 概要
決済サービスはAPIだけでなくSDKやWebViewもあるので、このUIが参考になるのは一部だと思われます。  
ただ、最近はStripeなどAPI提供しているサービスも多くなってきたはずなのでそれなりに有益かなと思います。  

履歴の保持にIsarを使用していますが、Webで利用しようとすると以下のエラーが出てしまいます。  
どうやらこのissue「https://github.com/isar/isar/issues/686」を読むとV4で解消されるようなので待ちになります。
```
Error: The integer literal 5751694338128944171 can't be represented exactly in JavaScript.
Try changing the literal to something that can be represented in Javascript. In Javascript 5751694338128944128 is the nearest value that can be represented exactly.
  id: 5751694338128944171,
```
