import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/widget/app_drawer.dart';
import 'package:shop_app/widget/order_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (context, i) =>
              OrderItemWidget(orderItem: orderData.orders[i]),
        ));
  }
}
