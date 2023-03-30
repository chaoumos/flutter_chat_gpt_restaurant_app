import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/user_service.dart';

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
            : StackDemo();
      },
    ));
  }
}

class ProfileForm extends StatelessWidget {
  const ProfileForm({
    super.key,
    required UserService userService,
  }) : _userService = userService;

  final UserService _userService;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: 300.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(Get.width / 2, 20)),
              color: Theme.of(context).primaryColor),
          child: Expanded(
            child: Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _userService.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      IconButton(
                        onPressed: () {
                          if (_userService.user.value != null) {
                            //showing the package profile screen
                            Get.dialog(ProfileScreen(
                              appBar: AppBar(),
                              actions: [
                                SignedOutAction((context) {
                                  Get.back();
                                }),
                              ],
                            )) //updating the user details maybe changed in flutterfire profile screen
                                .then((value) => _userService.getUserProfile());
                          }
                        },
                        icon: const Icon(Icons.settings),
                      ),
                      InkWell(
                        onTap: () =>
                            //sync the user after phone verification
                            Get.dialog(const PhoneInputScreen())
                                .then((value) => _userService.getUserProfile()),
                        child: TextFormField(
                          enabled: false,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                            labelText: 'Phone Number',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        enabled: _userService.editForm.value,
                        controller: _userService.adressController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                          labelText: 'Address',
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userService.updateUserDetails();
                        },
                      ),
                      Obx(
                        () => _userService.editForm.value
                            ? ElevatedButton(
                                onPressed: () {
                                  if (_userService.formKey.currentState!
                                      .validate()) {
                                    _userService.formKey.currentState?.save();
                                    // Here we submit the form data
                                    _userService
                                        .updateUserDetails()
                                        .then((value) {
                                      //disable edit
                                      _userService.editForm.value = false;
                                    });
                                  }
                                },
                                child: const Text('Submit'),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  //enable edit
                                  _userService.editForm.value = true;
                                },
                                child: const Text('Edit'),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // background image and bottom contents

        // Profile image
        Positioned(
          top: 150.0, // (background container size) - (circle height / 2)
          child: _userService.authUser.value?.photoURL != null
              ? CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage(_userService.authUser.value?.photoURL ?? ""),
                )
              : const Icon(Icons.person),
        ),
      ],
    );
  }
}

class StackDemo extends StatelessWidget {
  const StackDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stack Demo'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // background image and bottom contents
          Column(
            children: <Widget>[
              Container(
                height: 200.0,
                color: Colors.orange,
                child: const Center(
                  child: Text('Background image goes here'),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text('Content goes here'),
                  ),
                ),
              )
            ],
          ),
          // Profile image
          Positioned(
            top: 150.0, // (background container size) - (circle height / 2)
            child: Container(
              height: 100.0,
              width: 100.0,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.green),
            ),
          )
        ],
      ),
    );
  }
}
