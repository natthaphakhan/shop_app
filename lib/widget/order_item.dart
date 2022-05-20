import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {
  const OrderItemWidget({Key? key, required this.orderItem}) : super(key: key);
  final OrderItem orderItem;

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              ListTile(
                title: Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),
                subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                    .format(widget.orderItem.dateTime)),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon: _expanded == false
                      ? const Icon(Icons.expand_more)
                      : const Icon(Icons.expand_less),
                ),
              ),
              _expanded == true
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 4),
                      height: min(
                          widget.orderItem.products.length * 20.0 + 10, 100),
                      child: ListView(
                        children: widget.orderItem.products
                            .map((prod) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      prod.title,
                                    ),
                                    Text(
                                      '${prod.quantity} x \$${prod.price}',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ))
                            .toList(),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
