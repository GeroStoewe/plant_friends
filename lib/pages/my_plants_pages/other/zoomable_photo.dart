import 'package:flutter/material.dart';


class ZoomablePhoto extends StatefulWidget {
  final String imageUrl;

  const ZoomablePhoto({super.key, required this.imageUrl});

  @override
  _ZoomablePhotoState createState() => _ZoomablePhotoState();
}

class _ZoomablePhotoState extends State<ZoomablePhoto> {
  final TransformationController _transformationController = TransformationController();
  double _currentScale = 1.0;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InteractiveViewer(
          transformationController: _transformationController,
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 1.0,
          maxScale: 4.0,
          child: Center(
            child: Image.network(
              widget.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
