import 'package:flutter/material.dart';
import 'package:grocery_admin/Firebase/firebase_services.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              borderSide: BorderSide.none),
          title: Text("User"),
          backgroundColor: Colors.deepPurple.shade200,
          foregroundColor: Colors.black,
        ),
        body: StreamBuilder(
          stream: FirebaseServices().getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error : ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      shadowColor: Colors.black,
                      child: ListTile(
                        trailing: IconButton(
                            onPressed: () {}, icon: Icon(Icons.delete)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name : ${snapshot.data![index].name}"),
                            Text("Contact : ${snapshot.data![index].contact}"),
                            Text("Email : ${snapshot.data![index].email}"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
