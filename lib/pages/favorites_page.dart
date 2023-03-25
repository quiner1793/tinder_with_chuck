import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/favorites_provider.dart';

class FavoritesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    final jokeList = ref.watch(favoritesProvider).jokes;
    final isLoading = ref.watch(favoritesProvider).isLoading;

    return isLoading
        ? Center(
            child: SizedBox(
                width: 30, height: 30, child: CircularProgressIndicator()))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Text('You have '
                    '${jokeList.length} favorites:'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: jokeList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: IconButton(
                            icon: Icon(Icons.delete_outline,
                                semanticLabel: 'Delete'),
                            color: theme.colorScheme.primary,
                            onPressed: () {
                              ref
                                  .read(favoritesProvider.notifier)
                                  .removeFavorite(jokeList[index]);
                            },
                          ),
                          title: Text(jokeList[index]),
                        ),
                        (index < jokeList.length - 1)
                            ? Divider()
                            : SizedBox.shrink(),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
  }
}
