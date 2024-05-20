import 'package:bichosclient/config.dart';
import 'package:bichosclient/domain/providers/drawer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/providers/animals_providers.dart';

class BichosDrawer extends ConsumerStatefulWidget {
  const BichosDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BichosDrawer();
}

class _BichosDrawer extends ConsumerState<BichosDrawer> {
  @override
  Widget build(BuildContext context) {
    final pages = ref.watch(drawerPageSelectionProvider);
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightBlue,
            ),
            child: Column(
              children: [
                Text('Bichos-Perdidos.org'),
                Text(
                    "Centraliza informações dos seguintes perfis do Instagram:")
              ],
            )),
        const ListTile(
            title: Text(canoas,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        ...pagesCanoas.map(
          (key) {
            return CheckboxListTile(
                title: Text(key, style: TextStyle(fontSize: 14)),
                value: pages[key] ?? false,
                onChanged: (bool? value) {
                  setState(() {
                    pages[key] = value!;
                    ref
                        .watch(drawerPageSelectionProvider.notifier)
                        .toggle(pages);
                    ref.watch(animalsPagingProvider).refresh();
                  });
                });
          },
        ),
        const ListTile(
            title: Text(portoAlegre,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        ...pagesPoa.map(
          (key) {
            return CheckboxListTile(
                title: Text(key, style: TextStyle(fontSize: 14)),
                value: pages[key] ?? false,
                onChanged: (bool? value) {
                  setState(() {
                    pages[key] = value!;
                    ref
                        .watch(drawerPageSelectionProvider.notifier)
                        .toggle(pages);
                    ref.watch(animalsPagingProvider).refresh();
                  });
                });
          },
        ),
        const ListTile(
            title: Text(saoLeo,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        ...pagesSaoLeo.map(
          (key) {
            return CheckboxListTile(
                title: Text(key, style: TextStyle(fontSize: 14)),
                value: pages[key] ?? false,
                onChanged: (bool? value) {
                  setState(() {
                    pages[key] = value!;
                    ref
                        .watch(drawerPageSelectionProvider.notifier)
                        .toggle(pages);
                    ref.watch(animalsPagingProvider).refresh();
                  });
                });
          },
        ),
      ]),
    );
  }
}
