import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_shop_app/core/constants.dart';
import 'package:online_shop_app/models/cart_item.dart';
import 'package:online_shop_app/models/purchase_invoice.dart';
import 'package:online_shop_app/screens/purchase_details_screen.dart';

import '../models/date.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key });

  @override
  State<StatefulWidget> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Purchases"),
      ),
      body: (Constants.appMan.previousPurchaseList.isEmpty)
          ? const Text("The Purchases is Empty")
          : _getPurchaseWidget(),
    );
  }

  _getPurchaseWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: [
          for (var purchase in Constants.appMan.previousPurchaseList) ...[
            Container(
              height: 90,
              child: ListTile(
                  tileColor: Colors.grey[200],
                  title: Text(
                    "${purchase.id.substring(0, 18)} ...",
                    style: GoogleFonts.cairo(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  subtitle: _getIPurchaseDetails(purchase.date),
                  trailing: Text(
                      "SAR ${purchase.totalAmount.toStringAsFixed(2)}",
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green)),
                  onTap: () => _handleTap(purchase)),
            ),
            SizedBox(
              height: 10,
            )
          ],
          // _getTotal(),
        ],
      ),
    );
  }

  Widget _getIPurchaseDetails(Date purchaseDate) {
    var seconds = int.parse(purchaseDate.seconds);
    var date = new DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Orderd on :",
          style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
        Text("$date", style: GoogleFonts.cairo()),
      ],
    );
  }

  _handleTap(PurchaseInvoice purchase) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PurchaseDetailsScreen( purchase: purchase,),
      ),
    );
  }
}
