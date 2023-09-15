import 'package:creca_test/model/item.dart';
import 'package:creca_test/ui/item/item_controller.dart';
import 'package:creca_test/ui/payment/card_input_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 8),
            Text('商品を選択して先に進んでください。'),
            SizedBox(height: 8),
            Flexible(child: _ViewItems()),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ViewItems extends ConsumerWidget {
  const _ViewItems();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemControllerProvider.notifier).findAll();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _CardItem(items[index]);
      },
    );
  }
}

class _CardItem extends StatelessWidget {
  const _CardItem(this.item);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          CardInputPage.start(context, item);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(item.imagePath, width: 100, height: 100),
            ),
            Text(item.name),
            Text('${item.price} 円'),
          ],
        ),
      ),
    );
  }
}
