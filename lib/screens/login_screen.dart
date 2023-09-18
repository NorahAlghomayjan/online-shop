import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_shop_app/comm/exceptions/communication_exception.dart';
import 'package:online_shop_app/comm/exceptions/user_email_not_found_exception.dart';
import 'package:online_shop_app/core/constants.dart';
import 'package:online_shop_app/screens/market_place_screen.dart';

import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  var _processingLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset('assets/log-in.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Sign In",
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 20,
              ),
              _emailInput(),
              const SizedBox(
                height: 20,
              ),
              _passInput(),
              const SizedBox(
                height: 20,
              ),
              (!_processingLogin)? _signIn() : _getWaitingWidget()

            ],
          ),
        ),
      ),
    );
  }

  Widget _emailInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
            hintText: "Enter Email",
            labelText: 'Email'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter email address";
          } else if (!value.contains("@")) {
            return 'Please Enter a valid Email';
          }
          return null;
        },
      ),
    );
  }

  Widget _passInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        controller: _passController,
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.password_outlined),
            hintText: "Enter Password",
            labelText: 'Password'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter password ";
          }
          return null;
        },
      ),
    );
  }

  Widget _signIn(){
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _loginTapped,
        child: const Text('Sign In'),
      ),
    ),);
  }


  void _loginTapped() {
    if(_formKey.currentState!.validate()){
      setState(() {
        _processingLogin = true;
      });
    }
    var email = _emailController.value.text;
    var pass = _passController.value.text;

      // 1ST API CALL
    Constants.api.loginUserByEmail(email).then((user){
      if(user.password == pass){
        _successPass(user);
      } else{
        setState(() {
          _processingLogin = false;
        });

        _showErrPopUp("Password is not correct");
      }
    }).catchError((err){
      setState(() {
        _processingLogin = false;
      });
      if(err is UserEmailNotFoundException){
        _showErrPopUp("Email Not Found");
      } else if ( err is CommunicationException){
        _showErrPopUp("Communication Error");
      }

    });
  }

  void _successPass(User user){

    Constants.appMan.user = user;

    // 2ND API CALL
    Constants.api.getCartForUserId(user.id).then((cart){
      Constants.appMan.cart = cart;
    } ).catchError((err){});

    // 3RD API CALL
    Constants.api.getPurchaseInvoiceForUser(user.id).then((purchases) {
      Constants.appMan.previousPurchaseList =purchases;
    }).catchError((err){});

    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
      return MarketPlaceScreen();
    }));
  }

  void _showErrPopUp(String msg) {
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: Text("Error"),
        content: Text(msg),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("ok"))
        ],
      );
    });
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


}
