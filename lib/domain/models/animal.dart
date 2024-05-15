import 'dart:typed_data';

class Animal {
  final List<Uint8List> pictures;
  final String page;
  String? comment;
  final List<String> fileNames;
  final String date;

  Animal({required this.pictures, required this.page, required this.fileNames, this.comment, required this.date});
}
