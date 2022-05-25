import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/screen/cart_screen.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/widget/app_drawer.dart';
import 'package:shop_app/widget/badge.dart';
import 'package:shop_app/widget/product_grid.dart';

enum FilterOptions { favorites, all }

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  var _showOnlyFavorite = false;
  var _isInit = true;
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CartPage()));
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductGrid(showFavorite: _showOnlyFavorite),
      drawer: const AppDrawer(),
    );
  }
}
