import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../use_cases/create_file_list.dart';
import '../models/animal.dart';
import '../use_cases/utils.dart';

part 'bichos_providers.g.dart';

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

    List<Future<List<Animal>>> futures = [];

    for (final fileList in fileLists) {
      futures.add(createFileList(fileList, pageKey));
    }

    final posts = await Future.wait(futures);
    List<Animal> combinedPosts = posts.expand((subList) => subList).toList();

    combinedPosts.sort((a, b) {
      DateTime dateA = DateTime.parse(convertToISOFormat(a.date));
      DateTime dateB = DateTime.parse(convertToISOFormat(b.date));
      return dateA.compareTo(dateB);
    });

    combinedPosts = combinedPosts.reversed.toList();
    fullPicturesListCount += combinedPosts.length;

    final nextPageKey = pageKey + pageSize;
    ref
        .read(animalsPagingProvider)
        .appendPage(combinedPosts, nextPageKey);

}

@riverpod
Future<List<List<String>>> fileLists(FileListsRef ref) async {
  return getFileLists();
}
