import 'package:bichosclient/domain/providers/drawer_provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../config.dart';
import '../use_cases/create_file_list.dart';
import '../models/animal.dart';
import '../use_cases/utils.dart';

part 'animals_providers.g.dart';

int currentPosition = 0;
int fullPicturesListCount = 0;

@riverpod
PagingController<int, Animal> animalsPaging(AnimalsPagingRef ref) {
  final controller = PagingController<int, Animal>(firstPageKey: 0);
  return controller;
}

@riverpod
Future<void> animalsList(AnimalsListRef ref, int pageKey) async {
    final fileLists = await ref.watch(fileListsProvider.future);
    final pagesSelection = ref.watch(drawerPageSelectionProvider);
    final combinedPosts = await createAnimalsList(fileLists, pageKey, pagesSelection);

    combinedPosts.sort((a, b) {
      DateTime dateA = DateTime.parse(convertToISOFormat(a.date));
      DateTime dateB = DateTime.parse(convertToISOFormat(b.date));
      return dateA.compareTo(dateB);
    });

    fullPicturesListCount += combinedPosts.length;

    if (combinedPosts.isEmpty) {
      ref.read(animalsPagingProvider).appendLastPage([]);
    } else {
      final nextPageKey = pageKey + pageSize;
      ref
          .read(animalsPagingProvider)
          .appendPage(combinedPosts, nextPageKey);
    }
}

@riverpod
Future<List<String>> fileLists(FileListsRef ref) async {
  final filesLists = await getFileLists();
  return filesLists;
}

