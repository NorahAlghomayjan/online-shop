import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:online_shop_app/comm/exceptions/add_to_cart_exception.dart';
import 'package:online_shop_app/comm/exceptions/cart_not_found_exception.dart';
import 'package:online_shop_app/comm/exceptions/communication_exception.dart';
import 'package:online_shop_app/core/constants.dart';
import 'package:online_shop_app/models/api_response/api_response_get_purchases.dart';
import 'package:online_shop_app/models/api_response/api_response_with_product_list.dart';
import 'package:online_shop_app/models/api_response/api_response_with_user_list.dart';
import 'package:online_shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:online_shop_app/models/purchase_invoice.dart';

import '../models/cart.dart';
import '../models/api_response/api_response_with_cart.dart';
import '../models/user.dart';
import 'exceptions/remove_from_cart_exception.dart';
import 'exceptions/user_email_not_found_exception.dart';

class BackendApi {
  static Uri uri = Uri.parse(
      'https://us-central1-gifty-project-f09a4.cloudfunctions.net/gifty5');
  late Cart cart;
  late User userId;

  Future<List<Product>> getProductList() async {
    var res = await _makeApiCall("GetProducts");
    var source = utf8.decode(res.bodyBytes);
    var apiRes = ApiResponseWithProductList.fromJson(
      jsonDecode(source),
    );

    if (apiRes.success) {
      return apiRes.data;
    }
    return [];
  }

  Future<User> loginUserByEmail(String email) async {
    final res = await _makeApiCall('GetAllUsersByEmail/${email}');
    var source = utf8.decode(res.bodyBytes);
    var apiRes = ApiResponseWithUserList.fromJson(
      jsonDecode(source),
    );

    if (apiRes.success && apiRes.data.isNotEmpty) {
      return apiRes.data[0];
    }
    throw UserEmailNotFoundException(
      message: "User with email not found",
      command: "GetAllUsersByEmail/${email}",
      email: email,
    );
  }

  Future<Cart> getCartForUserId(String userId) async {
    final res = await _makeApiCall('GetCartForUserId/${userId}');
    var source = utf8.decode(res.bodyBytes);
    var apiRes = ApiResponseWithCart.fromJson(
      jsonDecode(source),
    );

    if (apiRes.success) {
      print(' ------- Received cart with ${apiRes.data.cartItemList.length} items');
      return apiRes.data;
    }
    throw CartNotFoundException(
      message: "cart for user ${userId}  not found",
      command: "GetCartForUserId/${userId}",
      userId: userId,
    );
  }

  Future<Cart> addProductToCart(String productId, int quantity) async {
    late http.Response res;
    for (var i = 0; i < quantity; i++) {
      res = await _makeApiCall(
          'AddProductToCart/$productId/${Constants.appMan.cart!.id}');
    }
    var source = utf8.decode(res.bodyBytes);
    var apiRes = ApiResponseWithCart.fromJson(
      jsonDecode(source),
    );

    if (apiRes.success) {
      return apiRes.data;
    }
    throw AddToCartException(
      message:
          "product ${productId} coudn't be added to cart ${Constants.appMan.cart!.id}",
      command: "AddProductToCart/${userId}",
      cartId: Constants.appMan.cart!.id,
      productId: productId,
    );
  }

  Future<Cart> removeItemFromCart(String productId, int quantity) async {
    late http.Response res;
    for (var i = 0; i < quantity; i++) {
      res = await _makeApiCall(
          'RemoveProductFromCart/${productId}/${Constants.appMan.cart!.id}');
    }
    var source = utf8.decode(res.bodyBytes);
    var apiRes = ApiResponseWithCart.fromJson(
      jsonDecode(source),
    );

    if (apiRes.success) {
      return apiRes.data;
    }
    throw RemoveFromCartException(
      message:
      "product ${productId} coudn't be removed from cart ${Constants.appMan.cart!.id}",
      command: "RemoveProductFromCart/$productId/${Constants.appMan.cart!.id}",
      cartId: Constants.appMan.cart!.id,
      productId: productId,
    );
  }

  Future<List<PurchaseInvoice>> getPurchaseInvoiceForUser(String userId) async {
    final res = await _makeApiCall('GetPurchases/$userId');
    var source = utf8.decode(res.bodyBytes);
    var apiRes = ApiResponseGetPurchases.fromJson(
      jsonDecode(source),
    );
    if(apiRes.success){
      print('Received ${apiRes.data.length} invoices');
      return apiRes.data;
    }
    return [];
  }

  Future<(Cart cart , List<PurchaseInvoice> invoices )> processPurchase(String cartId, String userId) async {
    await _makeApiCall('ProcessPurchase/$cartId');
    var cart = await getCartForUserId(userId);
    var invoices = await getPurchaseInvoiceForUser(userId);
    return (cart,invoices);
  }


   Future<http.Response> _makeApiCall(String command) async {
    Map cmd = {'command': command};
    var body = json.encode(cmd);
    final res = await http.post(
      uri,
      headers: {'Content-type': 'application/json'},
      body: body,
    );

    if (res.statusCode != 200) {
      throw CommunicationException(
          command: command.toString(),
          message: 'Communication Error with the backend');
    }
    return res;
  }
}
