import 'package:bichosclient/presentation/bichos_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/bichos_location.dart';


void main() {
  runApp(
    ProviderScope(
      child: BichosApp(),
    ),
  );
}

class BichosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bichos Perdidos',
      initialRoute: '/location',
      routes: {
        '/location': (context) => LocationDialog(),
        '/bichos_list': (context) => const BichosList(),
      },
    );
  }
}