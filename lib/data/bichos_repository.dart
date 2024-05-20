import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../credentials.dart';
import 'package:csv/csv.dart';

import '../domain/models/file.dart';
import '../presentation/bichos_list.dart';


Future<Uint8List> downloadImage(File file) async {
  final uri = Uri.parse('$bucketUrl%2F${file.page}%2F${file.fileName}');
  final response = await http.get(uri, headers: {
    'Authorization': 'Bearer $secretAccessKey'
  });
  Uint8List imageData = Uint8List.fromList(response.body.codeUnits);
  return imageData;
}

Future<String> downloadComment(String pageName, String fileName) async {
  final uri = Uri.parse('$bucketUrl%2F$pageName%2F$fileName');
  final response = await http.readBytes(uri, headers: {
    'Authorization': 'Bearer $secretAccessKey'
  });
  String fileContent = utf8.decode(response);
  return fileContent;
}

Future<List<String>> downloadFileList() async {
  final uri = Uri.parse("$bucketUrl/combined_pages_data.csv");
  final response = await http.get(uri, headers: {
    'Authorization': 'Bearer $secretAccessKey'
  });
  final csvString = response.body.split("\r\n");

  return csvString;
}

Future<List<String>> downloadIgnoredFiles() async {
  List<String> csvString = [];
  try {
    final uri = Uri.parse("$bucketUrl/ignored_files.csv");
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $secretAccessKey'
    });
    csvString = response.body.split("\r\n");
  } catch (error) {
    print(error);
  }
  return csvString;
}