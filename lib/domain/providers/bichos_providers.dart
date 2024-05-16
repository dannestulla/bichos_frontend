import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../bichos_usecases.dart';
import '../models/animal.dart';
import '../models/comment.dart';

part 'bichos_providers.g.dart';

const pageSize = 20;
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
    List<Animal> combinedListsImages = [];
    List<String> alreadyDownloaded = [];
    for (final fileList in fileLists) {
      final reversedList = fileList.reversed.toList();
      List<String> pagingList = [];
      if (reversedList.length < pageKey + pageSize) {
        pagingList = reversedList;
      } else {
        pagingList = reversedList.sublist(pageKey, pageKey + pageSize);
      }
      pagingList.removeWhere((element) => alreadyDownloaded.contains(element));
      alreadyDownloaded += pagingList;
      final results = await Future.wait(
          [createImagesList(pagingList), createCommentsList(pagingList)]);
      List<Animal> imagesList = results[0] as List<Animal>;
      List<Comment> commentsList = results[1] as List<Comment>;
      imagesList = setImageComment(commentsList, imagesList);
      combinedListsImages.addAll(imagesList);
    }
    combinedListsImages.sort((a, b) {
      DateTime dateA = DateTime.parse(convertToISOFormat(a.date));
      DateTime dateB = DateTime.parse(convertToISOFormat(b.date));
      return dateA.compareTo(dateB);
    });

    combinedListsImages = combinedListsImages.reversed.toList();
    fullPicturesListCount += combinedListsImages.length;

    final nextPageKey = pageKey + pageSize;
    ref
        .read(animalsPagingProvider)
        .appendPage(combinedListsImages, nextPageKey);

}

@riverpod
Future<List<List<String>>> fileLists(FileListsRef ref) async {
  return getFileLists();
}
