import 'package:bichos_client/domain/use_cases/process_comments.dart';
import 'package:bichos_client/domain/use_cases/process_images.dart';

import '../../data/bichos_repository.dart';
import '../models/animal.dart';
import '../models/comment.dart';

const pageSize = 20;

Future<List<Animal>> createFileList(List<String> fileList, int pageKey, Map<String, bool> pagesSelection) async {
  List<Animal> combinedListsImages = [];
  List<String> alreadyDownloaded = [];

  fileList = removeUnselectedPages(fileList, pagesSelection);

  final reversedList = fileList.reversed.toList();
  List<String> pagingList = setPagedList(reversedList, pageKey);

  pagingList.removeWhere((element) => alreadyDownloaded.contains(element));
  alreadyDownloaded += pagingList;
  final results = await Future.wait(
      [createImagesList(pagingList), createCommentsList(pagingList)]);
  List<Animal> imagesList = results[0] as List<Animal>;
  List<Comment> commentsList = results[1] as List<Comment>;
  imagesList = setImageComment(commentsList, imagesList);
  combinedListsImages.addAll(imagesList);
  return combinedListsImages;
}

List<String> setPagedList(List<String> reversedList, int initialPosition) {
  List<String> pagingList = [];
  int endPosition = initialPosition + pageSize;
  if (initialPosition > reversedList.length) return [];
  if (reversedList.length < endPosition) endPosition = reversedList.length;
  pagingList = reversedList.sublist(initialPosition, endPosition);
  return pagingList;
}

Future<List<List<String>>> getFileLists() async {
  final fileLists = await downloadFileList();
  List<List<String>> newLists = [];
  List<String> list = [];
  for (final fileList in fileLists) {
    for (final file in fileList) {
      list.add(file.split("\\").last);
    }
    newLists.add(fileList);
  }
  return newLists;
}

List<String> removeUnselectedPages(List<String> fileList, Map<String, bool> pagesSelection) {
  final page = fileList[0].split("/")[0];
  if (pagesSelection[page] == false) {
    return [];
  }
  return fileList;
}