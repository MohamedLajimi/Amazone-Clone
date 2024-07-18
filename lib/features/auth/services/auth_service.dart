// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        await prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(Uri.parse('$uri/tokenIsValid'), headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'x-auth-token': token!
      });

      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes = await http.get(Uri.parse('$uri/'), headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        });
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

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
          token: '',
          cart: []);
      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: user.toJson());
      httpErrorHandling(
          response: res,
          context: context,
          onSuccess: () async {
            showSnackBar(
                context, 'Account created ! Login with the same credentials');
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
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await prefs.setString(
                'x-auth-token', jsonDecode(res.body)['token']);
            Navigator.pushReplacementNamed(
              context,
              BottomBar.routeName,
            );
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
