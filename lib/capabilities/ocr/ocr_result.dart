class OcrResult {
  const OcrResult({
    required this.idName,
    required this.idNumber,
    required this.birthday,
    required this.expiryDate,
  });
  final String idName;
  final String idNumber;
  final DateTime birthday;
  final DateTime expiryDate;
}
