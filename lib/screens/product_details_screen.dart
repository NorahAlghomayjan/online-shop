import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_shop_app/core/constants.dart';
import 'package:online_shop_app/models/rating.dart';
import 'package:online_shop_app/screens/login_screen.dart';

import '../models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  Product product;

  ProductDetailsScreen({
    required this.product,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _qty = 1;
  var _addingToCart = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Screen"),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: _productWidget(),
    );
  }

  Widget _waitingWidget(){
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _productWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _getTitle(),
            _getRating(),
            _getImg(),
            _getPrice(),
            _geDesc(),
            _getQuantityButton(),
            _getAddToCart(),
          ],
        ),
      ),
    );
  }

  Widget _getRating() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:CrossAxisAlignment.center ,
        children: [
          Expanded(child: Container()),
          _getProductRatingWidget(widget.product.rating),
          const SizedBox(width: 20),
          Text(
            'Rated by ${widget.product.rating.count} customer',
            style: GoogleFonts.cairo(fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _getProductRatingWidget(Rating rating) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RatingBar.builder(
        initialRating: rating.rate,
        minRating: 1,
        direction: Axis.horizontal,
        wrapAlignment:WrapAlignment.spaceBetween,
        allowHalfRating: false,
        itemCount: 5,
        itemSize: 15,
        updateOnDrag: false,
        itemBuilder: (context, _) {
          return const Icon(
            Icons.star,
            color: Colors.amber,
          );
        },
        onRatingUpdate: (value) {},
      ),
    );
  }

  Widget _getTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        widget.product.title,
        textAlign: TextAlign.center,
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _getImg() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Image.network(
            widget.product.image,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.7,
            fit: BoxFit.fill
        ),
      ),
    );
  }

  Widget _getPrice() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child:Text(
          'SAR ${widget.product.price.toStringAsFixed(2)}',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.green
          ),
        )
      ),
    );
  }

  Widget _geDesc() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          children: [
            Row(
              children: [
                Text(
                  'In Stock',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Text(
              widget.product.description,
              style: GoogleFonts.cairo(),)
          ],
      ),
    );
  }

  Widget _getQuantityButton() {
    const qtys = [1, 2, 3, 4, 5];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            'Quantity',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20),
          DropdownButton(
              value: _qty,
              items: qtys.map((qtyNum) {
                return (DropdownMenuItem(value: qtyNum, child: Text('$qtyNum')));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _qty = value!;
                });
              })
        ],
      ),
    );
  }

  Widget _getAddToCart() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () =>_handlePress(),
          style: ElevatedButton.styleFrom(
              elevation: 10,
              backgroundColor: Colors.redAccent,
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
          child: Text(
            (Constants.appMan.user != null) ? 'Add to Cart':'Login to Add to Cart',
              style: GoogleFonts.cairo(color: Colors.white,
              fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _handlePress(){
    if(Constants.appMan.user == null){
      Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
      return;
    }
    setState(() {
      _addingToCart = true;
    });

    Constants.api.addProductToCart(widget.product.id, _qty)
        .then((cart) {
      setState(() {
        _addingToCart = false;
        _showAddedToCartMsg(widget.product.title,_qty, true);
      });
      Constants.appMan.cart = cart;
    }).catchError((err){
      setState(() {
        _addingToCart = false;
      });


      _showAddedToCartMsg(widget.product.title,_qty, false);
    });
  }

  void _showAddedToCartMsg(String title, int qty, bool status) {
    var msg = (status)? "Successfully added $qty of product $title" :"FAILED!! to adde $qty of product $title";
    var msgTitle = (status)? "Product Added to Cart" :"ERROR!!";
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title:  Text(msgTitle),
        content: Text(msg),
        actions: [
          TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("ok"))
        ],
      );
    });
  }
}
