import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/otp_input.dart';

class OtpPage extends StatefulWidget {
  final String mobile;

  const OtpPage({super.key, required this.mobile});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    if (otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter 6 digit OTP')));
      return;
    }
    context.read<AuthBloc>().add(VerifyOtpRequested(mobile: widget.mobile, otp: otpController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.authenticated) context.go('/main/home');            
            if (state.status == AuthStatus.failure) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message ?? 'Invalid OTP')));
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text('Verify your number',style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text('OTP sent to +91 ${widget.mobile}'),
                  const SizedBox(height: 40),
                  OtpInput(controller: otpController),
                  const SizedBox(height: 30),
                  AppButton(
                    text: 'Verify OTP',
                    isLoading: state.status == AuthStatus.loading,
                    onPressed: _verifyOtp,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
