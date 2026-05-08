import 'ocr_result.dart';
import 'ocr_service.dart';

class MockOcrService implements OcrService {
  @override
  Future<OcrResult> scanIdentityCard() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return OcrResult(
      idName: 'Demo Holder',
      idNumber: 'ID-MOCK-000001',
      birthday: DateTime(1990, 1, 1),
      expiryDate: DateTime(2035, 12, 31),
    );
  }
}
