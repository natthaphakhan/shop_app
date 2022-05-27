import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/model/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void setFav(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token) async {
    final oldFav = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
        "https://shop-app-5b362-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$token");

    try {
      final response =
          await http.patch(url, body: jsonEncode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        setFav(oldFav);
      }
    } catch (error) {
      setFav(oldFav);
    }
  }
}

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  var isFavoriteOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) => items.firstWhere((prod) => prod.id == id);

  String authToken;

  Products(this.authToken,this._items);

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        "https://shop-app-5b362-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken");

    try {
      final response = await http.get(url);
      if (jsonDecode(response.body) == null) {
        return;
      }
      final extractedResponse =
          jsonDecode(response.body) as Map<String, dynamic>;

      List<Product> loadedData = [];

      extractedResponse.forEach((prodId, prodData) {
        loadedData.add(Product(
          id: prodId.toString(),
          title: prodData["title"].toString(),
          description: prodData["description"].toString(),
          price: prodData["price"].toDouble(),
          imageUrl: prodData["imageUrl"].toString(),
          isFavorite: prodData["isFavorite"],
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
          "isFavorite": prod.isFavorite,
          "imageUrl": prod.imageUrl,
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
