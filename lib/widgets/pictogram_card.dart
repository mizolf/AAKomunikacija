import 'package:flutter/material.dart';
import 'package:ict_aac/models/pictogram.dart';

class PictogramCard extends StatelessWidget {
  PictogramCard({super.key, required this.pictogram});

  final Pictogram pictogram;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Text(
            pictogram.label,
            style: const TextStyle().copyWith(
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                pictogram.image,
                scale: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
