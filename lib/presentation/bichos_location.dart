import 'package:bichosclient/domain/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationDialog extends ConsumerStatefulWidget {
  LocationDialog({super.key});

  bool isDialogDismissed = false;

  @override
  ConsumerState createState() => _LocationDialogState();
}

class _LocationDialogState extends ConsumerState<LocationDialog> {
  @override
  Widget build(BuildContext context) {
    final cities = ref.watch(locationDialogProvider);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(7),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Onde deseja procurar animais perdidos?",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Container(height: 10),
                ...cities.keys.map(
                  (key) {
                    return CheckboxListTile(
                        title: Text(key),
                        value: cities[key],
                        onChanged: (bool? value) {
                          setState(() {
                            cities[key] = value!;
                            ref
                                .watch(locationDialogProvider.notifier)
                                .toggle(cities);
                          });
                        });
                  },
                ),
                Container(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref.watch(locationDialogProvider.notifier).toggle(cities);
                    widget.isDialogDismissed = true;
                    Navigator.pushNamed(context, '/bichos_list');
                  },
                  child: const Text("Confirmar",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                //CheckboxListTile(title: Text("São Leopoldo, Novo Hamburgo, Campo Bom"), value: , onChanged: (bool? value) {}),
              ]),
        ),
      ),
    );
  }
}
