import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_gpt/models/payment.dart';
import 'package:get/get.dart';

import '../models/category.dart';
import '../models/meal.dart';
import '../models/order.dart' as order;
import '../models/user.dart';

class FirestoreService extends GetxService {
  late FirebaseFirestore firestore;

  @override
  void onInit() {
    dev.log("firestoreService init ...");
    firestore = FirebaseFirestore.instance;

    super.onInit();
  }

  Future<DocumentReference> addDocument(
      String collectionPath, Map<String, dynamic> data) async {
    final docRef = await firestore.collection(collectionPath).add(data);
    return docRef;
  }

  Future<void> updateDocument(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    await firestore.collection(collectionPath).doc(documentId).update(data);
  }

  Future<void> deleteDocument(String collectionPath, String documentId) async {
    await firestore.collection(collectionPath).doc(documentId).delete();
  }

  Stream<List<Map<String, dynamic>>> getDocuments(String collectionPath) {
    return firestore
        .collection(collectionPath)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<Map<String, dynamic>> getDocumentById(
      String collectionPath, String documentId) async {
    final doc =
        await firestore.collection(collectionPath).doc(documentId).get();
    return doc.data() as Map<String, dynamic>;
  }

  //get all meals
  Future<List<Meal>> getAllMeals() async {
    dev.log("getAllMeals ...");
    final snapshot = await firestore
        .collection('meals')
        .withConverter<Meal>(
          fromFirestore: (snapshot, _) => Meal.fromJson(snapshot.data()!),
          toFirestore: (meal, _) => meal.toJson(),
        )
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  //get all categories
  Future<List<MealCategory>> getAllCategories() async {
    dev.log("getAllCategories ...");
    final snapshot = await firestore
        .collection('categories')
        .withConverter<MealCategory>(
          fromFirestore: (snapshot, _) =>
              MealCategory.fromJson(snapshot.data()!),
          toFirestore: (category, _) => category.toJson(),
        )
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  //batch write meals in firestore
  Future<void> batchWriteMeals(List<Meal> meals) async {
    final batch = firestore.batch();
    for (var meal in meals) {
      final docRef = firestore.collection('meals').doc();
      batch.set(docRef, meal.toJson());
    }
    await batch.commit();
  }

  //batch write categoies in firestore
  Future<void> batchWriteCategories(List<MealCategory> categories) async {
    final batch = firestore.batch();
    for (var category in categories) {
      final docRef = firestore.collection('categories').doc();
      batch.set(docRef, category.toJson());
    }
    await batch.commit();
  }

  //batch delete all categories
  Future<void> clearCategories() async {
    final snapshot = await firestore.collection('categories').get();
    final batch = firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  //clear firestore from all meals
  Future<void> clearMeals() async {
    final snapshot = await firestore.collection('meals').get();
    final batch = firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> saveOrder(order.RestaurantOrder order) async {
    await firestore.collection('orders').doc(order.id).set(order.toJson());
  }

  Future<void> savePayment(Payment payment) async {
    await firestore
        .collection('payments')
        .doc(payment.id)
        .set(payment.toJson());
  }

  Future<UserProfile> createUser(User user) async {
    DocumentReference userDocRef = firestore.collection('users').doc(user.uid);

    var userdata = {
      "id": user.uid,
    };

    await userDocRef.set(userdata);
    return UserProfile.fromJson(userdata);
  }

  Future<UserProfile?> getUserProfile(User user) async {
    DocumentReference userDocRef = firestore.collection('users').doc(user.uid);
    var doc = await userDocRef.get();
    if (doc.exists) {
      return UserProfile.fromJson(doc.data() as Map<String, dynamic>);
    } else {
      //create user
      return createUser(user);
    }
  }

  Future<UserProfile?> upDateUserProfile(
      User user, UserProfile? userProfile) async {
    dev.log("update user  ...");
    DocumentReference userDocRef = firestore.collection('users').doc(user.uid);
    var data = {
      "id": user.uid,
      "address": userProfile?.address,
    };
    await userDocRef.update(data);
    return UserProfile.fromJson(data);
  }

  String getUID() {
    return firestore.collection('uid').doc().id;
  }
}
