import 'dart:developer';

import 'package:face_recognize_web3/loginScreen/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginWithCnic extends StatelessWidget {
  LoginWithCnic({super.key});
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: context.watch<LoginProvider>().isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Enter Cnic'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      log("Enter Cnic ${state.responseBodies}");
                      state.login({
                        'cnic': _controller.text,
                      });
                      // state.getGalleryImage();
                    },
                    child: Text('Login'))
              ],
            ),
    );
  }
}

class LoginWithFaceRecognization extends StatelessWidget {
  const LoginWithFaceRecognization({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 600,
        width: 325,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final Color? fillColor;
  final TextInputType textType;
  final Function(String) onChange;
  final String? Function(String?)? validators;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.textType = TextInputType.text,
    required this.onChange,
    this.validators,
    this.fillColor,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textType,
      inputFormatters: inputFormatters ?? [],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        fillColor: fillColor,
        filled: fillColor == null ? false : true,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xff656565)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(0xff656565),
            )),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Set the border radius

          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Set the border radius

          borderSide: BorderSide(
            color: Colors.white60,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Set the border radius

          borderSide: const BorderSide(
            color: Colors.deepPurple,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Set the border radius

          borderSide: BorderSide(
            color: Colors.white60,
          ),
        ),
      ),
      onChanged: onChange,
      validator: validators ??
          (val) {
            if (val == null || val.isEmpty) {
              return 'Enter your $hintText';
            }
            return null;
          },
      maxLines: maxLines,
    );
  }
}
