import 'package:flutter/material.dart';
import '../models/product_models.dart';
import 'dart:convert';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;



  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Produk"),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: .bold),
            ),
            const SizedBox(height: 10,),
            Text("Rp ${product.price}"),
            const SizedBox(height: 10,),
            Text(product.description),
            const SizedBox(height: 10,),
            product.image.isNotEmpty
                ? Image.memory(
                    base64Decode(product.image),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image, size: 100, color: Colors.blue),
          ],
          
        ),
      ),
    );
  }
}