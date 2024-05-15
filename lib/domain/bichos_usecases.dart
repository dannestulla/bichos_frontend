import 'dart:async';
import 'dart:typed_data';
import '../data/bichos_repository.dart';
import 'models/animal.dart';
import 'models/comment.dart';
import 'models/file.dart';

Future<List<Animal>> createImagesList(List<String> pagingList) async {
  List<Animal> imagesList = [];
  String previousImageName = "";
  List<Uint8List> picturesFolder = [];
  List<String> fileNames = [];

  for (final item in pagingList) {
    if (item.contains('.jpg')) {
      final fileNameSplit = item.split("/");
      final file = File(fileNameSplit[0], fileNameSplit[1]);
      final picture = await downloadImage(file);
      if (isAnimalInSameFolder(file.fileName, previousImageName)) {
        // adds to folder and proceeds to next picture
        picturesFolder.add(picture);
        fileNames.add(file.fileName.replaceAll(".jpg", ""));
      } else {
        if (picturesFolder.isNotEmpty) {
          // adds single animal
          imagesList.add(Animal(
              pictures: picturesFolder,
              page: file.page,
              fileNames: fileNames,
              date: getDate(file.fileName)));
        }
        // adds list of animals
        imagesList.add(Animal(
            pictures: [picture],
            page: file.page,
            fileNames: [file.fileName.replaceAll(".jpg", "")],
            date: getDate(file.fileName)));
        picturesFolder = [];
        fileNames = [];
      }
      previousImageName = file.fileName;
    }
  }
  return imagesList;
}

Future<List<Comment>> createCommentsList(List<String> pagingList) async {
  List<Comment> commentsList = [];
  for (final fileName in pagingList) {
    if (fileName.contains(".txt")) {
      final fileNameSplit = fileName.split("/");
      String comment =
          await downloadComment(fileNameSplit[0], fileNameSplit[1]);
      commentsList.add(Comment(comment, fileName.replaceAll(".txt", "")));
    }
  }
  return commentsList;
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

List<Animal> setImageComment(
    List<Comment> commentsList, List<Animal> imagesList) {
  List<Animal> imageWithComment = imagesList;
  Map<String, String> commentMap = {};
  for (var comment in commentsList) {
    commentMap[comment.fileName.split("/").last] = comment.comment!;
  }
  for (final image in imageWithComment) {
    for (final fileName in image.fileNames) {
      image.comment = commentMap[fileName];
    }
  }
  return imageWithComment;
}

String getDate(String fileName) {
  final nameList = fileName.split("-");
  final splitDay = nameList[2].split("_")[0];
  return "$splitDay-${nameList[1]}-${nameList[0]}";
}

bool isAnimalInSameFolder(String fileName, String previousImageName) {
  // Checks if image belongs to same group of images
  int index = fileName.indexOf("UTC");
  String basePrefix = fileName.substring(0, index + 3);
  return previousImageName.startsWith(basePrefix);
}
