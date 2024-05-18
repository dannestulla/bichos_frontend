import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config.dart';
import '../../main.dart';
part 'drawer_provider.g.dart';


Map<String, bool> checkedPages = {};
@riverpod
class DrawerPageSelection extends _$DrawerPageSelection {
  @override
  Map<String, bool> build() {
    if (checkedPages.isEmpty) {
      for (final page in pages) {
        checkedPages[page] = true;
      }
      state = checkedPages;
    }
    return checkedPages;
  }

  void toggle(Map<String, bool> newPages) {
    checkedPages = newPages;
    state = newPages;
  }
}