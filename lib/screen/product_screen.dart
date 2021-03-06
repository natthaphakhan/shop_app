import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/widget/app_drawer.dart';
import 'package:shop_app/widget/badge.dart';
import 'package:shop_app/widget/product_grid.dart';

enum FilterOptions { favorites, all }

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  var _showOnlyFavorite = false;
  Future? fetchProduct;

  Future obtainFuture() async {
    return await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  @override
  void initState() {
    fetchProduct = obtainFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SHOP'),
        actions: [
          PopupMenuButton(
            onSelected: ((FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  _showOnlyFavorite = true;
                } else {
                  _showOnlyFavorite = false;
                }
              });
            }),
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Only favorite'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show all'),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
                value: cartData.itemCount.toString(),
                color: Colors.redAccent,
                child: ch ?? Container()),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/cart');
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: fetchProduct,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              return ProductGrid(showFavorite: _showOnlyFavorite);
            }
          }),
      drawer: const AppDrawer(),
    );
  }
}
