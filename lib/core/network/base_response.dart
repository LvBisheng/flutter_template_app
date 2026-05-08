import 'app_exception.dart';

class BaseResponse<T> {
  const BaseResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  final String code;
  final String message;
  final T data;

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse<T>(
      code: json['code'] as String? ?? '9999',
      message: json['message'] as String? ?? 'unknown',
      data: json['data'] as T,
    );
  }

  void ensureSuccess() {
    if (code != '0000') throw AppException(message, code: code);
  }
}
