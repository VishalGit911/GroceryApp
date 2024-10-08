import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocery_admin/Firebase/firebase_services.dart';
import 'package:grocery_admin/Model/category_model.dart';
import 'package:grocery_admin/Widget/common_botton.dart';
import 'package:image_picker/image_picker.dart';

class CategoryManageScreen extends StatefulWidget {
  CategoryModel? categoryModel;

  CategoryManageScreen({super.key, this.categoryModel});

  @override
  State<CategoryManageScreen> createState() => _CategoryManageScreenState();
}

class _CategoryManageScreenState extends State<CategoryManageScreen> {
  bool isloading = false;
  XFile? newImage;
  final namecontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String? existingImage;

  @override
  void initState() {
    // TODO: implement initState

    if (widget.categoryModel != null) {
      namecontroller.text = widget.categoryModel!.name;
      descriptioncontroller.text = widget.categoryModel!.description;
      existingImage = widget.categoryModel!.imageUrl;
    }

    super.initState();
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
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    imagePickFunction();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.orange.shade100,
                      child: newImage == null && existingImage != null
                          ? CircleAvatar(
                              radius: 100,
                              foregroundImage: NetworkImage(existingImage!),
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Category Name";
                      } else {
                        return null;
                      }
                    },
                    controller: namecontroller,
                    decoration: const InputDecoration(
                        border: null, hintText: "Category Name"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Category Description";
                      } else {
                        return null;
                      }
                    },
                    controller: descriptioncontroller,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        border: null, hintText: "Category Description"),
                  ),
                ),
                CommonBotton(
                    isloading: isloading,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange.shade300,
                    onPressed: () {
                      addUpdateFunction();
                    },
                    text: widget.categoryModel == null
                        ? "Add Category"
                        : "Update Category")
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

        log(newImage!.path);
      });
    }
  }

  Future<void> addUpdateFunction() async {
    log("--------Call Add Or Update Function");
    if (formkey.currentState!.validate()) {
      if (newImage != null || existingImage != null) {
        setState(() {
          isloading = true;
        });

        await FirebaseServices().addOrUpdateCategory(
            categoryName: namecontroller.text.toString(),
            categoryDesc: descriptioncontroller.text.toString(),
            image: newImage,
            createdAt: widget.categoryModel?.createdAt,
            existingImageUrl: widget.categoryModel?.imageUrl,
            categoryId: widget.categoryModel?.id,
            context: context);
      }
    }
  }
}
