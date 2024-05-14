import 'package:bichos_client/models/animal.dart';
import 'package:bichos_client/providers/bichos_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

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
        home: Scaffold(
            appBar: AppBar(title: const Text('Central do Resgate')),
            body: PagedGridView<int, Animal>(
                pagingController: pagingController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: setNumberOfColumns(mediaQuery.size.width),
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                builderDelegate: PagedChildBuilderDelegate<Animal>(
                    itemBuilder: (context, item, index) {
                  return Card(
                      child: GestureDetector(
                        onTap: () => showImageDialog(context, item),
                        child: Image.memory(item.picture),
                  ));
                }))));
  }

  int setNumberOfColumns(double width) {
    if (width < 500) {
      return 4;
    } else if (width < 900) {
      return 5;
    } else if (width < 1300) {
      return 6;
    } else if (width < 1800) {
      return 7;
    } else {
      return 8;
    }
  }

  void showImageDialog(BuildContext context, Animal animal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Expanded(child: Image.memory(animal.picture)),
                  Text("Data da postagem: ${animal.date}",
                      style: const TextStyle(fontSize: 16)),
                  animal.comment != null
                      ? Text(animal.comment!, style: const TextStyle(fontSize: 16))
                      : Container(),
                  OutlinedButton(
                      onPressed: () {
                        _launchURL(animal.page);
                      },
                      child:
                          Text(animal.page, style: const TextStyle(fontSize: 18)))
                ]),
          ),
        ));
      },
    );
  }

  void _launchURL(String page) async {
    final fullLink = "https://www.instagram.com/$page";
    if (!await launchUrl(Uri.parse(fullLink))) {
      throw 'Could not launch $fullLink';
    }
  }
}
