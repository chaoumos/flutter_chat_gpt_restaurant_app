import 'dart:ui';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/user_service.dart';
import '../widgets/adress_widget.dart';

class ProfileTabScreen extends StatelessWidget {
  ProfileTabScreen({Key? key}) : super(key: key);
  final _userService = Get.find<UserService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(
      () {
        return _userService.user.value == null
            ? Center(
                child: FilledButton(
                    //showing the package SignInScreen screen
                    onPressed: () => Get.dialog(Scaffold(
                          appBar: AppBar(),
                          body: SignInScreen(
                            actions: [
                              AuthStateChangeAction((context, state) {
                                Get.back();
                              })
                            ],
                          ),
                        )),
                    child: const Text("Create Account")),
              )
            : ProfileScreenContent(
                userService: _userService,
              );
      },
    ));
  }
}

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({
    super.key,
    required UserService userService,
  }) : _userService = userService;

  final UserService _userService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileScreenAppBar(_userService),
      body: Column(
        children: [
          SizedBox(
            width: Get.width,
            height: 100.0,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: <Widget>[
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Image.network(
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person),
                      fit: BoxFit.fill,
                      _userService.authUser.value?.photoURL ?? ""),
                ),
                Positioned(
                  top: 100.0,
                  // (background container size) - (circle height / 2)
                  child: _userService.authUser.value?.photoURL != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              _userService.authUser.value?.photoURL ?? ""),
                        )
                      : const Icon(Icons.person, size: 50),
                ),
              ],
            ),
          ),
          const SizedBox(height: 120),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    onTap: () => _userService.showProfileScreenDialog(),
                    leading: const Icon(Icons.person),
                    title: Obx(
                      () => Text(
                        _userService.authUser.value?.displayName ?? "",
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: () => Get.dialog(const PhoneInputScreen()),
                    leading: const Icon(Icons.phone),
                    title: Text(
                        _userService.authUser.value?.phoneNumber ??
                            "Please add your phone number",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color:
                                _userService.authUser.value?.phoneNumber == null
                                    ? Colors.red
                                    : Colors.black)),
                  ),
                ),
                AdressWidget(userService: _userService),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

PreferredSizeWidget profileScreenAppBar(UserService userService) {
  return AppBar(
    title: const Text('Manage Profile'),
    actions: [
      IconButton(
        onPressed: () {
          if (userService.user.value != null) {
            //showing the package profile screen
            userService.showProfileScreenDialog();
          }
        },
        icon: const Icon(Icons.settings),
      ),
    ],
  );
}
