import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/models/animal.dart';
import 'bichos_pageview.dart';

void showImageDialog(BuildContext context, Animal animal) {
  final screenSize = MediaQuery.of(context).size;
  showDialog(

    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
              padding: const EdgeInsets.all(7),
              constraints: BoxConstraints(
                maxWidth: screenSize.width * 0.9,
                maxHeight: screenSize.height * 0.9,
              ),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: PicsPageView(
                          pictures: animal.pictures,
                          screenSize: screenSize)),
                      Container(height: 20),
                      Text("Data da postagem: ${animal.date}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Container(height: 10),
                      animal.comment != null
                          ? Text(animal.comment!,
                              style: const TextStyle(fontSize: 16))
                          : Container(),
                      Container(height: 10),
                      OutlinedButton(
                          onPressed: () {
                            _launchURL(animal.page);
                          },
                          child: Text("@${animal.page}",
                              style: const TextStyle(fontSize: 18)))
                    ]),
              ),
            ),
      );
    },
  );
}

void _launchURL(String page) async {
  final fullLink = "https://www.instagram.com/$page";
  if (!await launchUrl(Uri.parse(fullLink))) {
    throw 'Could not launch $fullLink';
  }
}
