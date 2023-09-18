import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/purchase_invoice.dart';

class PurchaseDetailsScreen extends StatefulWidget {
  PurchaseInvoice purchase;

  PurchaseDetailsScreen({super.key, required this.purchase});

  @override
  State<StatefulWidget> createState() => _PurchaseDetailsState();
}

class _PurchaseDetailsState extends State<PurchaseDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Purchase # ${widget.purchase.id} "),
        centerTitle: false,
      ),
      body: _purchaseDetails(),
    );
  }

  Widget _purchaseDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  _dateWidget(),
                  const SizedBox(
                    height: 60,
                  ),
                  _items(),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _getTotal(),
          ],
        ),
      ),
    );
  }

  _purchaseId() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(
            "Purchase ID: ",
            style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "${widget.purchase.id}",
            style: GoogleFonts.cairo(fontSize: 24),
          )
        ],
      ),
    );
  }

  Widget _dateWidget() {
    var seconds = int.parse(widget.purchase.date.seconds);
    var date = new DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    var formatted = formatDate(date, [d, '-', M, '-', yyyy ," at ", HH, ':', nn, ':', ss]);
    return Container(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(
              "Date of Purchase: ",
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${formatted}",
              style: GoogleFonts.cairo(
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _items() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Text(
                "Number of items: ",
                style: GoogleFonts.cairo(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "${widget.purchase.cartItemList.length}",
                style: GoogleFonts.cairo(fontSize: 18),
              ),
            ],
          ),
        ),
        for (var item in widget.purchase.cartItemList) ...{
          Padding(
            padding: EdgeInsets.only(left: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                    child: Image.network(item.product.image, scale: 15, fit: BoxFit.contain,),
                  radius: 20,
                    backgroundColor:Colors.transparent
                    ),
                Text(
                    item.product.title.length > 15
                        ? "${item.product.title.substring(0, 15)}..."
                        : "${item.product.title}",
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                    )),
                Text(" X  ${item.quantity}",
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                    )),
              ],
            ),
          )
        },
        SizedBox(
          height: 10,
        ),
        Divider(),
      ],
    );
  }

  Widget _getTotal() {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total: ",
              style:
              GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "SAR ${widget.purchase.totalAmount}",
              style: GoogleFonts.cairo(
                  fontSize: 24,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
