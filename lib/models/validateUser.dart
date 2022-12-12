class ValidateUser {
  String? _success;
  String? _msg;

  ValidateUser({String? success, String? msg}) {
    if (success != null) {
      this._success = success;
    }
    if (msg != null) {
      this._msg = msg;
    }
  }

  String? get success => _success;
  set success(String? success) => _success = success;
  String? get msg => _msg;
  set msg(String? msg) => _msg = msg;

  ValidateUser.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = _success;
    data['msg'] = _msg;
    return data;
  }
}
