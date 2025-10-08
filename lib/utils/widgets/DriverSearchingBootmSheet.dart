import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DriverSearchingBottomSheet extends StatefulWidget {
  final String statusText;
  const DriverSearchingBottomSheet({super.key, required this.statusText});

  @override
  State<DriverSearchingBottomSheet> createState() =>
      _DriverSearchingBottomSheetState();
}

class _DriverSearchingBottomSheetState
    extends State<DriverSearchingBottomSheet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xffFFF6F6),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pulsing animation effect
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer ripple circles
              ScaleTransition(
                scale: Tween(begin: 1.0, end: 1.3).animate(
                  CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                ),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade100.withOpacity(0.3),
                  ),
                ),
              ),
              ScaleTransition(
                scale: Tween(begin: 1.0, end: 1.5).animate(
                  CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                ),
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade100.withOpacity(0.15),
                  ),
                ),
              ),
              // Center car icon or Lottie
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_taxi, color: Colors.white, size: 30),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            widget.statusText,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
