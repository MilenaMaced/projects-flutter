import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../datas/product_data.dart';
import '../tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key, required this.snapshot}) : super(key: key);

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(snapshot.get('title')),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 19,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white, //cor da tab atual
            tabs: [
              Tab(icon: Icon(Icons.grid_on)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          //recebendo todos os documentos da categoria itens
          future: FirebaseFirestore.instance
              .collection('products')
              .doc(snapshot.id)
              .collection('itens')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              //se não tem dados
              return const Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GridView.builder(
                  padding: const EdgeInsets.all(4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    ProductData product =
                        ProductData.fromDocument(snapshot.data!.docs[index]);
                    product.category = this.snapshot.id;
                    return ProductTile(
                      type: 'grid',
                      product: product,
                    );
                  },
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(4),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    ProductData data =
                        ProductData.fromDocument(snapshot.data!.docs[index]);
                    data.category = this.snapshot.id;
                    return ProductTile(
                      type: 'list',
                      product: data,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
