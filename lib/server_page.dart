import 'dart:convert';

import 'package:flutter_product_api/model_page.dart';
import 'package:http/http.dart' as http;
class HomeController {
  static String baseUrl = 'https://dummyjson.com/auth/';
  static String loginEndpoint = 'login';
  static String productEndPoint = 'products';
  final UserModel userModel;
  final ProductModel productModel;

  HomeController({required this.userModel, required this.productModel});

  Future<void> loginUser() async {
    final body = jsonEncode({
      'username': userModel.username,
      'password': userModel.password,
    });

    try {
      final response = await http.post(
        Uri.parse(HomeController.baseUrl + HomeController.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('------>login successfully');
        userModel.authToken = data['token'];
        print('------>${userModel.authToken}');
        // Handle successful login here, e.g., navigate to next screen
      } else {
        // Handle login failure
        print('Login failed: ${response.body}');
      }
    } catch (error) {
      // Handle errors during request
      print('Error during login: $error');
    }
  }

  Future<ProductModel>? fetchProducts() async {
    try {
      if (userModel.authToken == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.get(
        Uri.parse(baseUrl + productEndPoint),
        headers: {'Authorization': 'Bearer ${userModel.authToken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('products') && data['products'] is List) {
          return ProductModel.fromJson(data);
        } else {
          throw Exception('Unexpected response format for products');
        }
      } else {
        throw Exception('Product fetch failed: ${response.body}');
      }
    } catch (error) {
      print('Error fetching products: $error');
      throw error; // Rethrow the caught error
    }
  }
}
