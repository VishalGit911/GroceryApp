import 'package:grocery_user/Model/adress.dart';

import 'cart.dart';

class OrderData {
  List<Cart>? cartItems;
  double? totalAmount;
  AdressModel? address;

  OrderData({this.cartItems, this.totalAmount, this.address});
}
