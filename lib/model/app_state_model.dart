// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shop/Utils.dart';
import 'package:shop/data/mock_data.dart';
import 'package:shop/model/evalutaion.dart';

import 'order.dart';
import "product.dart";
import 'products_repository.dart';

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7;

class AppStateModel extends Model {


  // 全部商品
  List<Product> _availableProducts;
  // 用户订单列表
  List<Order> _userOrderList = [];
  List<Order> get userOrderList => _userOrderList;

  // The currently selected category of products.
  Category _selectedCategory = categoryAll;

  // 购物车商品，key: productId, value: 商品数量
  final Map<int, int> _productsInCart = <int, int>{};

  String _searchKeyWork;

  Map<int, int> get productsInCart => Map<int, int>.from(_productsInCart);

  // 购物车总数量
  int get totalCartQuantity => _productsInCart.values.fold(0, (v, e) => v + e);

  Category get selectedCategory => _selectedCategory;

  // 总金额
  double get subtotalCost {
    return _productsInCart.keys
        .map((id) => _availableProducts[id].price * _productsInCart[id])
        .fold(0.0, (sum, e) => sum + e);
  }

  // 运费，mock
  double get shippingCost {
    return _shippingCostPerItem *
        _productsInCart.values.fold(0.0, (sum, e) => sum + e);
  }

  // 税率，mock
  double get tax => subtotalCost * _salesTaxRate;

  // 总额 = 商品价钱+运费+税率
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

  // 添加商品到购物车
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      // 不在购物车当中，添加hash表中，数量置为1
      _productsInCart[productId] = 1;
    } else {
      // 在购物车当中，数量自增
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

  static AppStateModel of(BuildContext context) =>
      ScopedModel.of<AppStateModel>(context);

  void addEvaluation(Order order, Product product, Evaluation evaluation) {
    // 评价信息绑定id
    evaluation.productId = product.id;
    // 添加到订单评价信息中
    order.productEvaluationMap[product.id] = evaluation;
    // 添加到商品评价信息中
    product.addEvaluation(evaluation);
    // 如接入后台，可在此发起后台io请求，更新远端数据库

    // 通过观察者模式通知ui刷新
    notifyListeners();
  }
}
