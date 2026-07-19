import '../../../../capabilities/ocr/ocr_result.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 身份更新流程步骤。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【流程】
/// waitingOcr → scanning → ocrCompleted → signing → completed
///
/// 【状态机】
/// - waitingOcr：等待用户点击 OCR 扫描
/// - scanning：OCR 识别中
/// - ocrCompleted：OCR 完成，用户可编辑
/// - signing：提交中（活体 + 签名）
/// - completed：提交成功
///
enum IdentityUpdateStep {
  waitingOcr,
  scanning,
  ocrCompleted,
  signing,
  completed,
}

/// ─────────────────────────────────────────────────────────────────────
/// 身份证件更新页面状态。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【字段说明】
/// - [scanning]：OCR 扫描中的 Loading 状态
/// - [submitting]：提交中的 Loading 状态
/// - [identity]：OCR 识别结果，可为空
/// - [step]：当前流程步骤，用于 UI 展示
///
/// 【状态设计原则】
/// 使用 [step] 而非多个 bool 字段：
/// - 步骤互斥，不会同时处于多个状态
/// - 便于 UI 根据步骤展示不同内容
/// - 便于追踪流程进度
///
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
