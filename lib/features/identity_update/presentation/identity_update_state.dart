import '../../../capabilities/ocr/ocr_result.dart';

class IdentityUpdateState {
  const IdentityUpdateState({
    this.scanning = false,
    this.submitting = false,
    this.identity,
    this.stepText = '等待 OCR',
  });
  final bool scanning;
  final bool submitting;
  final OcrResult? identity;
  final String stepText;

  IdentityUpdateState copyWith({
    bool? scanning,
    bool? submitting,
    OcrResult? identity,
    String? stepText,
  }) => IdentityUpdateState(
    scanning: scanning ?? this.scanning,
    submitting: submitting ?? this.submitting,
    identity: identity ?? this.identity,
    stepText: stepText ?? this.stepText,
  );
}
