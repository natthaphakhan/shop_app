import 'package:shop_app/model/cart_model.dart';

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