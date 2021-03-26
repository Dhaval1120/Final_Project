import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
class ImageDisplay extends StatefulWidget {
  String imgUrl = '';

  ImageDisplay({this.imgUrl});
  @override
  _ImageDisplayState createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {

  TransformationController controller = TransformationController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black ,width: 3)
            ),
          child: InteractiveViewer(
            transformationController: controller,
            onInteractionEnd: (ScaleEndDetails endDetails){
              controller.value = Matrix4.identity();
            },
            child: Image(image: CachedNetworkImageProvider(widget.imgUrl),
            fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
