import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/Firebase/firebase_services.dart';
import 'package:grocery_admin/Model/category_model.dart';
import 'package:grocery_admin/Model/product_model.dart';
import 'package:grocery_admin/Widget/common_botton.dart';
import 'package:image_picker/image_picker.dart';

class ProductManageScreen extends StatefulWidget {
  Product? product;

  ProductManageScreen({super.key, this.product});

  @override
  State<ProductManageScreen> createState() => _ProductManageScreenState();
}

class _ProductManageScreenState extends State<ProductManageScreen> {
  @override
  void initState() {
    // TODO: implement initState

    if (widget.product != null) {
      nameController.text = widget.product!.name;
      descriptionController.text = widget.product!.description;
      priceController.text = widget.product!.price.toString();
      stockController.text = widget.product!.stock.toString();
      categoryId = widget.product!.categoryId;
      existingImageUrl = widget.product!.imageUrl;
      setState(() {});
    }

    getcategory();
    super.initState();
  }

  bool isloading = false;
  String? categoryId;
  String? existingImageUrl;
  XFile? newImage;
  final formkey = GlobalKey<FormState>();
  List<CategoryModel> categoryList = [];

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  Future<void> getcategory() async {
    List<CategoryModel> tempList =
        await FirebaseServices().getCategoryForProuduct();

    setState(() {
      categoryList = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    imagePickFunction();
                  },
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.white,
                    child: newImage == null && existingImageUrl != null
                        ? CircleAvatar(
                            radius: 100,
                            foregroundImage: NetworkImage(existingImageUrl!),
                          )
                        : newImage != null
                            ? CircleAvatar(
                                radius: 100,
                                foregroundImage: FileImage(
                                  File(newImage!.path),
                                ),
                              )
                            : const Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.white,
                              ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Product Name'),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an Product name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: descriptionController,
                    decoration:
                        const InputDecoration(labelText: 'Product Description'),
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an Product description';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: priceController,
                          decoration: const InputDecoration(labelText: 'Price'),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: stockController,
                          decoration: const InputDecoration(
                              labelText: 'Stock Quantity'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the stock quantity';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: DropdownButtonFormField(
                    value: categoryId,
                    decoration: InputDecoration(labelText: "Select Category"),
                    items: categoryList.map((e) {
                      return DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      print(value);
                      categoryId = value;
                    },
                  ),
                ),
                CommonIndicatorButton(
                    isloading: isloading,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue.shade300,
                    onPressed: () {
                      addUpdateFunction();
                    },
                    text: widget.product != null
                        ? "Update Product"
                        : "Add Product")
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> imagePickFunction() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        newImage = image;
      });
    }
  }

  Future<void> addUpdateFunction() async {
    if (formkey.currentState!.validate()) {
      if (newImage != null || existingImageUrl != null) {
        setState(() {
          isloading = true;
        });

        await FirebaseServices().addOrUpdateProduct(
            productName: nameController.text.toString(),
            productDesc: descriptionController.text.toString(),
            price: double.parse(priceController.text.toString()),
            stock: int.parse(stockController.text.toString()),
            categoryId: categoryId,
            image: newImage,
            productId: widget.product?.id,
            existingImage: existingImageUrl,
            created: widget.product?.createdAt,
            context: context);
      }
    }
  }
}
