import 'package:flutter/material.dart';import 'package:grocery_admin/Firebase/firebase_services.dart';import 'package:grocery_admin/Views/Home/Category/category_list.dart';import 'package:grocery_admin/Views/Home/Order/order_screen.dart';import 'package:grocery_admin/Views/Home/Product/product_list.dart';import 'package:grocery_admin/Views/Home/User/user_screen.dart';import 'package:grocery_admin/Views/SignIn/signin_screen.dart';import 'package:shimmer/shimmer.dart';class HomeScreen extends StatefulWidget {  const HomeScreen({super.key});  @override  State<HomeScreen> createState() => _HomeScreenState();}class _HomeScreenState extends State<HomeScreen> {  @override  Widget build(BuildContext context) {    return Scaffold(        backgroundColor: Colors.white,        appBar: AppBar(          centerTitle: true,          title: Text("Grocery Admin Panel"),          backgroundColor: Colors.white,          foregroundColor: Colors.black,        ),        body: StreamBuilder(          stream: FirebaseServices().fatchDashBoardData(),          builder: (context, snapshot) {            if (snapshot.connectionState == ConnectionState.waiting) {              return SingleChildScrollView(                child: Column(                  children: [                    Padding(                      padding: const EdgeInsets.only(top: 20),                      child: Row(                        mainAxisAlignment: MainAxisAlignment.spaceAround,                        children: [                          Expanded(                            flex: 5,                            child: Padding(                              padding: const EdgeInsets.all(10.0),                              child: Shimmer.fromColors(                                baseColor: Colors.grey.shade300,                                highlightColor: Colors.grey.shade100,                                child: Container(                                  height: 250,                                  decoration: BoxDecoration(                                    color: Colors.white,                                    borderRadius: BorderRadius.circular(20),                                  ),                                ),                              ),                            ),                          ),                          Expanded(                            flex: 5,                            child: Padding(                              padding: const EdgeInsets.all(10.0),                              child: Shimmer.fromColors(                                baseColor: Colors.grey.shade300,                                highlightColor: Colors.grey.shade100,                                child: Container(                                  height: 250,                                  decoration: BoxDecoration(                                    color: Colors.white,                                    borderRadius: BorderRadius.circular(20),                                  ),                                ),                              ),                            ),                          ),                        ],                      ),                    ),                    Row(                      mainAxisAlignment: MainAxisAlignment.spaceAround,                      children: [                        Expanded(                          flex: 5,                          child: Padding(                            padding: const EdgeInsets.all(10.0),                            child: Shimmer.fromColors(                              baseColor: Colors.grey.shade300,                              highlightColor: Colors.grey.shade100,                              child: Container(                                height: 250,                                decoration: BoxDecoration(                                  color: Colors.white,                                  borderRadius: BorderRadius.circular(20),                                ),                              ),                            ),                          ),                        ),                        Expanded(                          flex: 5,                          child: Padding(                            padding: const EdgeInsets.all(10.0),                            child: Shimmer.fromColors(                              baseColor: Colors.grey.shade300,                              highlightColor: Colors.grey.shade100,                              child: Container(                                height: 250,                                decoration: BoxDecoration(                                  color: Colors.white,                                  borderRadius: BorderRadius.circular(20),                                ),                              ),                            ),                          ),                        ),                      ],                    ),                  ],                ),              );            } else if (snapshot.hasError) {              return Center(child: Text("Error : ${snapshot.error}"));            } else {              return SingleChildScrollView(                child: Column(                  children: [                    Padding(                      padding: const EdgeInsets.only(top: 20),                      child: Row(                        mainAxisAlignment: MainAxisAlignment.spaceAround,                        children: [                          Expanded(                            flex: 5,                            child: Padding(                              padding: const EdgeInsets.all(10.0),                              child: CommonContainer(                                count: "${snapshot.data!.totalCategories}",                                backgroundColor: Colors.orange.shade100,                                color: Colors.orange.shade300,                                text: "Category",                                image: "assets/images/category.png",                                onTap: () {                                  Navigator.push(                                      context,                                      MaterialPageRoute(                                        builder: (context) =>                                            CategoryListScreen(),                                      ));                                },                              ),                            ),                          ),                          Expanded(                            flex: 5,                            child: Padding(                              padding: const EdgeInsets.all(10.0),                              child: CommonContainer(                                count: "${snapshot.data!.totalItems}",                                backgroundColor: Colors.blue.shade100,                                color: Colors.blue.shade300,                                text: "Product",                                image: "assets/images/product.png",                                onTap: () {                                  Navigator.push(                                      context,                                      MaterialPageRoute(                                        builder: (context) =>                                            ProductListScreen(),                                      ));                                },                              ),                            ),                          ),                        ],                      ),                    ),                    Row(                      mainAxisAlignment: MainAxisAlignment.spaceAround,                      children: [                        Expanded(                          flex: 5,                          child: Padding(                            padding: const EdgeInsets.all(10.0),                            child: CommonContainer(                              count: "${snapshot.data!.totalOrders}",                              backgroundColor: Colors.pink.shade100,                              color: Colors.pink.shade300,                              text: "Order",                              image: 'assets/images/order.png',                              onTap: () {                                Navigator.push(                                    context,                                    MaterialPageRoute(                                      builder: (context) => OrderScreen(),                                    ));                              },                            ),                          ),                        ),                        Expanded(                          flex: 5,                          child: Padding(                            padding: const EdgeInsets.all(10.0),                            child: CommonContainer(                              count: "${snapshot.data!.totalUsers}",                              backgroundColor: Colors.deepPurple.shade100,                              color: Colors.deepPurple.shade300,                              text: "User",                              image: "assets/images/user.png",                              onTap: () {                                Navigator.push(                                    context,                                    MaterialPageRoute(                                      builder: (context) => UserScreen(),                                    ));                              },                            ),                          ),                        ),                      ],                    ),                  ],                ),              );            }          },        ),        drawer: Drawerfunction());  }  Widget CommonContainer(      {required Color? color,      required text,      required count,      required String image,      required Color? backgroundColor,      required void Function()? onTap}) {    return GestureDetector(      onTap: onTap,      child: Container(        height: 250,        decoration: BoxDecoration(            color: color, borderRadius: BorderRadius.circular(20)),        child: Column(          mainAxisAlignment: MainAxisAlignment.center,          crossAxisAlignment: CrossAxisAlignment.center,          children: [            CircleAvatar(              backgroundColor: backgroundColor,              child: Image.asset(                image,                height: 50,              ),              radius: 50,            ),            Padding(              padding: const EdgeInsets.only(top: 4.0),              child: Text(                count,                style: TextStyle(                    fontSize: 25,                    color: Colors.white,                    fontWeight: FontWeight.bold),              ),            ),            Text(              text,              style: TextStyle(                  fontSize: 25,                  color: Colors.white,                  fontWeight: FontWeight.bold),            )          ],        ),      ),    );  }  Widget Drawerfunction() {    return Drawer(      child: ListView(        padding: EdgeInsets.zero,        children: [          DrawerHeader(            decoration: BoxDecoration(color: Colors.green.shade300),            child: Center(                child: Text(              FirebaseServices().getUserEmail().toString(),              style: TextStyle(                  fontSize: 25,                  fontWeight: FontWeight.normal,                  color: Colors.white),            )),          ),          ListTile(            title: Text("Category"),            trailing: Icon(Icons.card_travel),            onTap: () {              Navigator.push(                  context,                  MaterialPageRoute(                    builder: (context) => CategoryListScreen(),                  ));            },          ),          ListTile(            title: Text('Product'),            trailing: Icon(Icons.shopping_cart_outlined),            onTap: () {              Navigator.push(                  context,                  MaterialPageRoute(                    builder: (context) => ProductListScreen(),                  ));            },          ),          ListTile(            title: Text('Order'),            trailing: Icon(Icons.bookmark_border),            onTap: () {              Navigator.push(                  context,                  MaterialPageRoute(                    builder: (context) => OrderScreen(),                  ));            },          ),          ListTile(            title: Text('User'),            trailing: Icon(Icons.supervised_user_circle_outlined),            onTap: () {              Navigator.push(                  context,                  MaterialPageRoute(                    builder: (context) => UserScreen(),                  ));            },          ),          ListTile(            title: Text('Log-out'),            trailing: Icon(Icons.logout),            onTap: () async {              showDialog(                context: context,                builder: (ctx) => AlertDialog(                  title: const Text("Are you sore ? "),                  content: const Text("Log out"),                  actions: <Widget>[                    TextButton(                        onPressed: () {                          Navigator.pop(context);                        },                        child: const Text("Cancel")),                    TextButton(                      onPressed: () {                        Navigator.pushAndRemoveUntil(                          context,                          MaterialPageRoute(                            builder: (context) => SignInScreen(),                          ),                          (route) => false,                        );                      },                      child: const Text("Ok"),                    ),                  ],                ),              );            },          ),        ],      ),    );  }}