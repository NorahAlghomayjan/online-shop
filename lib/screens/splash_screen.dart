import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_shop_app/core/constants.dart';
import 'package:online_shop_app/screens/market_place_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset("assets/splash-screen.png"),
              ),
            ),
            Text(
              "Online Shopping App",
              style:
                  GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            _getWaitingWidget(),
            Text('Loading Data...',
            style: GoogleFonts.cairo(),)
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Constants.api.getProductList().then((list) {
      Constants.appMan.productList = list;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return MarketPlaceScreen();
      }));
    });
  }

  _getWaitingWidget() {
    return const Center(
      child: Column(
        children: [
          SizedBox(height: 20,),
          CircularProgressIndicator(),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}
