import 'package:flutter/material.dart';
import 'package:zanvar_doe_app/data/notifiers.dart';

class FinalResultScreen extends StatelessWidget {
  final Map<String, String> selectedData;

  const FinalResultScreen({super.key, required this.selectedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Final Results",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Response Results  "),
              _buildCard([
                _buildRow(
                  "Cycle Time (Seconds)",
                  selectedData["Cycle_Time_In_Seconds"] ?? "N/A",
                ),
                _buildRow(
                  "Spindle Load",
                  selectedData["Spindle_Load"] ?? "N/A",
                ),
                _buildRow(
                  "Tool Life (Nos)",
                  selectedData["Tool_Life_In_Nos"] ?? "N/A",
                ),
                _buildRow(
                  "Tool Life (Mtr)",
                  selectedData["Tool_Life_In_Mtr"] ?? "N/A",
                ),
                _buildRow("CPC (Rs)", selectedData["CPC_In_Rs"] ?? "N/A"),
                _buildRow(
                  "Diameter CPK",
                  selectedData["Diameter_CPK"] ?? "N/A",
                ),
                _buildRow(
                  "Surface Finish CPK",
                  selectedData["Surface_Finish_Cpk"] ?? "N/A",
                ),
              ]),
              const SizedBox(height: 20),
              _buildSectionTitle("All Input Parameters"),
              _buildCard(
                selectedData.entries
                    .map((entry) => _buildRow(entry.key, entry.value))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/home_screen');
                  },
                  child: const Text("Go To Dashboard"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
