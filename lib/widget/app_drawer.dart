import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('MENU'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/products');
            },
          ),
          ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Orders'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/orders');
              }),
          ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Manage Products'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/user-product');
              }),
          ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).errorColor,
              ),
              title: Text(
                'Logout',
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
                Provider.of<AuthProvider>(context, listen: false).logout();
              }),
        ],
      ),
    );
  }
}
