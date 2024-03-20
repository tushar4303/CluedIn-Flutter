import 'dart:math';

import 'package:flutter/material.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int columns;
  final double imageSize;
  final double spacing;

  const CustomImageGallery({
    super.key,
    required this.imageUrls,
    this.columns = 3,
    this.imageSize = 100.0,
    this.spacing = 8.0,
  });

  @override
  _CustomImageGalleryState createState() => _CustomImageGalleryState();
}

class _CustomImageGalleryState extends State<CustomImageGallery> {
  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double availableWidth =
        screenWidth - (widget.columns - 1) * widget.spacing;
    final double itemWidth =
        (availableWidth - (widget.columns * widget.spacing)) / widget.columns;
    final int rowCount = (widget.imageUrls.length / widget.columns).ceil();
    const int maxImages = 6; // Maximum number of images to show

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: min(widget.imageUrls.length, maxImages),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columns,
        crossAxisSpacing: widget.spacing,
        mainAxisSpacing: widget.spacing,
        childAspectRatio: itemWidth / widget.imageSize,
      ),
      itemBuilder: (BuildContext context, int index) {
        if (index == maxImages - 1 && widget.imageUrls.length > maxImages) {
          // Display the last tile showing remaining photos count
          return GestureDetector(
            onTap: () {
              _showFullGallery(context, maxImages - 1);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey.withOpacity(0.5),
              ),
              child: Center(
                child: Text(
                  '+${widget.imageUrls.length - maxImages + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () {
              _showFullGallery(context, index);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: Colors.transparent, // No border color
                  width: 3.0, // Border width
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrls[index],
                  placeholder: (context, url) {
                    return Image.asset(
                      "assets/images/placeholder.png",
                      fit: BoxFit.cover,
                    );
                  },
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: itemWidth,
                  height: widget.imageSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void _showFullGallery(BuildContext context, int startIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullGallery(
          imageUrls: widget.imageUrls,
          initialIndex: startIndex,
        ),
      ),
    ).then((value) {
      // This code block executes when FullGallery is popped.
      // Set NavbarNotifier.hideBottomNavBar to false.
      NavbarNotifier.hideBottomNavBar = false;
    });

    // Set NavbarNotifier.hideBottomNavBar to true when navigating to FullGallery.
    NavbarNotifier.hideBottomNavBar = true;
  }
}

class FullGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullGallery({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  _FullGalleryState createState() => _FullGalleryState();
}

class _FullGalleryState extends State<FullGallery> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _pageController.addListener(_handlePageChanged);
    // Set NavbarNotifier.hideBottomNavBar to true when initializing FullGallery.
    NavbarNotifier.hideBottomNavBar = true;
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChanged() {
    setState(() {
      _currentIndex = _pageController.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    double initialScrollPosition = (_currentIndex - 1) * (80.0 + 8.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        // actions: [
        //   PopupMenuButton(
        //     itemBuilder: (context) => [
        //       PopupMenuItem(
        //         child: ListTile(
        //           leading: Icon(Icons.share),
        //           title: Text('Share'),
        //           onTap: () {
        //             // Share the current image
        //             ShareAndDownloadFiles.shareFile(
        //                 widget.imageUrls[_currentIndex]);
        //           },
        //         ),
        //       ),
        //       PopupMenuItem(
        //         child: ListTile(
        //           leading: Icon(Icons.file_download),
        //           title: Text('Download'),
        //           onTap: () {
        //             // Download the current image
        //             ShareAndDownloadFiles.downloadFile(
        //                 widget.imageUrls[_currentIndex]);
        //             Fluttertoast.showToast(
        //               msg: "Saved to Downloads",
        //               toastLength: Toast.LENGTH_SHORT,
        //               gravity: ToastGravity.BOTTOM,
        //               timeInSecForIosWeb: 1,
        //             );
        //           },
        //         ),
        //       ),
        //     ],
        //   ),
        // ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                PhotoViewGallery.builder(
                  itemCount: widget.imageUrls.length,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      minScale: PhotoViewComputedScale.contained * 1.0,
                      imageProvider:
                          CachedNetworkImageProvider(widget.imageUrls[index]),
                      initialScale: PhotoViewComputedScale.contained,
                      heroAttributes: PhotoViewHeroAttributes(tag: index),
                    );
                  },
                  scrollPhysics: const BouncingScrollPhysics(),
                  pageController: _pageController,
                  scaleStateChangedCallback: (state) {
                    if (state == PhotoViewScaleState.originalSize) {
                      _currentIndex = _pageController.page!.round();
                    }
                  },
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 60.0,
                    color: Colors.black.withOpacity(0.5),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.imageUrls.length,
                      controller: ScrollController(
                          initialScrollOffset: initialScrollPosition),
                      itemBuilder: (context, index) {
                        final imageUrl = widget.imageUrls[index];
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: index == _currentIndex
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7.0),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  width: 60.0,
                                  height: 58.0,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) {
                                    return Image.asset(
                                      "assets/images/placeholder.png",
                                      fit: BoxFit.cover,
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Add PopupMenuButton in the AppBar actions
    );
  }
}
