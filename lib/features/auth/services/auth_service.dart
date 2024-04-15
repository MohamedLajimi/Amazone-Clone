// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void signUpUser(
      {required BuildContext context,
      required name,
      required email,
      required password}) async {
    try {
      User user = User(
          id: '',
          name: name,
          email: email,
          password: password,
          address: '',
          type: '',
          token: '');
      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: user.toJson());
      httpErrorHandling(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      http.Response res = await http.post(Uri.parse('$uri/api/signin'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode({'email': email, 'password': password}));
      httpErrorHandling(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Login Success !');
          });
    } catch (e) {
      log(e.toString());
    }
  }
}
