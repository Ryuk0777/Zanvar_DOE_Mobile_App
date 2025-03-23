import 'package:flutter/material.dart';


ValueNotifier<Map> createAccountMapNotifier = ValueNotifier({
  'email': "",
  'first_name': "",
  'last_name': "",
  'password': "",
});


ValueNotifier<List<dynamic>> search_DOE_sub_result_Notifier = ValueNotifier([]);
