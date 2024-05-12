import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

class Animal {
  final Uint8List picture;
  final String page;
  final String comment;

  Animal({required this.picture, required this.page, required this.comment});
}
