import 'package:cluedin_app/utils/links.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ValidateUser {
  final _error = "";

  Future<ValidateApiResponse?> apiCallLogin(Map<String, dynamic> param) async {
    var url = Uri.parse(authAppUserApi);
    try {
      print("hit k pehle");
      var response = await http.post(url, body: param);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);
      return ValidateApiResponse(
          success: data["success"], msg: data["msg"], error: data["error"]);
    } on Exception catch (e) {
      print(e.toString());
    }

    return ValidateApiResponse(error: _error);
  }
}

class ValidateApiResponse {
  final String? success;
  final String? msg;
  final String? error;

  ValidateApiResponse({this.success, this.msg, this.error});
}
