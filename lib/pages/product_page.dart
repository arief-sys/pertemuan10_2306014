import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pertemuan10_2306014/pages/product_detail_page.dart';
import 'package:pertemuan10_2306014/widgets/product_card.dart';
import '../models/product_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<ProductModel> products = [];

  Future<void> loadProducts() async {
    final res = await SharedPreferences.getInstance();
    List<String> productList = res.getStringList('products') ?? [];
    ;
    setState(() {
      products = productList.reversed
          .take(3)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProducts();
  }

  //metode save product
  Future<void> saveProducts() async {
    final res = await SharedPreferences.getInstance();
    List<String> productList = products.map((item) => item.toJson()).toList();
    await res.setStringList('products', productList);
  }

  //metode add product
  Future<void> addProducts(ProductModel product) async {
    setState(() {
      products.add(product);
    });

    await saveProducts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Produk berhasil ditambahkan")),
    );
  }

  // metode update product
  Future<void> updateProducts(int index, ProductModel product) async {
    setState(() {
      products[index] = product;
    });

    await saveProducts();
  }

  //metode delete product
  Future<void> deleteProducts(int index) async {
    setState(() {
      products.removeAt(index);
    });

    await saveProducts();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Produk berhasil dihapus")));
  }

  Future<String> convertImagetoBase64(XFile image) async {
    Uint8List bytes = await image.readAsBytes();

    return base64Encode(bytes);
  }

  void showForm({ProductModel? product, int? index}) {
    TextEditingController nameController = TextEditingController(
      text: product?.name ?? "",
    );
    TextEditingController descriptionController = TextEditingController(
      text: product?.description ?? "",
    );
    TextEditingController priceController = TextEditingController(
      text: product?.price.toString() ?? "",
    );
    TextEditingController imgController = TextEditingController(
      text: product?.image ?? "",
    );

    XFile? selectedImage;
    final ImagePicker picker = ImagePicker();

    Future<void> pickImage(StateSetter setDialogState) async {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setDialogState(() {
          selectedImage = image;
          imgController.text = image.path;
        });
      }
    }

    Widget previewImageWidget() {
      if (selectedImage != null) {
        return FutureBuilder<Uint8List>(
          future: selectedImage!.readAsBytes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return Image.memory(
              snapshot.data!,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            );
          },
        );
      }

      if (product != null && product.image.isNotEmpty) {
        try {
          final bytes = base64Decode(product.image);
          return Image.memory(
            bytes,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          );
        } catch (_) {
          return const SizedBox.shrink();
        }
      }

      return const SizedBox.shrink();
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(product == null ? "Tambah Produk" : "Edit Produk"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Nama"),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: "Deskripsi"),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: "Harga"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => pickImage(setDialogState),
                      icon: const Icon(Icons.image),
                      label: const Text("Pilih Gambar"),
                    ),
                    const SizedBox(height: 10),
                    previewImageWidget(),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    String imageBase64 = product?.image ?? "";
                    if (selectedImage != null) {
                      imageBase64 = await convertImagetoBase64(selectedImage!);
                    }

                    final parsedPrice = int.tryParse(priceController.text) ?? 0;
                    final newProduct = ProductModel(
                      name: nameController.text,
                      description: descriptionController.text,
                      price: parsedPrice,
                      image: imageBase64,
                    );

                    if (product == null) {
                      await addProducts(newProduct);
                    } else {
                      await updateProducts(index!, newProduct);
                    }

                    if (mounted) Navigator.of(context).pop();
                  },
                  child: const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Produk",
          style: TextStyle(color: Colors.white, fontWeight: .bold),
        ),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left, color: Colors.white),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => showForm(),
                    child: const Text("Tambah Produk"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text("Belum ada produk"))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          onDelete: () => deleteProducts(index),
                          onEdit: () =>
                              showForm(product: product, index: index),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(product: product),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
