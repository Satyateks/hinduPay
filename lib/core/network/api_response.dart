class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final dynamic errors;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic json)? fromJson,
  }) {
    return ApiResponse<T>(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && fromJson != null
          ? fromJson(json['data'])
          : null,
      errors: json['errors'],
    );
  }
}
