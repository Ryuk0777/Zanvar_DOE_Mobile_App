import 'package:flutter/material.dart';


ValueNotifier<Map> createAccountMapNotifier = ValueNotifier({
  'email': "",
  'firstName': "",
  'lastName': "",
  'password': "",
});


ValueNotifier<List<dynamic>> search_DOE_sub_result_Notifier = ValueNotifier([]);

ValueNotifier cardID = ValueNotifier(null);
