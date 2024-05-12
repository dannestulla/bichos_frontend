import 'dart:typed_data';

import 'package:bichos_client/models/animal.dart';
import 'package:bichos_client/providers/bichos_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}



class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Animal>> imagesList = ref.watch(
        animalsListProvider);

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Central do Resgate')),
            body: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: kIsWeb ? 5 : 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: imagesList.value?.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: switch (imagesList) {
                        AsyncData(:final value) =>  GestureDetector(
                          onTap: () => showImageDialog(context, value[index]),
                          child: Image.memory(value[index].picture),
                        ),
                        AsyncError(:final error) => Text('error: $error'),
                        _ => const Center(child: CircularProgressIndicator())
                      }
                  );
                }
            )
        )
    );
  }

  void showImageDialog(BuildContext context, Animal animal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
                children: [
              Expanded(child: Image.memory(animal.picture)),
              Text(animal.comment,style: const TextStyle(fontSize: 30)),
              OutlinedButton(onPressed: () { _launchURL(animal.page); },
              child: Text(animal.page, style: const TextStyle(fontSize: 30)))
            ]
            ),
          ),
        );
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
