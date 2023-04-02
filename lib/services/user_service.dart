import 'dart:developer' as dev;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/models/user.dart';
import 'package:get/get.dart';

import 'firestore_service.dart';

class UserService extends GetxService {
  late TextEditingController adressController;

  @override
  void onClose() {
    adressController.dispose();
    super.onClose();
  }

  final authUser = Rx<User?>(null);
  final firebase = FirebaseAuth.instance;
  final user = Rx<UserProfile?>(null);
  final _firestoreService = Get.find<FirestoreService>();

  @override
  Future<void> onInit() async {
    authUser.value = firebase.currentUser;
    //get Db user
    if (authUser.value != null) {
      user.value = await _firestoreService.getUserProfile(authUser.value!);
      user.refresh();
    }

//subscripe to auth state changes stream
    FirebaseAuth.instance.authStateChanges().listen((User? userUpdated) async {
      authUser.value = userUpdated;
      await getUserProfile();
    });
// init controllers

    dev.log(authUser.value.toString(), name: 'authUser.value.toString()');

    super.onInit();
  }

//get db userProfile
  Future getUserProfile() async {
    await authUser.value?.reload();
    authUser.value = firebase.currentUser;
    authUser.refresh();
    if (authUser.value == null) {
      //in case of logout
      user.value = null;
      return;
    }
    user.value = await _firestoreService.getUserProfile(authUser.value!);
  }

//update user details from form
  updateUserDetails() async {
    if (authUser.value == null) {
      return;
    }

    await authUser.value?.reload();
    await _firestoreService.upDateUserProfile(authUser.value!, user.value);
    authUser.refresh();
    user.refresh();
  }

  Future<void> logout() async {
    await firebase.signOut();
    user.value = null;
  }

  void showProfileScreenDialog() {
    Get.dialog(
      useSafeArea: true,
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: ProfileScreen(
            appBar: AppBar(),
            actions: [
              SignedOutAction((context) {
                Get.back();
              }),
            ],
          ),
        ),
      ),
    )
        //updating the user details maybe changed in flutterfire profile screen
        .then((value) => getUserProfile());
  }

  void showPhoneScreenDialog() {
    Get.dialog(
      useSafeArea: true,
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: const PhoneInput(
              // appBar: AppBar(),
              // actions: [
              //   SignedOutAction((context) {
              //     Get.back();
              //   }),
              // ],
              ),
        ),
      ),
    )
        //updating the user details maybe changed in flutterfire profile screen
        .then((value) => getUserProfile());
  }
}
