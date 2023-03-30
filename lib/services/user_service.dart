import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/models/user.dart';
import 'package:get/get.dart';

import 'firestore_service.dart';

class UserService extends GetxService {
  late TextEditingController adressController;

  final formKey = GlobalKey<FormState>();
  final editForm = false.obs;

  @override
  void onClose() {
    adressController.dispose();
    super.onClose();
  }

  final authUser = Rx<User?>(null);
  final firebase = FirebaseAuth.instance;
  var user = Rx<UserProfile?>(null);
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

    adressController = TextEditingController(text: user.value?.address ?? "");
    super.onInit();
  }

//get db userProfile
  Future getUserProfile() async {
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
    if (formKey.currentState!.validate()) {
      user.value!.address = adressController.text;

      await authUser.value?.reload();
      await _firestoreService.upDateUserProfile(
        authUser.value!,
        user.value!,
      );
      authUser.refresh();
      user.refresh();
    }
  }

  Future<void> logout() async {
    await firebase.signOut();
    user.value = null;
  }
}
