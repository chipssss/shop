// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shop/Utils.dart';
import 'package:shop/data/mock_data.dart';

import 'order.dart';
import "product.dart";
import 'products_repository.dart';

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7;

class AppStateModel extends Model {


  // All the available products.
  List<Product> _availableProducts;
  List<Order> _userOrderList = [];
  List<Order> get userOrderList => _userOrderList;

  // The currently selected category of products.
  Category _selectedCategory = categoryAll;

  // The IDs and quantities of products currently in the cart.
  final Map<int, int> _productsInCart = <int, int>{};

  String _searchKeyWork;

  Map<int, int> get productsInCart => Map<int, int>.from(_productsInCart);

  // Total number of items in the cart.
  int get totalCartQuantity => _productsInCart.values.fold(0, (v, e) => v + e);

  Category get selectedCategory => _selectedCategory;

  // Totaled prices of the items in the cart.
  double get subtotalCost {
    return _productsInCart.keys
        .map((id) => _availableProducts[id].price * _productsInCart[id])
        .fold(0.0, (sum, e) => sum + e);
  }

  // Total shipping cost for the items in the cart.
  double get shippingCost {
    return _shippingCostPerItem *
        _productsInCart.values.fold(0.0, (sum, e) => sum + e);
  }

  // Sales tax for the items in the cart
  double get tax => subtotalCost * _salesTaxRate;

  // Total cost to order everything in the cart.
  double get totalCost => subtotalCost + shippingCost + tax;

  // 购物车是否为空
  bool get isCartEmpty => _productsInCart.isEmpty;

  // Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts(BuildContext context) {
    if (_availableProducts == null) {
      return [];
    }

    // 根据关键词模糊搜索
    if (!stringIsNullOrEmpty(_searchKeyWork)) {
      return _availableProducts.where((element) {
        String name = element.name(context);
        return name.contains(_searchKeyWork);
      }).toList();
    }

    if (_selectedCategory == categoryAll) {
      return List<Product>.from(_availableProducts);
    } else {
      return _availableProducts
          .where((p) => p.category == _selectedCategory)
          .toList();
    }
  }

  // Adds a product to the cart.
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId]++;
    }

    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId]--;
      }
    }

    notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  Product getProductById(int id) {
    return _availableProducts.firstWhere((p) => p.id == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Loads the list of available products from the repo.
  void loadProducts() {
    _availableProducts = ProductsRepository.loadProducts(categoryAll);
    notifyListeners();
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }

  // 添加搜索支持
  void search(String keyword) {
    _searchKeyWork = keyword;
    notifyListeners();
  }

  @override
  String toString() {
    return 'AppStateModel(totalCost: $totalCost)';
  }

  void settleCart() {
    // 后续如有引入账户余额计划，可在此加入数据层的判断逻辑
    // 交易成功，记录交易状态生成订单
    _userOrderList.add(Order(_productsInCart, totalCost, subtotalCost, tax, shippingCost));
    print("settleCart finish, orderList: $_userOrderList");
    clearCart();
  }

  AppStateModel() {
    // 测试数据
    if (GlobalConfig.isDebug) {
      _userOrderList.addAll(MockData.userOrderList);
    }
  }
}
