import 'package:creca_test/ui/account/account_page.dart';
import 'package:creca_test/ui/item/item_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopPage extends ConsumerWidget {
  const TopPage({super.key});

  static const int itemsIndex = 0;
  static const int accountIndex = 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIdx = ref.watch(_selectMenuIndexSProvider);
    final isMobileSize = MediaQuery.of(context).size.width < 640;

    if (isMobileSize) {
      return _ViewMobileMode(
        destinations: destinations,
        body: _menuView(currentIdx),
        currentIdx: currentIdx,
        onTap: (index) => ref.read(_selectMenuIndexSProvider.notifier).state = index,
      );
    } else {
      return _ViewWebMode(
        destinations: destinations,
        body: _menuView(currentIdx),
        currentIdx: currentIdx,
        onTap: (index) => ref.read(_selectMenuIndexSProvider.notifier).state = index,
      );
    }
  }

  List<Destination> get destinations => <Destination>[
        const Destination('ホーム', Icon(Icons.home)),
        const Destination('アカウント', Icon(Icons.account_circle)),
      ];

  Widget _menuView(int index) {
    return switch (index) {
      itemsIndex => const ItemPage(),
      accountIndex => const AccountPage(),
      _ => throw Exception(['不正なIndexです index=$index']),
    };
  }
}

class _ViewWebMode extends StatelessWidget {
  const _ViewWebMode({
    required this.destinations,
    required this.body,
    required this.currentIdx,
    required this.onTap,
  });

  final List<Destination> destinations;
  final Widget body;
  final int currentIdx;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            destinations: destinations
                .map((e) => NavigationRailDestination(
                      icon: e.icon,
                      label: Text(e.title),
                    ))
                .toList(),
            selectedIndex: currentIdx,
            onDestinationSelected: onTap,
            labelType: NavigationRailLabelType.all,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _ViewMobileMode extends StatelessWidget {
  const _ViewMobileMode({
    required this.destinations,
    required this.body,
    required this.currentIdx,
    required this.onTap,
  });

  final List<Destination> destinations;
  final Widget body;
  final int currentIdx;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIdx,
        elevation: 4,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: destinations
            .map((e) => BottomNavigationBarItem(
                  icon: e.icon,
                  label: e.title,
                ))
            .toList(),
        onTap: onTap,
      ),
    );
  }
}

class Destination {
  const Destination(this.title, this.icon);

  final String title;
  final Widget icon;
}

final _selectMenuIndexSProvider = StateProvider((ref) => TopPage.itemsIndex);
