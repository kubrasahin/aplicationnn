import 'dart:convert';

class OtpService {
  static Future<Map<String, dynamic>> otpMesaj() async {
    String a = "merhaba";
    return jsonDecode(a);
  }
}
