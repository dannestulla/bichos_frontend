import 'package:bichosclient/domain/use_cases/process_comments.dart';
import 'package:bichosclient/domain/use_cases/process_images.dart';

import '../../config.dart';
import '../../data/bichos_repository.dart';
import '../models/animal.dart';
import '../models/comment.dart';



Future<List<Animal>> createAnimalsList(List<String> fileList, int pageKey, Map<String, bool> pagesSelection) async {
  List<Animal> combinedListsImages = [];
  List<String> alreadyDownloaded = [];

  fileList = removeUnselectedPages(fileList, pagesSelection);

  List<String> pagingList = setPagedList(fileList, pageKey);

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

Future<List<String>> getFileLists() async {
  final fileLists = await downloadFileList();
  final ignoredFiles = await downloadIgnoredFiles();
  final filteredFileList = fileLists.where((file) => !ignoredFiles.contains(file.split(".")[0])).toList();
  return filteredFileList;
}

List<String> removeUnselectedPages(List<String> fileList, Map<String, bool> pagesSelection) {
  final newList = fileList.where((element) {
    return pagesSelection[element.split("/")[0]] == true;
  }).toList();
  return newList;
}