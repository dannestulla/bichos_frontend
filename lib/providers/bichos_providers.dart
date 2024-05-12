import 'dart:typed_data';
import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../credentials.dart';
import '../models/animal.dart';

part 'bichos_providers.g.dart';


@riverpod
Future<List<Animal>> animalsList(AnimalsListRef ref) async {
  List<Animal> imagesList = [];
  final fileList = await fetchFileList();
  for (final fullPath in fileList) {
    final pageName = fullPath.split("/")[1];
    final fileName = fullPath.split("/")[2];
    Uint8List picture = await downloadImage(pageName, fileName);
    imagesList.add(Animal(
        picture: picture,
        page: pageName,
        comment: ""
    ));
  }
  return imagesList;
}

Future<List<String>> fetchFileList() async {
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

Future<Uint8List> downloadImage(String bucketId, String fileName) async {
  final uri = Uri.parse('$bucketUrl%2F$bucketId%2F$fileName');
  final response = await http.get(uri, headers: {
    'Authorization': 'Bearer $secretAccessKey'
  });
  Uint8List imageData = Uint8List.fromList(response.body.codeUnits);
  return imageData;
}
