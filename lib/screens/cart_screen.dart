import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_shop_app/core/constants.dart';
import 'package:online_shop_app/models/cart_item.dart';

class CartScreen extends StatefulWidget {
  CartScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _processingPurchase = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: (Constants.appMan.cart == null ||
              Constants.appMan.cart!.cartItemList.isEmpty)
          ? const Text("The Cart is Empty")
          : _getCartWidget(),
    );
  }

  _getCartWidget() {
    return ListView(
      children: [
        for (var item in Constants.appMan.cart!.cartItemList) ...[
          ListTile(
            tileColor: Colors.grey[50],
            leading: Image.network(item.product.image, width: 50),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteProductFromCart(item);
              },
            ),
            title: Text(
              item.product.title,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              children: _getItemDetails(item),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
        _getTotal(),
        const SizedBox(
          height: 20,
        ),
        if (_processingPurchase) _getWaitingWidget(),
        if (!_processingPurchase) _purchaseButton()
      ],
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

  void _deleteProductFromCart(CartItem item) {
    setState(() {
      _processingPurchase = true;
    });

    Constants.api
        .removeItemFromCart(item.product.id, int.parse(item.quantity))
        .then((cart) {
      Constants.appMan.cart = cart;
      setState(() {
        _processingPurchase = false;
      });
    });
  }

  List<Widget> _getItemDetails(CartItem item) {
    return [
      Text(
        item.product.description,
        maxLines: 3,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.cairo(),
      ),
      const SizedBox(
        height: 10,
      ),
      ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.grey[200],
          child: _nestedWidget(item),
        ),
      )
    ];
  }

  _nestedWidget(CartItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Quantity ${item.quantity}',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        Text('SAR ${double.parse(item.quantity) * item.product.price}',
            style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.green)),
      ],
    );
  }

  _getTotal() {
    return ListTile(
      tileColor: Colors.grey[200],
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total',
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold, fontSize: 22)),
            // :TODO
            Text('SAR ${Constants.appMan.cart!.total.toStringAsFixed(2)}',
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.green)),
          ],
        ),
      ),
    );
  }

  _purchaseButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        child: ElevatedButton(
          onPressed: _processPurchase,
          child: const Text("Purchase"),
        ),
      ),
    );
  }

  void _processPurchase() {
    setState(() {
      _processingPurchase = true;
    });

    try {
      Constants.api
          .processPurchase(Constants.appMan.cart!.id, Constants.appMan.user!.id)
          .then((invoice) {
        Constants.appMan.cart = invoice.$1;
        Constants.appMan.previousPurchaseList = invoice.$2;

        setState(() {
          _processingPurchase = false;
        });

        //TODO: show a pop-up msg to display purchase.
        //TODO: was done successfully.
      }).catchError((err) {
        setState(() {
          _processingPurchase = false;
        });
        //TODO: show a pop-up msg to error.
        print("Couldn't process purchase");
      });
    } catch (e, s) {
      print(s);
    }
  }
}
