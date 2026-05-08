class CustomerSummary {
  const CustomerSummary({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.status,
    required this.lastUpdatedAt,
  });
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String status;
  final DateTime lastUpdatedAt;
}
