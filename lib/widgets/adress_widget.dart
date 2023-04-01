import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/adress_screen.dart';
import '../services/user_service.dart';

class AdressWidget extends StatelessWidget {
  const AdressWidget({
    super.key,
    required UserService userService,
  }) : _userService = userService;

  final UserService _userService;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Obx(
      () => ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32))),
        // tileColor: Theme.of(context).colorScheme.primaryContainer,

        leading: const Icon(Icons.pin_drop),
        title: Text(
          _userService.user.value?.adress?.adressLine1 ?? "",
        ),
        subtitle: Text(
          _userService.user.value?.adress != null
              ? _userService.user.value?.adress
                      ?.toJson()
                      .values
                      .toList()
                      .sublist(1)
                      .join(" ") ??
                  ""
              : "",
        ),
        trailing: IconButton(
            onPressed: () {
              Get.dialog(
                  useSafeArea: true,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 30, 8, 80),
                    child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        child: const AdressFormScreen()),
                  ));
            },
            icon: const Icon(Icons.edit)),
      ),
    ));
  }
}
