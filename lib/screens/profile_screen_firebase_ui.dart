//temp view to manage loging and profile screen with default firebase ui

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/user_service.dart';

class FirebaseUiScreen extends StatelessWidget {
  FirebaseUiScreen({super.key});
  final _userService = Get.find<UserService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Profile'),
            bottom: AppBar(
              centerTitle: true,
              title: SelectableText(
                "use test phone number verification \n phone n: +1 650-555-1234 \n verification: 123456",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(backgroundColor: Colors.yellow),
              ),
            )),
        body: Obx(
          () => _userService.user.value == null
              ? const SignInScreen(
                  // subtitleBuilder: (context, provider) => Text(
                  //   'Sign in with ${provider.index == 0 ? 'Google' : 'Email'}',
                  //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  //         color: Theme.of(context).colorScheme.primary,
                  //       ),
                  // ),
                  showAuthActionSwitch: true,
                )
              : const ProfileScreen(),
        ));
  }
}
