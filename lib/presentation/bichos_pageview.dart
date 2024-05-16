import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

/// Flutter code sample for [PageView].

class PicsPageView extends StatefulWidget {
  const PicsPageView({super.key, required this.pictures, required this.screenSize});

  final List<Uint8List> pictures;
  final Size screenSize;

  @override
  State<PicsPageView> createState() => _PicsPageViewState();
}

class _PicsPageViewState extends State<PicsPageView>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: widget.pictures.length, vsync: this);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            PageView.builder(
              scrollBehavior: MyCustomScrollBehavior(),
              controller: _pageViewController,
              onPageChanged: _handlePageViewChanged,
              itemCount: widget.pictures.length,
              itemBuilder: (context, index) {
                return Image.memory(widget.pictures[index]);
              },
            ),
            PageViewDotIndicator(
              currentItem: _currentPageIndex,
              count: widget.pictures.length,
              unselectedColor: Colors.black26,
              selectedColor: Colors.blue,
              size: const Size(12, 8),
            )]);
  }

  void _handlePageViewChanged(int currentPageIndex) {
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
    _tabController.index = currentPageIndex;
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
