import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../credentials.dart';
import '../models/animal.dart';
import '../models/comment.dart';


Future<Uint8List> downloadImage(String bucketId, String fileName) async {
  final uri = Uri.parse('$bucketUrl%2F$bucketId%2F$fileName');
  final response = await http.get(uri, headers: {
    'Authorization': 'Bearer $secretAccessKey'
  });
  Uint8List imageData = Uint8List.fromList(response.body.codeUnits);
  return imageData;
}

Future<String> downloadComment(String bucketId, String fileName) async {
  final uri = Uri.parse('$bucketUrl%2F$bucketId%2F$fileName');
  final response = await http.readBytes(uri, headers: {
    'Authorization': 'Bearer $secretAccessKey'
  });
  String fileContent = utf8.decode(response);
  return fileContent;
}

Future<List<Animal>> createImagesList(List<String> pagingList) async {
  List<Animal> imagesList = [];
  for (final fullPath in pagingList) {
    final pageName = fullPath.split("/")[1];
    final fileName = fullPath.split("/")[2];
    if (fileName.contains('.jpg')) {
      Uint8List picture = await downloadImage(pageName, fileName);
      imagesList.add(Animal(
          picture: picture,
          page: pageName,
          fileName: fileName.replaceAll(".jpg", ""),
          date: getDate(fileName)
      ));
    }
  }
  return imagesList;
}

Future<List<Comment>> createCommentsList(List<String> pagingList) async {
  List<Comment> commentsList = [];
  for (final fullPath in pagingList) {
    final pageName = fullPath.split("/")[1];
    final fileName = fullPath.split("/")[2];
    if (fileName.contains(".txt")) {
      String comment = await downloadComment(pageName, fileName);
      commentsList.add(Comment(comment, fileName.replaceAll(".txt", "")));
    }
  }
  return commentsList;
}

String getDate(String fileName) {
  final nameList = fileName.split("-");
  final splitDay = nameList[2].split("_")[0];
  return "$splitDay-${nameList[1]}-${nameList[0]}";
}