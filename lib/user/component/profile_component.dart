// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ProfileComponent extends StatelessWidget {
  String imgUrl;
  double? width;
  double? height;
  ProfileComponent({
    Key? key,
    required this.imgUrl,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imgUrl,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }
}
