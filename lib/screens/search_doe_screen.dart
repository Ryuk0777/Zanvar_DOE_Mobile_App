import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zanvar_doe_app/data/notifiers.dart';

class SearchDOEScreen extends StatefulWidget {
  const SearchDOEScreen({super.key});

  @override
  _SearchDOEScreenState createState() => _SearchDOEScreenState();
}

class _SearchDOEScreenState extends State<SearchDOEScreen> {
  TextEditingController searchController = TextEditingController();

  Future<List<dynamic>> searchdoe() async {
    print("Next Clicked\n");
    try {
      final response = await http.post(
        Uri.parse("http://192.168.31.125:8000/api/filter-doe/"),
        body: json.encode({"Tool_Diameter": searchController.text}),
        headers: {
          'Content-Type': 'application/json',
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzQyODEwODQ2LCJpYXQiOjE3NDI3MjQ0NDYsImp0aSI6IjBiZGVlMTYyYWNlYTQ4MTA5OTgxYzU3MGJlZDU4MmViIiwidXNlcl9pZCI6NX0.G5W-f1xW-BCJpcqbjYWm9D9L65H9DKAve1A_psTTspg",
        },
      );

      // print("response body: ${response.body}");
      print("response status: ${response.statusCode}\n");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List) {
          return jsonResponse;
        } else {
          throw Exception(
            'Expected a list but got ${jsonResponse.runtimeType}',
          );
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
                Navigator.pop(context); // ✅ Back navigation added
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

                // Search Box
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

                // Note
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

                // Next Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, // Purple color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      final results = await searchdoe();
                      if (results.isNotEmpty) {
                        search_DOE_sub_result_Notifier.value = results;
                        // print(results);
                        Navigator.pushNamed(context, '/searchResults');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'No results found or an error occurred',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
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
}
