import 'package:bichos_client/data/bichos_repository.dart';
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
  for (final fileList in fileLists) {
    final reversedList = fileList.reversed.toList();
    final pagingList = reversedList.sublist(pageKey, pageKey + pageSize);
    final results = await Future.wait([
      createImagesList(pagingList),
      createCommentsList(pagingList)
    ]);
    List<Animal> imagesList = results[0] as List<Animal>;
    List<Comment> commentsList = results[1] as List<Comment>;

    imagesList = setImageComment(commentsList, imagesList);

    combinedListsImages.addAll(imagesList);
  }

  fullPicturesListCount += combinedListsImages.length;

  final isLastPage = fullPicturesListCount == combinedListsImages.length;
  if (isLastPage) {
    ref.read(animalsPagingProvider).appendLastPage(combinedListsImages);
  } else {
    final nextPageKey = pageKey + pageSize;
    ref.read(animalsPagingProvider).appendPage(combinedListsImages, nextPageKey);
  }
}

@riverpod
Future<List<List<String>>> fileLists(FileListsRef ref) async {
  return getFileLists();
}

