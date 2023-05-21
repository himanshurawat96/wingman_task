class OtpResponse {
  OtpResponse({
      this.status, 
      this.response, 
      this.profileExists, 
      this.jwt,});

  OtpResponse.fromJson(dynamic json) {
    status = json['status'];
    response = json['response'];
    profileExists = json['profile_exists'];
    jwt = json['jwt'];
  }
  bool? status;
  String? response;
  bool? profileExists;
  String? jwt;
OtpResponse copyWith({  bool? status,
  String? response,
  bool? profileExists,
  String? jwt,
}) => OtpResponse(  status: status ?? this.status,
  response: response ?? this.response,
  profileExists: profileExists ?? this.profileExists,
  jwt: jwt ?? this.jwt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['response'] = response;
    map['profile_exists'] = profileExists;
    map['jwt'] = jwt;
    return map;
  }

}