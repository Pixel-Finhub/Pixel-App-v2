import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixel_insurance_v2/app/data/providers/api_provider.dart';
import 'package:pixel_insurance_v2/app/ui/auth/widgets/progress_indicator.dart';
import 'package:pixel_insurance_v2/app/ui/home/home_page.dart';
import 'package:pixel_insurance_v2/app/ui/theme/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  final TextEditingController phoneTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  final TextEditingController emailTextEditingController =
      TextEditingController();

  var phoneNo = ''.obs;

  // REGISTER
  Future<void> userRegistration(BuildContext context) async {
    // Get.to(() => const HomePage());

    if (formKey.currentState!.validate()) {
      // show progress dialog
      showProgressDialog(context);

      try {
        isLoading.value = true;

        final response = await http.post(Uri.parse("$baseUrl/register"), body: {
          "name": phoneTextEditingController.text,
          "phone": phoneTextEditingController.text,
          "email": emailTextEditingController.text,
          "password": passwordTextEditingController.text,
        });

        // ignore: unnecessary_null_comparison
        if (response.statusCode == 200 && (response.body != null)) {
          isLoading.value = false;

          final responseData = json.decode(response.body);
          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString('token', responseData['token']);
          prefs.setInt("userId", responseData["userData"]["id"]);
          prefs.setString("name", responseData["userData"]["name"]);
          prefs.setString("phone", responseData["userData"]["phone"]);
          prefs.setString("email", responseData["userData"]["email"]);

          Get.to(() => const HomePage());
        } else {
          isLoading.value = false;

          print(response.body);
          Get.snackbar(
            'Error',
            'Incorrect username or password.',
            leftBarIndicatorColor: fail,
          );
        }
      } catch (e) {
        print(e);
        return;
      } finally {
        // hide progress dialog when API call is done
        hideProgressDialog(context);
      }
    } else {
      isLoading.value = false;

      Get.snackbar(
        'Error',
        'Please enter username and password.',
        leftBarIndicatorColor: fail,
      );
    }
  }

  // LOGIN
  Future<void> userLogin(BuildContext context) async {
    // Get.to(() => const HomePage());

    if (formKey.currentState!.validate()) {
      // show progress dialog
      showProgressDialog(context);

      try {
        isLoading.value = true;

        final response = await http.post(Uri.parse("$baseUrl/login"), body: {
          "phone": phoneNo.value,
          "password": passwordTextEditingController.text,
        });

        if (response.statusCode == 200) {
          isLoading.value = false;

          final responseData = json.decode(response.body);
          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString('token', responseData['token']);
          prefs.setInt("userId", responseData["user"]["id"]);

          // ignore: use_build_context_synchronously
          hideProgressDialog(context);

          Get.to(() => const HomePage());
        } else {
          isLoading.value = false;

          print(response.body);
          Get.snackbar(
            'Error',
            'Incorrect username or password.',
            leftBarIndicatorColor: fail,
          );
        }
      } catch (e) {
        print(e);
        return;
      }
    } else {
      isLoading.value = false;

      Get.snackbar(
        'Error',
        'Please enter username and password.',
        leftBarIndicatorColor: fail,
      );
    }
  }

  // RESET PASSWORD
  Future<void> resetPassword(String email) async {
    // show progress dialog
    // showProgressDialog(context);
    if (formKey.currentState!.validate()) {
      try {
        final response = await http
            .post(Uri.parse("$baseUrl/reset-password"), body: {"email": email});

        // ignore: unnecessary_null_comparison
        if (response.statusCode == 200 && (response.body != null)) {
          final responseData = json.decode(response.body);
          print(responseData);
          Get.snackbar(
            'Success',
            'Please check your email. Reset password link has been sent.',
            leftBarIndicatorColor: success,
          );
        } else {
          print(response.body);
          Get.snackbar(
            'Error',
            'Incorrect email.',
            leftBarIndicatorColor: fail,
          );
        }
      } catch (e) {
        print(e);
        return;
      }
    } else {
      Get.snackbar(
        'Error',
        'Please enter email.',
        leftBarIndicatorColor: fail,
      );
    }
  }

  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent users from dismissing the dialog
      builder: (BuildContext context) {
        return const ProgressDialog();
      },
    );
  }

  void hideProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}