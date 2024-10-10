import 'dart:convert';
import 'dart:developer';
import 'package:field_master/app/theme/constants.dart';
import 'package:field_master/widgets/app_snack_bar.dart';
import 'package:http/http.dart' as http;

class NexmoService {
  final String apiKey = 'd663a424'; // Replace with your Nexmo API key
  final String apiSecret =
      'ClnKtkKCsEl5V9wt'; // Replace with your Nexmo API secret
  final String fromPhoneNumber =
      'FSM App'; // Can be a verified sender ID or Vonage number

  Future<void> sendSms({
    required String toPhoneNumber,
    required String message,
  }) async {
    final url = Uri.parse('https://rest.nexmo.com/sms/json');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'api_key': apiKey,
        'api_secret': apiSecret,
        'to': toPhoneNumber,
        'from': fromPhoneNumber,
        'text': message,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['messages'][0]['status'] == '0') {
        log('SMS sent successfully');
      } else {
        final msg =
            'Failed to send SMS: ${responseData['messages'][0]['error-text']}';
        showErrorSnackBar(navKey.currentContext!, message: msg);
        log(msg);
      }
    } else {
      final msg = 'Failed to send SMS: ${response.body}';
      showErrorSnackBar(navKey.currentContext!, message: msg);
      log(msg);
    }
  }
}

late NexmoService nexmoService;

void onOrderPlaced({
  required String phoneNumber,
  String message = 'Your order has been placed successfully!',
}) {
  try {
    nexmoService.sendSms(
      toPhoneNumber: phoneNumber,
      message: message,
    );
  } on Exception catch (e) {
    showErrorSnackBar(navKey.currentContext!, message: e.toString());
    log(e.toString());
  }
}
