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
          child: Column(children: [
            Text('Bichos-Perdidos.org'),
            Text("Página dedicada à centralizar informações dos seguintes perfis do Instagram:")
          ],
        )),
        ...pages.keys.map(
          (key) {
            return CheckboxListTile(
                title: Text(key),
                value: pages[key],
                onChanged: (bool? value) {
                  setState(() {
                    pages[key] = value!;
                    ref.watch(drawerPageSelectionProvider.notifier).toggle(pages);
                    ref.watch(animalsPagingProvider).refresh();
                  });
                });
          },
        ),
      ]),
    );
  }
}
