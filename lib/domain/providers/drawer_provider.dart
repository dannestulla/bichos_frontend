import 'package:bichos_client/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'drawer_provider.g.dart';


@riverpod
class DrawerPageSelection extends _$DrawerPageSelection {
  @override
  Map<String, bool> build() {
    Map<String, bool> checkedPages = {};
    for (final page in pages) {
      checkedPages[page] = true;
    }
    state = checkedPages;
    return checkedPages;
  }

  void toggle(Map<String, bool> newPages) {
    state = newPages;
  }
}