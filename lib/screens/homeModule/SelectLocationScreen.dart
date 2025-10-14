import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sizer/sizer.dart';

import '../../utils/widgets/SavedAddressBottomSheet.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController? _map;
  LatLng? _initial;
  LatLng? _cameraTarget;
  bool _loading = true;
  bool _resolving = false;
  String _address = "";

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // 1) permissions
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
    }
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever || perm == LocationPermission.denied) {
      // fallback to a default city center if permission denied
      _initial = const LatLng(22.7196, 75.8577); // Indore
      _cameraTarget = _initial;
      setState(() => _loading = false);
      return;
    }

    // 2) current location
    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _initial = LatLng(pos.latitude, pos.longitude);
    _cameraTarget = _initial;
    setState(() => _loading = false);

    // 3) initial reverse-geocode
    _reverseGeocode(_cameraTarget!);
  }

  Future<void> _reverseGeocode(LatLng point) async {
    setState(() => _resolving = true);
    try {
      final placemarks = await placemarkFromCoordinates(point.latitude, point.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final line = [
          if (p.name != null && p.name!.isNotEmpty) p.name,
          if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality,
          if (p.locality != null && p.locality!.isNotEmpty) p.locality,
          if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty) p.administrativeArea,
          if (p.postalCode != null && p.postalCode!.isNotEmpty) p.postalCode,
          if (p.country != null && p.country!.isNotEmpty) p.country,
        ].join(", ");
        setState(() => _address = line);
      }
    } catch (_) {
      setState(() => _address = "");
    } finally {
      setState(() => _resolving = false);
    }
  }

  void _onCameraMove(CameraPosition pos) {
    _cameraTarget = pos.target;
  }

  void _onCameraIdle() {
    if (_cameraTarget != null) _reverseGeocode(_cameraTarget!);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _initial == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _initial!, zoom: 16.5),
            onMapCreated: (c) => _map = c,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            compassEnabled: false,
            // Optional: if you also want tap-to-drop, keep a marker set and update it in onTap.
          ),

          // Center pin (not a Google marker — draws above the map and feels snappier)
          IgnorePointer(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.location_pin, size: 44, color: Colors.green,),       // red pin
                  SizedBox(height: 2),
                ],
              ),
            ),
          ),

          // Bottom sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, -2))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select your location",style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.place, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _resolving
                                ? "Finding address…"
                                : (_address.isEmpty ? "Move the map to select location" : _address),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
                          ),
                        ),
                      /*  TextButton(onPressed: () async {
                          // if you want a search screen, push it here
                        }, child: const Text("Change")),*/
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_cameraTarget == null) return;
                      final sel = _cameraTarget!;

                      /// Address bottom sheet
                      showAddressBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAF1A),
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Select location", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
