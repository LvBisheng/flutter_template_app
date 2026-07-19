class CustomerProfile {
  const CustomerProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.status,
    required this.industryCode,
    required this.industryName,
    required this.professionCode,
    required this.professionName,
    required this.birthday,
    required this.lastUpdatedAt,
  });

  final String id;
  final String name;
  final String email;
  final String mobile;
  final String status;
  final String? industryCode;
  final String? industryName;
  final String? professionCode;
  final String? professionName;
  final DateTime? birthday;
  final DateTime lastUpdatedAt;

  CustomerProfile copyWith({
    String? name,
    String? email,
    String? mobile,
    String? industryCode,
    String? industryName,
    String? professionCode,
    String? professionName,
    DateTime? birthday,
  }) => CustomerProfile(
    id: id,
    name: name ?? this.name,
    email: email ?? this.email,
    mobile: mobile ?? this.mobile,
    status: status,
    industryCode: industryCode ?? this.industryCode,
    industryName: industryName ?? this.industryName,
    professionCode: professionCode ?? this.professionCode,
    professionName: professionName ?? this.professionName,
    birthday: birthday ?? this.birthday,
    lastUpdatedAt: lastUpdatedAt,
  );
}
