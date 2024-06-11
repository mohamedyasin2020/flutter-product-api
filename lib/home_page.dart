import 'package:flutter/material.dart';
import 'package:flutter_product_api/product_page.dart';
import 'package:flutter_product_api/server_page.dart';

class HomeScreen extends StatefulWidget {
  final HomeController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) =>
              widget.controller.userModel.username = value,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10.0),
            TextField(
              onChanged: (value) =>
              widget.controller.userModel.password = value,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                await widget.controller.loginUser(); // Use async/await
                // Check login success before navigating
                if (widget.controller.userModel.authToken != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductView(controller: widget.controller),
                    ),
                  );
                } else {
                  // Handle login failure (optional)
                  print('Login failed');
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
