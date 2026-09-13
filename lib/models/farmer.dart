class Farmer {
  const Farmer({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.village,
    required this.farmSizeAcres,
  });

  final int id;
  final String fullName;
  final String phone;
  final String village;
  final double farmSizeAcres;

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: (json['id'] as num).toInt(),
      fullName: json['full_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      village: json['village']?.toString() ?? '',
      farmSizeAcres: (json['farm_size_acres'] as num?)?.toDouble() ?? 0,
    );
  }
}
