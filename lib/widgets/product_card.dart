import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product_models.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text("RP ${product.price}"),
            const SizedBox(height: 5),
            Text(product.description),
            product.image.isNotEmpty
                ? Image.memory(
                    base64Decode(product.image),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.image,
                    size: 100,
                    color: Colors.blue,
                  ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: onEdit,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    ),
  );
}
}