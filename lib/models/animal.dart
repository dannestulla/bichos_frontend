import 'dart:typed_data';

class Animal {
  final Uint8List picture;
  final String page;
  String? comment;
  final String fileName;
  final String date;

  Animal({required this.picture, required this.page, required this.fileName, this.comment, required this.date});
}
