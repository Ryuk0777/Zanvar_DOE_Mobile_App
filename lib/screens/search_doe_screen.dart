import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:zanvar_doe_app/data/notifiers.dart';

class SearchDOEScreen extends StatefulWidget {
  const SearchDOEScreen({super.key});

  @override
  _SearchDOEScreenState createState() => _SearchDOEScreenState();
}

class _SearchDOEScreenState extends State<SearchDOEScreen> {
  TextEditingController searchController = TextEditingController();
  var token = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getValue();
  }

  Future<List<dynamic>> searchdoe() async {
    print("Next Clicked\n");
    try {
      final response = await http.get(
        Uri.parse("https://doe-backend.onrender.com/doe?diameter=${searchController.text}"),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("response status: ${response.statusCode}\n");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List) {
          return jsonResponse;
        } else {
          throw Exception('Expected a list but got ${jsonResponse.runtimeType}');
        }
      } else {
        print("Failed\n");
        return [];
      }
    } catch (e) {
      print("Failed to Fetch: $e\n");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: search_DOE_sub_result_Notifier,
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Text(
                  "1/2",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Tool Diameter",
                    hintStyle: const TextStyle(color: Colors.black),
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.black),
                    SizedBox(width: 4),
                    Text(
                      "Must Follow appropriate Spell",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() => _isLoading = true);
                            final results = await searchdoe();
                            setState(() => _isLoading = false);
                            if (results.isNotEmpty) {
                              search_DOE_sub_result_Notifier.value = results;
                              Navigator.pushNamed(context, '/searchResults');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('No results found or an error occurred'),
                                ),
                              );
                            }
                          },
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Next",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void getValue() async {
    var prefs = await SharedPreferences.getInstance();
    var getToken = prefs.getString("auth_token");
    setState(() {
      token = getToken ?? " ";
    });
  }
}
