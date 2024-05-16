
import '../../data/bichos_repository.dart';
import '../models/animal.dart';
import '../models/comment.dart';

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
