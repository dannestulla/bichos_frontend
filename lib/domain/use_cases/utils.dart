

String getDate(String fileName) {
  final nameList = fileName.split("-");
  final splitDay = nameList[2].split("_")[0];
  return "$splitDay-${nameList[1]}-${nameList[0]}";
}

String convertToISOFormat(String date) {
  List<String> parts = date.split("-");
  return "${parts[2]}-${parts[1]}-${parts[0]}";
}

bool isAnimalInSameFolder(String fileName, String previousImageName) {
  // Checks if image belongs to same group of images
  int index = fileName.indexOf("UTC");
  String basePrefix = fileName.substring(0, index + 3);
  return previousImageName.startsWith(basePrefix);
}
