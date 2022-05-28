import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/widget/app_drawer.dart';
import 'package:shop_app/widget/user_product_item.dart';

class UserProductScreen extends StatefulWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/edit-product', arguments: '');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: (() => _refresh(context)),
                    child: Consumer<Products>(
                      builder:
                          (BuildContext context, productsData, Widget? child) =>
                              Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Card(
                            child: UserProductItem(
                                id: productsData.items[i].id,
                                title: productsData.items[i].title,
                                imageUrl: productsData.items[i].imageUrl),
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
