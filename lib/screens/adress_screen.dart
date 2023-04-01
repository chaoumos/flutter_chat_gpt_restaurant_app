import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/adress.dart';
import '../services/user_service.dart';

class AdressFormScreen extends StatefulWidget {
  const AdressFormScreen({super.key});

  @override
  AdressFormScreenState createState() => AdressFormScreenState();
}

class AdressFormScreenState extends State<AdressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ctrl = Get.find<UserService>();

  final TextEditingController _adressLine1Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void initState() {
    _adressLine1Controller.text = _ctrl.user.value?.adress?.adressLine1 ?? "";
    _cityController.text = _ctrl.user.value?.adress?.city ?? "";

    _postalCodeController.text = _ctrl.user.value?.adress?.postalCode ?? "";
    _countryController.text = _ctrl.user.value?.adress?.country ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adress Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _adressLine1Controller,
                decoration: const InputDecoration(labelText: 'Adress Line 1'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your adress';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _postalCodeController,
                decoration: const InputDecoration(labelText: 'Postal Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your postal code';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => _submitForm(),
                child: const Text('Save Adress'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _ctrl.user.value?.adress = Adress(
        adressLine1: _adressLine1Controller.text,
        city: _cityController.text,
        postalCode: _postalCodeController.text,
        country: _countryController.text,
      );
      dev.log('###_submitForm ${_ctrl.user.value?.adress} ');
      // save adress to database
      _ctrl.updateUserDetails();
      Get.back();
    }
  }
}
