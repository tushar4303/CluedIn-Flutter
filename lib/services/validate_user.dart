import 'package:http/http.dart' as http;
import 'dart:convert';

class ValidateUser {
  Future<ValidateApiResponse?> apiCallLogin(Map<String, dynamic> param) async {
    var url = Uri.parse('http://192.168.0.104:5000/api/app/authAppUser');
    var response = await http.post(url, body: param);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final data = jsonDecode(response.body);
    return ValidateApiResponse(
        success: data["success"], msg: data["msg"], error: data["error"]);
  }
}

class ValidateApiResponse {
  final String? success;
  final String? msg;
  final String? error;

  ValidateApiResponse({this.success, this.msg, this.error});
}
