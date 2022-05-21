import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order_provider.dart';
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
        theme: ThemeData(
          textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme),
          primarySwatch: Colors.green,
        ),
        title: 'SHOP APP',
        initialRoute: '/',
        routes: {
          '/': (context) => const ProductsPage(),
          '/orders': (context) => const OrderScreen(),
          '/user-product': (context) => const UserProductScreen(),
        },
      ),
    );
  }
}
