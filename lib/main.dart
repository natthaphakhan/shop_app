import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/screen/edit_product.dart';
import 'package:shop_app/screen/order_screen.dart';
import 'package:shop_app/screen/product_screen.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/screen/user_product_screen.dart';

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
          create: (contex) => Products(),
        ),
        ChangeNotifierProvider(
          create: (contex) => Cart(),
        ),
        ChangeNotifierProvider(create: (context) => Order()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
       
        title: 'SHOP APP',
        initialRoute: '/',
        routes: {
          '/': (context) => const ProductsPage(),
          '/orders': (context) => const OrderScreen(),
          '/edit-product': (context) => const EditProduct(),
          '/user-product': (context) => const UserProductScreen(),
        },
      ),
    );
  }
}
