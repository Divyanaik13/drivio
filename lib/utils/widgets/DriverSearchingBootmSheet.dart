import 'dart:async';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/DriverInfoModel.dart';

class DriverSearchingBottomSheet extends StatefulWidget {
  final String statusText;
  final int initialElapsed; // ⏱ for resume
  final int totalDuration;
  final VoidCallback? onCancelled;

  const DriverSearchingBottomSheet({
    super.key,
    required this.statusText,
    this.initialElapsed = 0,
    this.totalDuration = 120,
    this.onCancelled,
  });

  @override
  DriverSearchingBottomSheetState createState() =>
      DriverSearchingBottomSheetState();
}

class DriverSearchingBottomSheetState extends State<DriverSearchingBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  late int _elapsed;
  String _message = "";
  DriverInfo? _driver;

  // expose so parent can update
  void showAssignedDriver(DriverInfo driver) {
    if (mounted) {
      setState(() {
        _driver = driver;
      });
      _controller.stop();
      _timer.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _elapsed = widget.initialElapsed;
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    _updateMessage();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        _elapsed++;
        _updateMessage();
      });

      // 🔥 auto cancel after totalDuration
      if (_elapsed >= widget.totalDuration) {
        t.cancel();
        _controller.stop();
        setState(() {
          _message = "Sorry, all drivers are busy right now.";
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Get.back(result: "cancelled");
            widget.onCancelled?.call();
          }
        });
      }
    });
  }

  void _updateMessage() {
    if (_elapsed < 45) {
      _message = "Searching for nearby drivers...";
    } else if (_elapsed < 110) {
      _message = "It’s taking a little longer to find a driver...";
    } else {
      _message = "Sorry, all drivers are busy right now.";
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _callDriver(String phone) async {
    final uri = Uri.parse("tel:$phone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _buildStars(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      final diff = rating - i + 1;
      IconData icon;
      if (diff >= 1) {
        icon = Icons.star;
      } else if (diff >= 0.5) {
        icon = Icons.star_half;
      } else {
        icon = Icons.star_border;
      }
      stars.add(Icon(icon, size: 18, color: Colors.amber));
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    final isAssigned = _driver != null;

    return Container(
      height: isAssigned ? 42.h : 35.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xffFFF6F6),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 12.w,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(height: 2.h),

            if (!isAssigned) ...[
              // 🔄 SEARCHING UI (kept same)
              Stack(
                alignment: Alignment.center,
                children: [
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
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_taxi,
                        color: Colors.white, size: 30),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                _message,
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.8.h),
              Text(
                "⏱ ${_elapsed}s",
                style: TextStyle(fontSize: 12.sp, color: Colors.black54),
              ),
            ] else ...[
              // ✅ ASSIGNED DRIVER UI (unchanged)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chip(
                    backgroundColor: Colors.green.shade50,
                    label: Text(
                      _driver!.bookingStatus.toUpperCase(),
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    avatar: Icon(Icons.verified,
                        color: Colors.green.shade700, size: 18),
                    side: BorderSide(color: Colors.green.shade200),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.red.shade50,
                      backgroundImage: NetworkImage(_driver!.profilePic),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_driver!.driverName,
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 0.6.h),
                          Row(
                            children: [
                              _buildStars(_driver!.rating),
                              SizedBox(width: 2.w),
                              Text(
                                "${_driver!.rating.toStringAsFixed(1)} • ${_driver!.reviews} reviews",
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.black54),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.8.h),
                          Text(
                            "License: ${_driver!.licenseNumber}",
                            style: TextStyle(
                                fontSize: 13.sp, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _callDriver(_driver!.driverMobile),
                      icon: const Icon(Icons.call),
                      color: Colors.green,
                    )
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      ),
                      onPressed: () => _callDriver(_driver!.driverMobile),
                      icon: Icon(Icons.call,
                          color: Colors.green, size: 2.5.h),
                      label: Text("Call Driver",
                          style: TextStyle(
                              fontSize: 15.sp, color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 1.6.h),
                      ),
                      onPressed: () {
                        Get.toNamed(RouteHelper().getCardScreen());
                      },
                      icon: Icon(Icons.arrow_forward,
                          color: Colors.green, size: 2.1.h),
                      label: Text("Continue",
                          style: TextStyle(
                              fontSize: 15.sp, color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
