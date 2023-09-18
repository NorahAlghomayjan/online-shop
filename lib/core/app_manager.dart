// to hold the variables that are needed on the lifetime of the app.
import 'package:online_shop_app/comm/backend_api.dart';
import 'package:online_shop_app/models/product.dart';
import 'package:online_shop_app/models/purchase_invoice.dart';

import '../models/cart.dart';
import '../models/user.dart';


class AppManager {
  List<Product> productList=[];
  User? user;
  Cart? cart;
  List<PurchaseInvoice> previousPurchaseList=[];
}