import 'package:flutter/material.dart';

import 'package:flutter_product_api/model_page.dart';
import 'package:flutter_product_api/server_page.dart';

class ProductView extends StatefulWidget {
  final HomeController controller;

  const ProductView({super.key, required this.controller});

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  ProductModel? _productModel; // Declaring as nullable

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final productModel = await widget.controller.fetchProducts();
    setState(() {
      _productModel = productModel;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: _productModel != null
          ? GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.75,
        ),
        itemCount: _productModel!.products!.length,
        itemBuilder: (context, index) {
          final product = _productModel!.products![index];
          final productRating = product.rating?.toDouble();
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    product.thumbnail ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                ListTile(
                  title: Text(product.title ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: ${product.price.toString()}'),
                      Text('Rating: ${productRating?.toString() ?? '-'}'),
                      // Add more widgets to display other product details
                    ],
                  ),
                  leading: Icon(Icons.shopping_cart),
                ),
              ],
            ),
          );
        },
      )
          : Center(child: CircularProgressIndicator()), // Loading indicator when _productModel is null
    );
  }
}
