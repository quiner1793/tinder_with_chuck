import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'favorites_page.dart';
import 'info_page.dart';
import 'joke_page.dart';

final homePageProvider = StateProvider((ref) => 0);

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(homePageProvider);

    Widget page;
    switch (pageIndex) {
      case 0:
        page = InfoPage();
        break;
      case 1:
        page = JokePage();
        break;
      case 2:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $pageIndex');
    }

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Expanded(child: page),
            SafeArea(
              child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.info),
                    label: 'Info',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'Favorites',
                  ),
                ],
                currentIndex: pageIndex,
                onTap: (value) {
                  ref.read(homePageProvider.notifier).state = value;
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
