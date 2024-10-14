import 'package:flutter/material.dart';
import 'package:grocery_user/Firebase/firebase_services.dart';
import 'package:grocery_user/View/Home/Screens/AdressManage/adress_manage.dart';

class AdressListScreen extends StatefulWidget {
  const AdressListScreen({super.key});

  @override
  State<AdressListScreen> createState() => _AdressListScreenState();
}

class _AdressListScreenState extends State<AdressListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseServices().getAdress(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text("Not Your adress"),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final alladress = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Card(
                      color: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 10,
                      child: ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${alladress.buildingno}"),
                            Text("${alladress.neararea}"),
                            Text("${alladress.city}"),
                            Text("${alladress.pincode}"),
                            Text("${alladress.state}"),
                          ],
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              FirebaseServices()
                                  .deleteAdress(adressId: alladress.adressId!);
                            },
                            icon: Icon(Icons.delete)),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade300,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdressManageScreen(),
              ));
        },
      ),
    );
  }
}
