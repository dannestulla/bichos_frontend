import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../credentials.dart';
import 'package:csv/csv.dart';

import '../domain/models/file.dart';
import '../main.dart';


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

Future<List<List<String>>> downloadFileList() async {
  List<List<String>> csvList = [];
  for (final page in pages) {
    final uri = Uri.parse("$bucketUrl/$page.csv");
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $secretAccessKey'
    });
    final csvString = response.body;
    final List<List<dynamic>> csvData = const CsvToListConverter().convert(csvString);
    final List<String> csvStringList = csvData.map((row) => row.join(',')).toList();
    csvList.add((csvStringList).toList());
  }
  return csvList;
}