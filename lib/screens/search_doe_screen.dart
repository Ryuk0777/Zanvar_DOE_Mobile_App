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
  TextEditingController operationTextController = TextEditingController(); // Renamed for clarity
  var token = "";
  bool _isLoading = false;

  List<String> tool_diamters = ['Ø11.1', 'Ø80', 'Ø50', 'Ø40', 'Ø100', 'Ø21.8',
       'Ø25', 'Ø63', 'Ø16', 'Ø60.2-Ø65', 'Ø65.95-Ø72', 'Ø125', 'Ø27',
       'Ø150', 'Ø10.4', 'Ø11.5', 'Ø18', "NA", 'Ø10.2', 'Ø17', 'Ø15.5',
       'Ø14', 'Ø8.5', 'Ø20', 'Ø15', 'Ø36', 'Ø412', 'Ø598', 'Ø498',
       'Ø120.5', 'Ø22', 'Ø507', 'Ø28', '-', '25X25', "9.5", "125", "77", "22.2",
       "20", "16"," 6.8", "18", "4.2", 'M10 X 1.5-6H', 'Ø12.5', 'Ø141.35', 'Ø144.6',
       'Ø23.8', 'Ø6.8 & Ø8.76', 'Ø12H9', 'Ø199 & Ø291', 'Ø262', 'Ø291',
       'Ø293', 'Ø259', 'Ø127', 'Ø256', 'Ø261', '255 & Ø250', 'Ø213',
       '90 & 213', 'Ø115 & Ø213', 'Ø211', 'Ø232, Ø238, Ø211 & 95',
       'Ø260, Ø120 & Ø340', 'Ø95', 'Ø233', 'Ø352', 'Ø276', 'Ø355', 'Ø316',
       'Ø47', 'Ø335', 'Ø6.8', 'Engraving ', 'Ø352.42', 'Ø158',
       'Ø17.5×20 ', 'Ø232,Ø238, Ø211 & Ø95 ', 'Ø218', 'Ø199 & Ø290 ',
       'Ø223', 'Ø88', 'Ø231', 'Ø171.5-190.5', 'Ø280 ', 'Ø158 ', 'Ø280',
       'Ø21', 'M24X3 ', 'Ø250 ', 'Ø138 ', 'Ø153 ', 'Ø140 ', 'Ø140',
       'Ø17.5 ', 'M20X2.5 ', 'Dia. 160 ', "25.4", 'Dia. 10.72 ', 'Tap ',
       'Dia. 400 ', 'Dia. 80 ', 'Dia.63. ', 'Dia. Shell Mill Cutter',
       'Cham Drill', 'Dia. 22.2 ', 'Dia 125 ', 'Dia. 125 ', 'Dia. 25.4 ',
       'Dia. 10.76 ', 'Dia.147 ', 'Ø17.5', 'M8X1.25', 'M14X1.5', 'Ø160',
       'Ø32', 'Ø24', 'Ø28.5', 'M10X1.5', 'Ø4.5', 'M12X1.75', 'Ø5',
       'Ø19.8', 'Ø11.7', 'Ø250', 'Ø8.7', 'M10X1.25', 'Ø6', 'Ø100 ',
       'Ø6 .8 ', 'Ø12×15×16.5', 'Ø8.5 ', ' Ø6.8 ', 'Ø11 ', ' Ø14.5 ',
       ' Ø 8 ', ' Ø12 ', ' Ø16 ', 'Ø12 ', 'Ø14.5 ', 'Ø18.5 ', "63","26.5",
       "25", "80", "45", "10", "50", "17.95", "292.6", "90", "100", "13.5", "40", "8", "37", "48",
       "8.9", "21", "286", "34.5", "15.5", "19", "27.35", "17.5", "65", "34", 'Ø73.5',
       'Ø10.3', 'Ø74', 'Ø12', 'Ø74.5', 'Ø64', 'Ø25.08', 'Ø128 &Ø135',
       'Ø149 & Ø160', 'Ø98', 'Ø75', 'Ø 30', 'Ø16.5', 'Ø 16.5',
       'Ø61.4/Ø67.5', 'Ø14.5', 'Ø29.3', 'Ø24.5', 'Ø288', 'Ø232 & Ø235',
       'Ø310', 'Ø295', 'Ø298', 'Ø299', 'Ø30', 'Ø26.5', "10.5", 'Ø50 ',
       'Ø52 ', 'Ø61', 'Ø62 ', 'Ø63 ', 'Ø25 End Mill Finish ',
       'Ø7.965/ Ø8.040', 'Ø43 OD', 'Ø25.3 ', 'Ø25.4', 'Ø80 ', 'Ø100  ',
       'Ø19.20 ', 'Ø 70 ', 'Ø15 ', 'l16.50', 'Ø80  ', 'Ø72 ', 'Ø15.0 ',
       'Ø45 ', 'Ø71.50 ', 'Ø61.50', 'Ø43.50 ', 'Ø32  ', 'Ø63.0 ', 'Ø22 ',
       'Ø 20', 'Ø15.85', 'Ø19.16', 'Ø20 ', 'Ø34', 'Ø 31.5 and Ø40.5',
       '31.50 Rough', 'Ø5.5', 'Ø44.45/Ø23', 'Ø14.2', 'Ø30.18', 'Ø13.75',
       'Ø14.8', 'Ø400', "70", '25x25', "15", '32X32', "88.9", "32", 'Ø13', 'Ø11',
       "12", "35", "11.9", "7.92", "43", "12.7", "20.66", "18.25", "92", "75"];



  List<String> opertaions = ['Drill', 'Milling Cutter', 'Boring Bar',
       'Spot Face Cutter', 'Tap', 'Carbide drill', 'Turning cutter',
       'Boring bar', 'Tapping', 'Milling cutter', 'PS SC Drill',
       'PS SC Center drill', 'PS SC center Drill', 'PS SC End Mill',
       'Centre Drill', 'End Mill', 'Groove Cutter', 'U Drill',
       'Combine Step Drill', 'Reamer', 'Shell Mill',
       'Dia. 160 Shell Mill Cutter', '25.4 Gun Drill',
       'Dia. 10.72 Gun Drill', 'Tap ',
       'Dia. 400 Head face Milling Cutter',
       'Dia. 80 Cap Width Milling Rough ', 'Dia.63. Milling Cutter',
       'Dia. Shell Mill Cutter', 'Cham Drill',
       'Dia. 22.2 Burnishing Drill', 'Dia 125 Milling Cutter',
       'Dia. 125 Milling Cutter', 'Dia. 25.4 End Mill Cutter',
       'Dia. 80 Cap Width Milling finish', 'Dia. 10.76 Drill',
       'Dia.147 Crank Bore ', 'Ø125 Rough Milling', 'Ø 17.5 Drill',
       'Ø 6.8End Mill', 'M8*1.25 Tap', 'M14*2 Tap', 'Ø160Rough Milling',
       'Ø80 Rough', 'Ø32 Finish Boring Bar', 'Ø8.5 drill', 'Ø6.8 drill',
       'Ø24endmill', 'Ø28.5 chamfer', 'M14', 'M8', 'M10', 'Ø160 MC ',
       'Ø17.5 drill', 'Ø4.5 drill', 'Ø10.2 drill', ' M12',
       'Ø5 step drill', 'Ø20 end mill', 'Ø19.8 drill', 'Ø11.7 drill',
       'Ø8.5drill', 'Ø6.8drill', 'Ø250Face mill rough', 'Ø8.7 drill',
       'Ø6 drill STEP', 'Ø5drill', 'Ø100 Shell Mill Cutter',
       'Ø20 End Mill cutter', 'Ø6 .8 drill', 'Ø12×15×16.5×150 FL80 18S',
       'Ø100 Shell Mill Cutter on Top Face', 'Ø8.5 Drill on Top face',
       ' Ø6.8 Drill on top face', 'Ø11 End Mill', ' Ø14.5 Drill',
       ' Ø 8 Drill ', ' Ø12 Drill ', ' Ø16 Drill',
       'Ø12 Drill  Flywheel End ', 'Ø12 Drill Gear End',
       'Ø14.5 Drill Flywheel End ', 'Ø14.5 Drill Gear End',
       'Ø18.5 Drill Flywheel End Face ', 'Ø18.5 Drill Gear End Face ',
       'Boring Tool', 'Sleting Cutter', 'M10x1.5 Tap',
       'Shell mill cutter', 'Spotface Cutter', 'Milling Cutter ',
       'Ø73.5 Rough Boring Bar', 'Indaxable Chamfer Cutter',
       'Ø74 & Ø74.5 FINISH COMB. BORING Bar', 'Thread Mill / Tap',
       'Center Drill', 'Ø63 MILLING Cutter ', 'Ø40 SHELL MILL',
       'Ø73.5 ROUGH MILLING', 'DRILL', ' DRILL', 'ENDMILL',
       'ENDMILL R3.0', 'TAP', 'Finish Tripling cutter',
       'Rough  Tripling cutter', 'Ø40 Millng Cutter ',
       'Ø100 Millng Cutter ', 'Ø98 Boring Bar', 'Ø75 Boring Nar',
       'Ø 30 SPOT FACE CUTTER', 'Ø 28 SPOT FACE CUTTER', 'Ø16.5 U DRIL',
       'Ø16.5 Drill', 'Turning Tool ', 'Ø40 Shell Mill',
       'Ø68 Rough boring Bar', 'Ø17 Drill', 'Ø14.5 Drill',
       'Ø25 End mill R2.5', 'Ø 29.3 CORE DRILL', 'Ø 21 Drill',
       'Ø100  MILLING Cutter ', 'Ø 24.5 Drill', 'Ø 29.3 Core Drill',
       'Special Boring Bar', 'Special Boring bar', 'Ø16.5 U DRILL',
       'Tool Holder TTFR-25-150-6 ', ' Reamer Drill',
       'Lugg Carbide Drill', 'Insert', 'Rough boring bore',
       'Rough Milling Cutter', 'Milling Cutter  Backface',
       'Finish Milling Cutter', ' End Mill Finish ', 'End Mill Finish ',
       'End Mill ', 'End mill inside chamf. Finish', 'Champer Cutter',
       'Boring bore', ' U drill', 'End mill', 'Tripning cutter',
       'center  drill', 'Hole mill ', 'Boring', 'Turning Operation',
       'Facing', 'Spot Facing Operation', 'Drilling',
       'Turning  Operation', 'Milling  Operation', 'Balancing  Operation',
       'Drilling Operation ', 'MILLING', 'FACE MILLING', 'Tool holders',
       'Facing Turning', 'Spot face Cutter', 'Drilling ', 'Milling ',
       'Ø 35 U DRILL', 'Shell mill ', 'TRIAL FAIL', 'Center drill',
       'combine Boring bar'];


  final searchBarController = SearchController();
  final operationSearchController = SearchController(); // Add this line

  @override
  void initState() {
    super.initState();
    getValue();
  }

  Future<List<dynamic>> searchdoe() async {
    try {
      // Use the text from the search bar controller
      final searchText = searchBarController.text.isNotEmpty 
          ? searchBarController.text 
          : searchController.text;
      final response = await http.get(
        Uri.parse("https://doe-backend.onrender.com/doe/search?diameter=${searchText}&description=${operationSearchController.text}"),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List) {
          return jsonResponse;
        } else {
          throw Exception('Expected a list but got ${jsonResponse.runtimeType}');
        }
      } else {
        return [];
      }
    } catch (e) {
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
                const Text("Tool Diameter", style: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold, color: Colors.grey,),),
                const SizedBox(height: 10),
                SearchAnchor.bar(
                  searchController: searchBarController,
                  barHintText: "Search by tool diameter",
                  suggestionsBuilder: (context, controller) {
                    final query = controller.text.toLowerCase();
                    return tool_diamters
                      .where((diameter) => diameter.toLowerCase().contains(query))
                      .map((diameter) => ListTile(
                        title: Text(diameter),
                        onTap: () {
                          controller.text = diameter;
                          controller.closeView(diameter);
                          // Update the searchController text as well for consistency
                          searchController.text = diameter;
                        },
                      ))
                      .toList();
                  },
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

                const SizedBox(height: 40),
                const Text("Operations", style: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold, color: Colors.grey,)),
                const SizedBox(height: 10),
                SearchAnchor.bar(
                  searchController: operationSearchController, // Use the new SearchController
                  barHintText: "Operation",
                  suggestionsBuilder: (context, controller) {
                    final query = controller.text.toLowerCase();
                    return opertaions
                      .where((operation) => operation.toLowerCase().contains(query))
                      .map((operation) => ListTile(
                        title: Text(operation),
                        onTap: () {
                          controller.text = operation;
                          controller.closeView(operation);
                          // Update the operationTextController text as well for consistency
                          operationTextController.text = operation;
                        },
                      ))
                      .toList();
                  },
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
                                const SnackBar(
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
  
  @override
  void dispose() {
    searchController.dispose();
    searchBarController.dispose();
    operationTextController.dispose();
    operationSearchController.dispose(); // Add this line to dispose the new controller
    super.dispose();
  }
}