class NetworkResponse {
  bool success;
  String message;
  String code;
  dynamic data;
  bool failed;
  NetworkResponse({
    this.code = "200",
    this.data,
    this.failed = false,
    this.message = "",
    this.success = false,
  });

  @override
  String toString() => message;
}
