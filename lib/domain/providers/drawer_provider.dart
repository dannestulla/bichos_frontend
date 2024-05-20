import 'package:bichosclient/domain/providers/location_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../config.dart';
part 'drawer_provider.g.dart';


Map<String, bool> checkedPages = {};
@riverpod
class DrawerPageSelection extends _$DrawerPageSelection {
  @override
  Map<String, bool> build() {
    if (checkedPages.isEmpty) {
      if (checkedCities[canoas] == true) {
        for (final page in pagesCanoas) {
          checkedPages[page] = true;
        }
      }
      if (checkedCities[portoAlegre] == true) {
        for (final page in pagesPoa) {
          checkedPages[page] = true;
        }
      }
      if (checkedCities[saoLeo] == true) {
        for (final page in pagesSaoLeo) {
          checkedPages[page] = true;
        }
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
