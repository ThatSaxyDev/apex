import 'package:apex/utils/string_extensions.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width(context) * 0.6,
      child: CarouselSlider(
        items: carouselImages.map(
          (i) {
            return Builder(
              builder: (BuildContext context) => Image.asset(
                i.jpg,
                fit: BoxFit.cover,
                height: 200.h,
              ),
            );
          },
        ).toList(),
        options: CarouselOptions(
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          autoPlay: true,
          viewportFraction: 1,
          height: 200.h,
        ),
      ),
    );
  }
}

List<String> carouselImages = ['ad1', 'ad2', 'ad3', 'ad4', 'ad5'];
