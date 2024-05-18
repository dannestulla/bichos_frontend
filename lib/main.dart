import 'package:bichosclient/presentation/bichos_drawer.dart';
import 'package:bichosclient/presentation/bichos_pageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'config.dart';
import 'domain/models/animal.dart';
import 'domain/providers/animals_providers.dart';
import 'presentation/bichos_dialog.dart';

void main() {
  runApp(
    const ProviderScope(
      child: Bichos(),
    ),
  );
}



class Bichos extends ConsumerStatefulWidget {
  const Bichos({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BichosState();
}

class BichosState extends ConsumerState<Bichos> {
  @override
  initState() {
    super.initState();
    ref.read(animalsPagingProvider).addPageRequestListener((pageKey) {
      ref.watch(animalsListProvider(pageKey));
    });
  }

  @override
  Widget build(BuildContext context) {
    final pagingController = ref.watch(animalsPagingProvider);
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        home: Scaffold(
            appBar: AppBar(leading: Builder(
              builder: (context) {
                return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    });
              },
            )),
            drawer: const BichosDrawer(),
            body: PagedGridView<int, Animal>(
                pagingController: pagingController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: setNumberOfColumns(mediaQuery.size.width),
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                builderDelegate: PagedChildBuilderDelegate<Animal>(
                    itemBuilder: (context, item, index) {
                  return Card(
                      child: GestureDetector(
                        onTap: () => ignoreModeOn ? print(item.page + "/" + item.fileNames.toString()) : showImageDialog(context, item),
                        child:Image.memory(item.pictures[0], fit: BoxFit.cover, scale: 1.5)
                  ));
                }))));
  }

  int setNumberOfColumns(double width) {
    if (width < 500) {
      return 3;
    } else if (width < 900) {
      return 4;
    } else if (width < 1300) {
      return 5;
    } else if (width < 1800) {
      return 6;
    } else {
      return 7;
    }
  }
}
