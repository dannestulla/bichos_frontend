import 'dart:async';
import 'dart:typed_data';
import 'package:bichos_client/domain/use_cases/utils.dart';
import '../../data/bichos_repository.dart';
import '../models/animal.dart';
import '../models/file.dart';

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
