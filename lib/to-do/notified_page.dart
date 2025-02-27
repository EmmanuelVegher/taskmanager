import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifiedPage extends StatelessWidget {
  final String? label;
  final String? body; // Add body parameter

  const NotifiedPage({Key? key, required this.label, this.body}) : super(key: key); // Add body to constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label ?? "Notification Details"), // Use label or default title
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hello Flutter!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (label != null) // Conditionally show label
                Text(
                  "Notification Title: $label",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              if (body != null) // Conditionally show body (note)
                Text(
                  "Notification Body: $body",
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.back(); // Navigate back
                },
                child: const Text("Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}