import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mock_ocr_service.dart';
import 'ocr_result.dart';

final ocrServiceProvider = Provider<OcrService>((_) => MockOcrService());

/// OCR 能力抽象。
///
/// 页面只依赖接口，不依赖真实 SDK。以后接入厂商 SDK 时替换实现即可，
/// 证件更新页和 UseCase 不需要知道 SDK 初始化、权限、错误码细节。
abstract class OcrService {
  Future<OcrResult> scanIdentityCard();
}
