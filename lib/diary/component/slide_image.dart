// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/const/color.dart';

class SlideImage extends StatefulWidget {
  final bool? isLoading;
  final List<XFile>? selectedImages;
  final List<String>? imageUrl;
  StateSetter? imgSetState;
  late final Function(bool)? removeEdit;
  SlideImage({
    Key? key,
    this.isLoading,
    this.selectedImages,
    this.imageUrl,
    this.imgSetState,
    this.removeEdit,
  }) : super(key: key);

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.selectedImages?.length ?? widget.imageUrl?.length,
      itemBuilder: (context, index) {
        Widget imageWidget;

        if (widget.selectedImages != null) {
          imageWidget = Image.file(
            File(widget.selectedImages![index].path),
            fit: BoxFit.cover,
          );
        } else if (widget.imageUrl != null) {
          imageWidget = Image.network(
            widget.imageUrl![index],
            fit: BoxFit.cover,
          );
        } else {
          imageWidget = Container();
        }

        return Stack(
          children: [
            Center(child: imageWidget),
            if (!widget.isLoading!)
              Positioned(
                right: 10.0,
                child: IconButton(
                  onPressed: () {
                    widget.imgSetState!(() {
                      if (widget.selectedImages != null) {
                        widget.selectedImages?.removeAt(index);
                      } else if (widget.imageUrl != null) {
                        widget.imageUrl?.removeAt(index);
                        widget.removeEdit!(true);
                      }
                      print(widget.removeEdit);
                    });
                  },
                  icon: const Icon(
                    Icons.remove_circle_outlined,
                    size: 30,
                    color: WHITE_COLOR,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
