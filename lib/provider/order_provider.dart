import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  const OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Order with ChangeNotifier {
  String authToken;

  Order(this.authToken, this._orders);

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrder() async {
    final url = Uri.parse(
        "https://shop-app-5b362-default-rtdb.asia-southeast1.firebasedatabase.app/order.json?auth=$authToken");
    final response = await http.get(url);
    if (jsonDecode(response.body) == null) {
      return;
    }
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

    List<OrderItem> loadedOrder = [];
    extractedData.forEach((orderId, orderData) {
      loadedOrder.add(OrderItem(
        id: orderId,
        amount: orderData['amount'].toDouble(),
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((i) => CartItem(
                  id: i['id'],
                  title: i['title'],
                  quantity: i['quantity'],
                  price: i['price'].toDouble(),
                  imageUrl: i['imageUrl'].toString(),
                ))
            .toList(),
      ));
    });

    _orders = loadedOrder.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        "https://shop-app-5b362-default-rtdb.asia-southeast1.firebasedatabase.app/order.json?auth=$authToken");
    final timeStamp = DateTime.now();
    await http.post(url,
        body: jsonEncode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cartItem) => {
                    'id': cartItem.id,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: total,
            products: cartProducts,
            dateTime: timeStamp));
    notifyListeners();
  }
}
