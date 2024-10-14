import 'package:field_master/register/cubit/cubit.dart';
import 'package:field_master/utils/size_config.dart';
import 'package:field_master/utils/utils.dart';
import 'package:field_master/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// {@template register_body}
/// Body of the RegisterPage.
///
/// Add what it does
/// {@endtemplate}
class RegisterBody extends StatefulWidget {
  /// {@macro register_body}
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final _formKey = GlobalKey<FormState>();
  final password = TextEditingController();
  final _email = TextEditingController();
  List<String> roles = ['Admin', 'Manager', 'Technicians'];
  String role = '';

  @override
  void initState() {
    role = roles.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) async {
        if (state.status == CurrentStatus.error) {
          await EasyLoadingService.error(text: state.message);
        }
        if (state.status == CurrentStatus.success && state.message.isNotEmpty) {
          await EasyLoadingService.success(text: state.message);
        }
      },
      builder: (context, state) {
        if (state.status == CurrentStatus.other) {
          return const LoadingScreen();
        }
        if (state.status == CurrentStatus.receivingError) {
          return MessageScreen(message: state.message);
        }
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(24),
              vertical: getProportionateScreenWidth(32),
            ),
            children: [
              const SizedBox(height: 16),
              Text(
                'Create an Account',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Align(
                child: Image.asset(
                  'assets/field_master.png',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                textInputAction: TextInputAction.next,
                validator: (value) => validateTxtFiled(value: value),
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'Enter your email',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'Select Role',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
                value: role,
                items: roles.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    role = newValue!;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a role' : null,
              ),
              const SizedBox(height: 16),
              PasswordField(
                password,
              ),
              const SizedBox(height: 32),
              if (state.status == CurrentStatus.loading)
                const LoadingButton()
              else
                PrimaryButton(
                  title: 'Register',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      context
                          .read<RegisterCubit>()
                          .createUserWithEmailAndPassword(
                            _email.text,
                            password.text,
                            role,
                          );
                    }
                  },
                ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
