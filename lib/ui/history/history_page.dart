import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO 履歴画面作る
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Text('未実装です'),
        ),
      ),
    );
  }
}
