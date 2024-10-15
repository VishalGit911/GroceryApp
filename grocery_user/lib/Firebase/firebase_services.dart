import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_user/Model/adress.dart';
import 'package:grocery_user/Model/cart.dart';
import 'package:grocery_user/Model/category.dart';

import '../Model/product.dart';
import '../Model/user.dart';

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

  Future<User?> registerEmail(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential.user;
    } catch (E) {
      rethrow;
    }
  }

  Future<bool> createUserAndStoreInDatabase(UserData userData) async {
    try {
      await _firebaseDatabase
          .ref()
          .child('users')
          .child(userData.id)
          .set(userData.toJson());

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

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

  Future<UserData?> getUserData() async {
    try {
      var user = FirebaseAuth.instance.currentUser!.uid;

      log("user : $user");

      DataSnapshot dataSnapshot =
          await _firebaseDatabase.ref().child("users").child(user).get();

      log("DataSnapshot : ${dataSnapshot.value}");

      UserData userData = UserData.fromJson(dataSnapshot.value);

      log(userData.id);
      log(userData.name);
      log(userData.email);

      return userData;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> addToCartProduct(
      {required ProductModel product,
      required int quantity,
      required BuildContext context}) async {
    try {
      String userId = _firebaseAuth.currentUser!.uid;

      DatabaseReference ref = _firebaseDatabase
          .ref()
          .child("cart")
          .child(userId)
          .child("product")
          .child(product.id!);

      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        ref.update({
          "quantity": quantity,
          "totalPrice": (product.price * quantity).toDouble()
        });
      } else {
        Cart cart = Cart(
            id: product.id!,
            name: product.name,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl,
            quantity: quantity,
            createdAt: product.createdAt,
            totalPrice: (product.price * quantity).toDouble());

        ref.set(cart.toJson());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<Cart>> getCartProduct() {
    String userId = _firebaseAuth.currentUser!.uid;

    return _firebaseDatabase
        .ref()
        .child("cart")
        .child(userId)
        .child("product")
        .onValue
        .map(
      (event) {
        List<Cart> cartList = [];
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> cartMap =
              event.snapshot.value as Map<dynamic, dynamic>;

          cartMap.forEach(
            (key, value) {
              Cart cart = Cart.fromJson(value);

              cartList.add(cart);
            },
          );
        }
        return cartList;
      },
    );
  }

  void updataCartProduct({
    required Cart cart,
    required String cartID,
  }) {
    try {
      String userId = _firebaseAuth.currentUser!.uid;

      _firebaseDatabase
          .ref()
          .child("cart")
          .child(userId)
          .child("product")
          .child(cartID)
          .update(cart.toJson());
    } catch (e) {}
  }

  bool deleteCartProduct({
    required Cart cart,
    required String cartID,
  }) {
    try {
      String userId = _firebaseAuth.currentUser!.uid;

      _firebaseDatabase
          .ref()
          .child("cart")
          .child(userId)
          .child("product")
          .child(cartID)
          .remove();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getUserDetails() async {}

  Future<void> addAdressFirebase(
      {required String buildingno,
      required String neararea,
      required String city,
      required String pincode,
      required String state,
      required BuildContext context}) async {
    String userID = _firebaseAuth.currentUser!.uid;

    final adressId =
        _firebaseDatabase.ref().child("adress").child(userID).push().key;

    AdressModel adressModel = AdressModel(
        adressId: adressId,
        buildingno: buildingno,
        neararea: neararea,
        city: city,
        pincode: pincode,
        state: state);

    await _firebaseDatabase
        .ref()
        .child("adress")
        .child(userID)
        .child(adressId!)
        .set(adressModel.toJson());

    Navigator.pop(context);
  }

  Stream<List<AdressModel>> getAdress() {
    String userId = _firebaseAuth.currentUser!.uid;

    return _firebaseDatabase.ref().child("adress").child(userId).onValue.map(
      (event) {
        List<AdressModel> adressList = [];

        if (event.snapshot.exists) {
          Map<dynamic, dynamic> adressMap =
              event.snapshot.value as Map<dynamic, dynamic>;

          adressMap.forEach(
            (key, value) {
              AdressModel adressModel = AdressModel.fromJson(value);
              adressList.add(adressModel);
            },
          );
        }
        return adressList;
      },
    );
  }

  bool deleteAdress({required String adressId}) {
    String userID = _firebaseAuth.currentUser!.uid;

    try {
      _firebaseDatabase
          .ref()
          .child("adress")
          .child(userID)
          .child(adressId)
          .remove();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Cart>> getTotalPriceForCheckOut() async {
    String userId = _firebaseAuth.currentUser!.uid;

    List<Cart> cartListPrice = [];

    DatabaseReference reference =
        _firebaseDatabase.ref().child("cart").child(userId).child("product");

    DataSnapshot snapshot = await reference.get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> totalPriceMap =
          snapshot.value as Map<dynamic, dynamic>;

      totalPriceMap.forEach(
        (key, value) {
          Cart cart = Cart.fromJson(value);

          cartListPrice.add(cart);
        },
      );
    }
    return cartListPrice;
  }
}
