import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/screen/auth_screen.dart';
import 'package:shop_app/screen/cart_screen.dart';
import 'package:shop_app/screen/edit_product.dart';
import 'package:shop_app/screen/order_screen.dart';
import 'package:shop_app/screen/product_screen.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screen/user_product_screen.dart';
import 'package:shop_app/widget/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return AuthProvider();
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, Products>(
          create: (BuildContext context) => Products('', [], ''),
          update: (BuildContext context, auth, previous) => Products(
            auth.token == null ? '' : auth.token!,
            previous!.items == [] ? [] : previous.items,
            auth.userId == null ? '' : auth.userId!,
          ),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return Cart();
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, Order>(
          create: (BuildContext context) => Order('', [], ''),
          update: (BuildContext context, auth, previous) => Order(
            auth.token == null ? '' : auth.token!,
            previous!.orders == [] ? [] : previous.orders,
            auth.userId == null ? '' : auth.userId!,
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (BuildContext context, authProvider, Widget? child) =>
            MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SHOP APP',
          home: authProvider.isAuth
              ? const ProductsScreen()
              : FutureBuilder(
                  future: authProvider.tryAutoLogin(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? const Loading()
                              : const AuthScreen(),
                ),
          routes: {
            '/products': (context) => const ProductsScreen(),
            '/cart': (context) => const CartScreen(),
            '/orders': (context) => const OrderScreen(),
            '/edit-product': (context) => const EditProductScreen(),
            '/user-product': (context) => const UserProductScreen(),
            '/auth': (context) => const AuthScreen(),
          },
        ),
      ),
    );
  }
}
