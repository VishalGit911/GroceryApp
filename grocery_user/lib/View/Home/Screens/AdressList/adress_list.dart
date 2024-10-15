// import 'package:flutter/material.dart';
// import 'package:grocery_user/Firebase/firebase_services.dart';
// import 'package:grocery_user/View/Home/Screens/AdressManage/adress_manage.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class AdressListScreen extends StatefulWidget {
//   const AdressListScreen({super.key});
//
//   @override
//   State<AdressListScreen> createState() => _AdressListScreenState();
// }
//
// class _AdressListScreenState extends State<AdressListScreen> {
//   Razorpay _razorpay = Razorpay();
//
//   @override
//   void initState() {
// late    _razorpay Razorpay();
//
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.white,
//       body: StreamBuilder(
//         stream: FirebaseServices().getAdress(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: Colors.orange,
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text("Error : ${snapshot.error}"),
//             );
//           } else if (snapshot.data == null || snapshot.data!.isEmpty) {
//             return Center(
//               child: Text("Not Your adress"),
//             );
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final alladress = snapshot.data![index];
//                 return Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       var options = {
//                         'key': 'rzp_test_zM4qU8Fjyzh49g',
//                         'amount': 50000, //in paise.
//                         'name': 'Acme Corp.',
//                         // Generate order_id using Orders API
//                         'description': 'Fine T-Shirt',
//                         'timeout': 60, // in seconds
//                         'prefill': {
//                           'contact': '9000090000',
//                           'email': 'gaurav.kumar@example.com'
//                         }
//                       };
//
//                       try {
//                         _razorpay.open(options);
//                       } catch (e) {}
//                     },
//                     child: Card(
//                       color: Colors.white,
//                       shadowColor: Colors.black,
//                       elevation: 10,
//                       child: ListTile(
//                         title: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("${alladress.buildingno}"),
//                             Text("${alladress.neararea}"),
//                             Text("${alladress.city}"),
//                             Text("${alladress.pincode}"),
//                             Text("${alladress.state}"),
//                           ],
//                         ),
//                         trailing: IconButton(
//                             onPressed: () {
//                               FirebaseServices()
//                                   .deleteAdress(adressId: alladress.adressId!);
//                             },
//                             icon: Icon(Icons.delete)),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.orange.shade300,
//         foregroundColor: Colors.white,
//         child: Icon(Icons.add),
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => AdressManageScreen(),
//               ));
//         },
//       ),
//     );
//   }
//
//   _handlePaymentSuccess() {}
//
//   _handlePaymentError() {}
//
//   _handleExternalWallet() {}
// }
