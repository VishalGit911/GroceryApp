import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:grocery_admin/Model/category_model.dart';
import 'package:grocery_admin/Model/product_model.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseServices {
  static FirebaseServices intance = FirebaseServices.named();

  FirebaseServices.named();

  factory FirebaseServices() {
    return intance;
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<User?> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOutEmaiPassword() async {
    await _firebaseAuth.signOut();
  }

  Future<void> addOrUpdateCategory({
    String? categoryName,
    String? categoryDesc,
    int? createdAt,
    XFile? image,
    String? categoryId,
    String? existingImageUrl,
    required BuildContext context,
  }) async {
    String newImageUrl = existingImageUrl ?? "";
    int? timestamp = createdAt ?? DateTime.now().millisecondsSinceEpoch;
    log("TimeStamp : $timestamp");
    if (image != null) {
      String? imageName = "${DateTime.now().millisecondsSinceEpoch}.png";
      log("Image Name  : ${imageName}");
      File imageFile = File(image.path);
      log("Image File : ${imageFile}");

      TaskSnapshot snapshot = await _firebaseStorage
          .ref()
          .child("category")
          .child(imageName)
          .putFile(imageFile);
      log("--------Image Successfully Add-------");

      newImageUrl = await snapshot.ref.getDownloadURL();
      log("New Image Url : ${newImageUrl}");
    }
    CategoryModel categoryModel = CategoryModel(
        name: categoryName!,
        description: categoryDesc!,
        imageUrl: newImageUrl,
        isActive: true,
        createdAt: timestamp,
        id: categoryId);
    if (categoryModel.id == null) {
      String? newGenerate =
          _firebaseDatabase.ref().child("category").push().key;

      categoryModel.id = newGenerate;
      log("New Generate Id  : ${newGenerate}");

      await _firebaseDatabase
          .ref()
          .child("category")
          .child(newGenerate!)
          .set(categoryModel.toJson());

      log("--------Category Add Successfully-------");
      Navigator.pop(context);
    } else {
      log("--------Call the Update -------");
      await _firebaseDatabase
          .ref()
          .child("category")
          .child(categoryId!)
          .update(categoryModel.toJson());
      log("------Update Successfully-------");
      Navigator.pop(context);
    }
  }

  Stream<List<CategoryModel>> getAllCategory() {
    return _firebaseDatabase.ref().child("category").onValue.map(
      (event) {
        List<CategoryModel> categoryList = [];

        if (event.snapshot.exists) {
          Map<dynamic, dynamic> categoryMap =
              event.snapshot.value as Map<dynamic, dynamic>;

          categoryMap.forEach(
            (key, value) {
              CategoryModel categoryModel = CategoryModel.fromJson(value);
              categoryList.add(categoryModel);
            },
          );
        }
        return categoryList;
      },
    );
  }

  Future<bool> deleteCategory({required String categoryId}) async {
    try {
      await _firebaseDatabase
          .ref()
          .child("category")
          .child(categoryId)
          .remove();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<CategoryModel>> getCategoryForProuduct() async {
    List<CategoryModel> categoryList = [];

    DataSnapshot snapshot =
        await _firebaseDatabase.ref().child("category").get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> categoryMap =
          snapshot.value as Map<dynamic, dynamic>;

      categoryMap.forEach(
        (key, value) {
          CategoryModel categoryModel = CategoryModel.fromJson(value);

          categoryList.add(categoryModel);
        },
      );
    }
    return categoryList;
  }

  Future<void> addOrUpdateProduct({
    required String productName,
    required String productDesc,
    required double price,
    required int stock,
    required categoryId,
    required BuildContext context,
    int? created,
    String? productId,
    String? existingImage,
    XFile? image,
    bool? intop,
  }) async {
    int? timstam = created ?? DateTime.now().millisecondsSinceEpoch;
    String? newImageUrl = existingImage ?? "";
    if (image != null) {
      String? imagename = "${DateTime.now().millisecondsSinceEpoch}.png";

      File imageFile = File(image.path);

      TaskSnapshot snapshot = await _firebaseStorage
          .ref()
          .child("product")
          .child(imagename)
          .putFile(imageFile);

      String imageUrl = await snapshot.ref.getDownloadURL();
      newImageUrl = imageUrl;
      log("----------- Image Upload Successfully----------");
    }

    Product productmodel = Product(
      name: productName,
      description: productDesc,
      price: price,
      stock: stock,
      imageUrl: newImageUrl,
      createdAt: timstam,
      categoryId: categoryId,
      id: productId,
    );

    if (productmodel.id == null) {
      String? newgenerateId =
          _firebaseDatabase.ref().child("product").push().key;

      productmodel.id = newgenerateId;

      await _firebaseDatabase
          .ref()
          .child("product")
          .child(newgenerateId!)
          .set(productmodel.toJson());

      log("------------Product Add SuccessFully-------------");

      Navigator.pop(context);
    } else {
      await _firebaseDatabase
          .ref()
          .child("product")
          .child(productId!)
          .update(productmodel.toJson());
      log("------Update SuccessFully-------");
      Navigator.pop(context);
    }
  }

  Stream<List<Product>> getAllProduct() {
    return _firebaseDatabase.ref().child("product").onValue.map(
      (event) {
        List<Product> productList = [];
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> productMap =
              event.snapshot.value as Map<dynamic, dynamic>;

          productMap.forEach(
            (key, value) {
              Product product = Product.fromJson(value);

              productList.add(product);
            },
          );
        }
        return productList;
      },
    );
  }

  Future<bool> deleteProduct({required String productId}) async {
    try {
      await _firebaseDatabase.ref().child("product").child(productId).remove();

      return true;
    } catch (e) {
      return false;
    }
  }
}
