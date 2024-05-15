import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

/// Flutter code sample for [PageView].

class PicsPageView extends StatefulWidget {
  const PicsPageView({super.key, required this.pictures});
  final List<Uint8List> pictures;

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
          size: const Size(16,16),
        ),
        widget.pictures.isNotEmpty ? Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (_currentPageIndex > 0) {
                _pageViewController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ) : Container(),
        widget.pictures.isNotEmpty ? Positioned(
          right: 10,
          top: 0,
          bottom: 0,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              if (_currentPageIndex < widget.pictures.length - 1) {
                _pageViewController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ) : Container(),
      ],
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    if (!_isOnDesktopAndWeb) {
      return;
    }
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
    _tabController.index = currentPageIndex;
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
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
