import 'package:flutter/material.dart';
import 'package:grocery_admin/Firebase/firebase_services.dart';
import 'package:grocery_admin/Views/Home/Product/product_manage.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            borderSide: BorderSide.none),
        title: Text("Product"),
        backgroundColor: Colors.blue.shade300,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductManageScreen(),
              ));
        },
        backgroundColor: Colors.blue.shade300,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseServices().getAllProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade400,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final alldata = snapshot.data![index];

                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductManageScreen(
                              product: alldata,
                            ),
                          ));
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.black,
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name: ${alldata.name}",
                                textAlign: TextAlign.start),
                            Text(
                              "Desc: ${alldata.description}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                            Text("Price: ${alldata.price}",
                                textAlign: TextAlign.start),
                            Text("Stock: ${alldata.stock}",
                                textAlign: TextAlign.start)
                          ],
                        ),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(alldata.imageUrl),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              FirebaseServices()
                                  .deleteProduct(productId: alldata.id!);
                            },
                            icon: Icon(Icons.delete)),
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
      ),
    );
  }
}
