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
              itemBuilder: (context, index) {
                if (histories[index].isSuccess()) {
                  return _SuccessRow(histories[index]);
                } else {
                  return _ErrorRow(histories[index]);
                }
              },
              itemCount: histories.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessRow extends StatelessWidget {
  const _SuccessRow(this.history);

  final History history;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(history.message, style: const TextStyle(color: Colors.green)),
                    Text('支払い金額: ${history.amount} 円'),
                  ],
                ),
                const Spacer(),
                Text(History.dateFormat.format(history.dateTime)),
              ],
            ),
            const Divider(),
            Text('アカウントID: ${history.accountId}'),
            Text('処理ID: ${history.transactionId}'),
          ],
        ),
      ),
    );
  }
}

class _ErrorRow extends StatelessWidget {
  const _ErrorRow(this.history);

  final History history;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_rounded, color: Colors.red),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('エラー', style: TextStyle(color: Colors.red)),
                    Text('支払い金額: ${history.amount} 円'),
                  ],
                ),
                const Spacer(),
                Text(History.dateFormat.format(history.dateTime)),
              ],
            ),
            const Divider(),
            Text('アカウントID: ${history.accountId}'),
            Text('処理ID: ${history.transactionId}'),
            Text('StatusCode: ${history.resultCode}', style: const TextStyle(color: Colors.red)),
            Text(history.message, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
