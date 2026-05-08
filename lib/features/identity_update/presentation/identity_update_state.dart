import '../../../capabilities/ocr/ocr_result.dart';

enum IdentityUpdateStep {
  waitingOcr,
  scanning,
  ocrCompleted,
  signing,
  completed,
}

class IdentityUpdateState {
  const IdentityUpdateState({
    this.scanning = false,
    this.submitting = false,
    this.identity,
    this.step = IdentityUpdateStep.waitingOcr,
  });
  final bool scanning;
  final bool submitting;
  final OcrResult? identity;
  final IdentityUpdateStep step;

  IdentityUpdateState copyWith({
    bool? scanning,
    bool? submitting,
    OcrResult? identity,
    IdentityUpdateStep? step,
  }) => IdentityUpdateState(
    scanning: scanning ?? this.scanning,
    submitting: submitting ?? this.submitting,
    identity: identity ?? this.identity,
    step: step ?? this.step,
  );
}
