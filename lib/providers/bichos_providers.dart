import 'dart:convert';
import 'package:bichos_client/models/comment.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../bichos_usecases/bichos_usecases.dart';
import '../credentials.dart';
import '../models/animal.dart';
import 'package:http/http.dart' as http;

part 'bichos_providers.g.dart';

int pageSize = 50;
int? fullPicturesListCount;

@riverpod
PagingController<int, Animal> animalsPaging(AnimalsPagingRef ref) {
  final controller = PagingController<int, Animal>(firstPageKey: 0);
  return controller;
}

@riverpod
Future<void> animalsList(AnimalsListRef ref, int pageKey) async {
  final fileList = (await ref.watch(fileListProvider.future)).reversed;
  final pagingList = fileList.toList().sublist(pageKey, pageKey + pageSize);
  final results = await Future.wait([createImagesList(pagingList), createCommentsList(pagingList)]);
  List<Animal> imagesList = results[0] as List<Animal>;
  List<Comment> commentsList = results[1] as List<Comment>;

  Map<String, String> commentMap = {};
  for (var comment in commentsList) {
    commentMap[comment.fileName!] = comment.comment!;
  }

  for (var image in imagesList) {
    image.comment = commentMap[image.fileName];
  }

  if (fullPicturesListCount == null) {
    List<String> jpgFiles = fileList.where((file) => file.toLowerCase().endsWith('.jpg')).toList();
    fullPicturesListCount = jpgFiles.length;
  }
  final isLastPage = fullPicturesListCount == imagesList.length;
  if (isLastPage) {
    ref.read(animalsPagingProvider).appendLastPage(imagesList);
  } else {
    final nextPageKey = pageKey + imagesList.length;
    ref.read(animalsPagingProvider).appendPage(imagesList, nextPageKey);
  }
}

@riverpod
Future<List<String>> fileList(FileListRef ref) async {
  final url = Uri.parse(worker);
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final fileListResponse = json.decode(response.body);
      List<String> fileList = [];
      for (final item in fileListResponse) {
        fileList.add(item);
      }
      return fileList;
    } else {
      throw Exception('Failed to load file list');
    }
  } catch (e) {
    throw Exception('Failed to load file list: $e');
  }
}

