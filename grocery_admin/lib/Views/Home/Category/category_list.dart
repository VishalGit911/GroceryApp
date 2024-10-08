import 'package:flutter/material.dart';
import 'package:grocery_admin/Firebase/firebase_services.dart';

import 'category_manage.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            borderSide: BorderSide.none),
        title: Text("Category"),
        backgroundColor: Colors.orange.shade300,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryManageScreen(),
              ));
        },
        backgroundColor: Colors.orange.shade300,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseServices().getAllCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.orange.shade500,
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
                final allData = snapshot.data![index];

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryManageScreen(
                              categoryModel: allData,
                            ),
                          ));
                    },
                    child: Card(
                      color: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          allData.name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          allData.description,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(allData.imageUrl),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              FirebaseServices()
                                  .deleteCategory(categoryId: allData.id!);
                            },
                            icon: Icon(Icons.delete)),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Text("Not Found");
          }
        },
      ),
    );
  }
}
