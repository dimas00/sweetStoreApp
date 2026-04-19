import 'package:flutter/material.dart';

class AddressService {
  static final ValueNotifier<Map<String, dynamic>?> address =
  ValueNotifier(null);

  static void setAddress(Map<String, dynamic> newAddress) {
    address.value = newAddress;
  }

  static bool hasAddress() {
    return address.value != null;
  }
}