import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CashApp extends StatelessWidget {
  const CashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.cancel_outlined,
          color: Colors.black,
        ),
        actions: [
          const Icon(
            Icons.more_horiz,
            color: Colors.black,
          ),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(35)),
                width: 60,
                height: 60,
                child: const Center(child: Text("S")),
              ),
              const SizedBox(height: 10),
              const Text(
                "Said0811",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                "Payment to \$shanpaigey",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
              ),
              const SizedBox(height: 200),
              const Center(
                  child: Text(
                "\$20.00",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 50),
              )),
              const Text(
                "Today at 23:00PM",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
              ),
              const SizedBox(
                height: 200,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(25)),
                child: const Center(
                  child: Text(
                    "Completed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                "Web Receipt",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
