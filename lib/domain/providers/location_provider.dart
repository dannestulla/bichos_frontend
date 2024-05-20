import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../config.dart';
part 'location_provider.g.dart';


Map<String, bool> checkedCities = {};
@riverpod
class LocationDialog extends _$LocationDialog {
  @override
  Map<String, bool> build() {
    if (checkedCities.isEmpty) {
      for (final city in cities) {
        checkedCities[city] = false;
      }
      state = checkedCities;
    }
    return checkedCities;
  }

  void toggle(Map<String, bool> newPages) {
    checkedCities = newPages;
    state = newPages;
  }
}