class ApiResponse<T> {
  ApiResponse({
      required this.status,
      required this.response,
      this.data,});

  ApiResponse.fromJson(dynamic json, [this.data]) {
    status = json['status'];
    response = json['response'];
  }
  late bool status;
  late String response;
  T? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = response;
    map['data'] = data;
    return map;
  }

}