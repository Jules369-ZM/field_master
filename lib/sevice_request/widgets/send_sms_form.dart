import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendSmsForm extends StatefulWidget {
  const SendSmsForm({
    required this.receiver,
    required this.scaffoldMessengerContext, // Add scaffoldMessengerContext
    super.key,
  });
  final String receiver;
  final BuildContext scaffoldMessengerContext; // Context for showing SnackBar

  @override
  SendSmsFormState createState() => SendSmsFormState();
}

class SendSmsFormState extends State<SendSmsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void initState() {
    // Prepend country code if not present in the receiver number
    _phoneNumberController.text = widget.receiver.isNotEmpty
        ? widget.receiver
        : '+260'; // Default to ZM country code if no number provided
    super.initState();
  }

  // Function to send SMS using Nexmo API
  Future<dynamic> sendSms(String phoneNumber, String message) async {
    setState(() {
      _isSending = true;
    });

    const apiKey = 'd663a424'; // Replace with your Nexmo API key
    const apiSecret = 'ClnKtkKCsEl5V9wt'; // Replace with your Nexmo API secret
    const from = 'FSM App'; // Can be verified Sender ID or Vonage number

    final url = Uri.parse('https://rest.nexmo.com/sms/json');

    final response = await http.post(
      url,
      body: {
        'api_key': apiKey,
        'api_secret': apiSecret,
        'to': phoneNumber,
        'from': from,
        'text': message,
      },
    );

    setState(() {
      _isSending = false;
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData;
    } else {
      // Show the SnackBar using the parent ScaffoldMessenger context
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(widget.scaffoldMessengerContext).showSnackBar(
          const SnackBar(content: Text('Error sending SMS. Please try again.')),
        );
      });
    }
  }

  // Validator for phone number to ensure it starts with a country code
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the recipient phone number';
    }
    if (!value.startsWith('+')) {
      return 'Phone number must start with a country code (e.g., +1)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+260 (Country code required)',
              ),
              keyboardType: TextInputType.phone,
              validator: _validatePhoneNumber,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Message'),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the message';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isSending
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        final r = await sendSms(
                          _phoneNumberController.text,
                          _messageController.text,
                        );
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                        if (r['messages'][0]['status'] == '0') {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(
                                    widget.scaffoldMessengerContext)
                                .showSnackBar(
                              const SnackBar(
                                content: Text('SMS sent successfully!'),
                              ),
                            );
                          });
                        } else if (r['messages'][0]['status'] == '9') {
                          log(r.toString());
                          log('Failed to send SMS: ${r['messages'][0]['error-text']}');
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(
                                    widget.scaffoldMessengerContext)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Failed to send SMS: ${r['messages'][0]['error-text']}',
                                ),
                              ),
                            );
                          });
                        } else {
                          if (context.mounted) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ScaffoldMessenger.of(
                                      widget.scaffoldMessengerContext)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to send SMS: ${r['messages'][0]['error-text']}',
                                  ),
                                ),
                              );
                            });
                          }
                        }
                      }
                    },
              child: _isSending
                  ? const CircularProgressIndicator()
                  : const Text('Send SMS'),
            ),
          ),
        ],
      ),
    );
  }
}

void showSendSmsBottomSheet(BuildContext context, String receiver) {
  showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context_) {
      // Pass the parent ScaffoldMessenger context here
      return Padding(
        padding: MediaQuery.of(context_)
            .viewInsets, // Ensure the keyboard doesn't block the form
        child: SendSmsForm(
          receiver: receiver,
          scaffoldMessengerContext: context_,
        ),
      );
    },
  );
}
