class DriverInfo {
  final int id;
  final String bookingStatus;
  final String driverName;
  final String licenseNumber;
  final String driverMobile;
  final String profilePic;
  final double rating;
  final int reviews;

  DriverInfo({
    required this.id,
    required this.bookingStatus,
    required this.driverName,
    required this.licenseNumber,
    required this.driverMobile,
    required this.profilePic,
    required this.rating,
    required this.reviews,
  });

  factory DriverInfo.fromMap(Map<String, dynamic> m) {
    return DriverInfo(
      id: m['id'] is int ? m['id'] : int.tryParse("${m['id']}") ?? 0,
      bookingStatus: "${m['bookingStatus']}",
      driverName: "${m['driverName']}",
      licenseNumber: "${m['licenseNumber']}",
      driverMobile: "${m['driverMobile']}",
      profilePic: "${m['profilePic']}",
      rating: m['rating'] is num ? (m['rating'] as num).toDouble() : double.tryParse("${m['rating']}") ?? 0.0,
      reviews: m['reviews'] is int ? m['reviews'] : int.tryParse("${m['reviews']}") ?? 0,
    );
  }
}
