import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grocery_user/Model/category_model.dart';

import '../Model/product_model.dart';

class FirebaseServices {
  static FirebaseServices intance = FirebaseServices.named();

  FirebaseServices.named();

  factory FirebaseServices() {
    return intance;
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

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

  Stream<List<ProductModel>> getallproduct() {
    return _firebaseDatabase.ref().child("product").onValue.map(
      (event) {
        List<ProductModel> productList = [];
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> productMap =
              event.snapshot.value as Map<dynamic, dynamic>;

          productMap.forEach(
            (key, value) {
              ProductModel productModel = ProductModel.fromJson(value);
              productList.add(productModel);
            },
          );
        }
        return productList;
      },
    );
  }

  // Stream<List<ProductModel>> getAllProductForCategory(
  //     {required String categoryId}) {
  //   return _firebaseDatabase
  //       .ref()
  //       .child("product")
  //       .child("categoryId")
  //       .equalTo(categoryId)
  //       .onValue
  //       .map(
  //     (event) {
  //
  //     },
  //   );
  // }
  Stream<List<ProductModel>> getProductsByCategory(String categoryId) {
    return _firebaseDatabase
        .ref()
        .child('product')
        .orderByChild('categoryId')
        .equalTo(categoryId)
        .onValue
        .map((event) {
      List<ProductModel> productList = [];

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> productMap =
            event.snapshot.value as Map<dynamic, dynamic>;

        productMap.forEach(
          (key, value) {
            ProductModel productModel = ProductModel.fromJson(value);

            productList.add(productModel);
          },
        );
      }
      return productList;
    });
  }
}
