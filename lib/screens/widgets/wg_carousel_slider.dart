import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WgCarouselSlider extends StatelessWidget {
  final List<String> crouselImages;
  final Function(int) onTap;
  const WgCarouselSlider(
      {super.key, required this.crouselImages, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: crouselImages.length,
      options: CarouselOptions(
          height: 15.0.h,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(seconds: 1),
          viewportFraction: 0.8),
      itemBuilder: (context, index, realIndex) {
        return InkWell(
          onTap: () {
            onTap(index);
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  crouselImages[index],
                  height: 25.h,
                  width: 250.w,
                  fit: BoxFit.fill,
                )),
          ),
        );
      },
    );
  }
}
