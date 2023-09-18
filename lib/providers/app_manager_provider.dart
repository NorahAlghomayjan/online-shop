// to hold the variables that are needed on the lifetime of the app.
import 'package:flutter/cupertino.dart';
import 'package:online_shop_app/comm/backend_api.dart';
import 'package:online_shop_app/models/cart_item.dart';
import 'package:online_shop_app/models/product.dart';
import 'package:online_shop_app/models/purchase_invoice.dart';

import '../core/constants.dart';
import '../models/cart.dart';
import '../models/user.dart';

class AppManager extends ChangeNotifier {
  List<Product> productList = [];
  User? user;
  Cart? cart;
  List<PurchaseInvoice> previousPurchaseList = [];

  void initializeProducts() {
    productList = [];

    Constants.api.getProductList().then((list) {
      productList = list;
    }).catchError((onError) {
      print("--------------- error");
      print(onError);
    });

    notifyListeners();

  }

  void addProduct(Product p, int qty) {
    // api

    Constants.api.addProductToCart(p.id, qty).then((cart) {
      this.cart = cart;
    }).catchError((err) {});

    notifyListeners();
  }

  void signInUser(String email, String pass) {
    // this.user = user;

    Constants.api.loginUserByEmail("adel@gmail.com").then((user) {
      this.user = user;

      Constants.api.getCartForUserId(user.id).then((cart) {
        this.cart = cart;
      }).catchError((err) {
        print("----- error in cart");
        print(err);
      });
      Constants.api.getPurchaseInvoiceForUser(user.id).then((purchases) {
        previousPurchaseList = purchases;
      }).catchError((err) {
        print("----- error in purchases");
        print(err);
      });
    }).catchError((err) {
      print("----- error in login");
      print(err);
    });

    notifyListeners();
  }

  void addToCart(Product p, String qty) {
    // calling addProductToCart API here??

    CartItem newItem = CartItem(product: p, quantity: qty);

    cart?.cartItemList.add(newItem);

    notifyListeners();
  }

  void removeFromCart(Product p, int qty) {
    //
  }

  void updatePurchaseList() {
    // calling processPurchase API
    // cart = invoice.$1;
    // previousPurchaseList = invoice.$2;

    notifyListeners();
  }
}
