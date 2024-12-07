class NetworkResponse {
  String success;
  String message;
  int code;
  dynamic data;
  bool failed;
  NetworkResponse({
    this.code = 200,
    this.data,
    this.failed = false,
    this.message = "",
    this.success = "",
  });

  @override
  String toString() => message;
}
