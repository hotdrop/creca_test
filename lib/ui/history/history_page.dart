import 'package:creca_test/model/history.dart';
import 'package:creca_test/ui/history/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('履歴'),
      ),
      body: ref.watch(historiesProvider).when(
            data: (data) => _ViewBody(data),
            error: (err, st) => Center(
              child: Text('エラーが発生しました。\n $err', style: const TextStyle(color: Colors.red)),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}

class _ViewBody extends StatelessWidget {
  const _ViewBody(this.histories);

  final List<History> histories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('履歴は ${histories.length} 件です。'),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => _HistoryRow(histories[index]),
              itemCount: histories.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow(this.history);

  final History history;

  @override
  Widget build(BuildContext context) {
    final icons = history.isSuccess() ? Icons.check_circle : Icons.error_rounded;
    final color = history.isSuccess() ? Colors.green : Colors.red;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icons, color: color),
        title: Text(history.message, style: TextStyle(color: color)),
        subtitle: Text(history.accountId),
      ),
    );
  }
}
