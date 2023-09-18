import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_shop_app/screens/cart_screen.dart';
import 'package:online_shop_app/screens/login_screen.dart';
import 'package:online_shop_app/screens/product_details_screen.dart';
import 'package:online_shop_app/screens/purchase_screen.dart';

import '../core/constants.dart';
import '../models/product.dart';
import '../comm/backend_api.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({super.key});

  @override
  State<MarketPlaceScreen> createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  var _loadingProducts = false;

  @override
  void initState() {
    super.initState();
    Constants.api.loginUserByEmail("adel@gmail.com").then((user) {
      Constants.appMan.user = user;

      Constants.api.getCartForUserId(user.id).then((cart){
        Constants.appMan.cart = cart;
        print("----- cart");
        print(cart.id);
      } ).catchError((err){
        print("----- error in cart");
        print(err);
      });
      Constants.api.getPurchaseInvoiceForUser(user.id).then((purchases){
        Constants.appMan.previousPurchaseList = purchases;
        print("----- purchases");
        print(purchases.length);
      } ).catchError((err){
        print("----- error in purchases");
        print(err);
      });

    });

    Constants.api.getProductList().then((list) {
      Constants.appMan.productList = list;

      setState(() {
        _loadingProducts = false;
      });
    }).catchError((onError) {
      print("--------------- error");
      print(onError);
    });
  }

  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Online Shop"),
          centerTitle: false,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: (Constants.appMan.user == null)
                  ? CircleAvatar(child: Icon(Icons.person))
                  : CircleAvatar(child: Icon(Icons.person)),
            ),
          ],
        ),
        drawer: (Constants.appMan.user == null)
            ? _getNotLoggedInDrawer()
            : _getLoggedInDrawer(),
        body: _getProductList(),
      ),
    );
  }

  Widget _getWaitingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _getProductList() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: Constants.appMan.productList.map((p) {
        return _getProductTile(p);
      }).toList(),
    );
  }

  Widget _getProductTile(Product product) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(
              product: product,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              product.image,
              height: 100,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _getProductRatingWidget(product),
          ],
        ),
      ),
    );
  }

  Widget _getProductRatingWidget(Product product) {
    return RatingBar.builder(
      initialRating: product.rating.rate,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemSize: 20,
      updateOnDrag: false,
      itemBuilder: (context, _) {
        return const Icon(
          Icons.star,
          color: Colors.amber,
        );
      },
      onRatingUpdate: (double value) {},
    );
  }

  Widget _getNotLoggedInDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/splash-screen.png',
                  height: 100,
                ),
              ),
              Text(
                "Actions",
                style: GoogleFonts.cairo(
                    fontSize: 22, fontWeight: FontWeight.bold),
              )
            ],
          )),
          ListTile(
            title: const Text("Login"),
            trailing: const Icon(Icons.login),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          )
        ],
      ),
    );
  }

  Widget _getLoggedInDrawer() {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/splash-screen.png',
                  height: 100,
                ),
              ),
              Text(
                "Actions",
                style: GoogleFonts.cairo(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ..._getTiles(),
      ]),
    );
  }

  List<Widget> _getTiles() {
    return [
      ListTile(
          title: Text("My Cart"),
          trailing: Icon(Icons.shopping_cart),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => CartScreen()));
          }),
      ListTile(
        title: Text("My Purchases"),
        trailing: Icon(Icons.shopping_bag),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => PurchaseScreen()));
        },
      ),
      ListTile(
        title: Text("Logout"),
        trailing: Icon(Icons.logout),
        onTap: () {
          Constants.appMan.user = null;
          Constants.appMan.cart = null;
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));
        },
      ),
    ];
  }
}
