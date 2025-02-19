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

  void _zoomIn() {
    setState(() {
      _currentScale = (_currentScale * 1.2).clamp(1.0, 4.0);
      _transformationController.value = Matrix4.identity()..scale(_currentScale);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentScale = (_currentScale / 1.2).clamp(1.0, 4.0);
      _transformationController.value = Matrix4.identity()..scale(_currentScale);
    });
  }

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
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the buttons horizontally
            children: [
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                onPressed: _zoomOut,
                child: const Icon(Icons.zoom_out, color: Colors.black),
              ),
              const SizedBox(width: 16), // Space between buttons
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                onPressed: _zoomIn,
                child: const Icon(Icons.zoom_in, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

///
/// TODO: remove the zoom in and out buttons
///