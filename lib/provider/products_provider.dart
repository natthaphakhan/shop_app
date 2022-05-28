import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/model/http_exception_model.dart';
import 'package:shop_app/provider/product_provider.dart';

class Products with ChangeNotifier {
  String authToken;
  String userId;

  Products(this.authToken, this._items, this.userId);

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) => items.firstWhere((prod) => prod.id == id);

  Future<void> fetchProducts([bool filterUser = false]) async {
    final filterUserPath =
        filterUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';

    var url = Uri.parse(
        'https://shop-app-5b362-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken$filterUserPath');

    try {
      final response = await http.get(url);

      if (jsonDecode(response.body) == null) {
        return;
      }
      final extractedResponse =
          jsonDecode(response.body) as Map<String, dynamic>;

      List<Product> loadedData = [];

      url = Uri.parse(
          'https://shop-app-5b362-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');

      final respondeFav = await http.get(url);
      final favData = jsonDecode(respondeFav.body);

      extractedResponse.forEach((prodId, prodData) {
        loadedData.add(Product(
          id: prodId.toString(),
          title: prodData["title"].toString(),
          description: prodData["description"].toString(),
          price: prodData["price"].toDouble(),
          imageUrl: prodData["imageUrl"].toString(),
          isFavorite: favData == null ? false : favData[prodId] ?? false,
        ));
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product prod) async {
    final url = Uri.parse(
        "https://shop-app-5b362-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken");

    try {
      await http.post(
        url,
        body: json.encode({
          "title": prod.title,
          "price": prod.price,
          "description": prod.description,
          "imageUrl": prod.imageUrl,
          "creatorId": userId,
        }),
      );
      final newProd = Product(
          id: DateTime.now().toString(),
          title: prod.title,
          description: prod.description,
          price: prod.price,
          imageUrl: prod.imageUrl);
      _items.add(newProd);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProd) async {
    final url = Uri.parse(
        "https://shop-app-5b362-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken");
    await http.patch(url,
        body: jsonEncode({
          'title': newProd.title,
          'price': newProd.price,
          'description': newProd.description,
          'imageUrl': newProd.imageUrl,
        }));
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProd;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://shop-app-5b362-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json");
    final currentIndex = _items.indexWhere((prod) => prod.id == id);
    Product? currentProduct = _items[currentIndex];
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(currentIndex, currentProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    currentProduct = null;
  }
}
