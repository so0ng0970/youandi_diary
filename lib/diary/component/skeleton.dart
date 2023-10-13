import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonComponent extends StatelessWidget {
  const SkeletonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(color: Colors.white),
      child: SkeletonItem(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: const [
                  Expanded(
                    child: SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        height: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                        shape: BoxShape.circle, width: 50, height: 50),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: double.infinity,
                  height: 150,
                ),
              ),
              const SizedBox(height: 12),
              SkeletonParagraph(
                style: SkeletonParagraphStyle(
                    lines: 3,
                    spacing: 6,
                    lineStyle: SkeletonLineStyle(
                      randomLength: true,
                      height: 10,
                      borderRadius: BorderRadius.circular(8),
                      minLength: MediaQuery.of(context).size.width / 2,
                    )),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  SizedBox(width: 12),
                  SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      shape: BoxShape.circle,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  SizedBox(width: 12),
                  SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      height: 20,
                      width: 268,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                      lines: 2,
                      spacing: 6,
                      lineStyle: SkeletonLineStyle(
                        randomLength: true,
                        height: 10,
                        borderRadius: BorderRadius.circular(8),
                        minLength: MediaQuery.of(context).size.width / 2,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
