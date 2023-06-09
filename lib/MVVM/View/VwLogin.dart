import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ViewModel/Vm_login.dart';
import 'Vw_NumberLogin.dart';
import 'Vw_OTP.dart';

class VwLogin extends StatefulWidget {
  @override
  State<VwLogin> createState() => _VwLoginState();
}

class _VwLoginState extends State<VwLogin> {
  @override
  final Vm_login l_VmLogin = Get.put(Vm_login());

  @override
  void initState() {
    // TODO: implement initState
    l_VmLogin.FncPermissions();
    super.initState();
  }

//-------------------------------

  Future<void> logout() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController passswordController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    Widget _WidgetportraitMode(double PrHeight, PrWidth) {
      return Scaffold(
        body: Form(
          key: _formKey,
          child: Container(
            height: PrHeight,
            width: PrWidth,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFFFFFF),
                  Color(0xFFFFFFFF),
                  Color(0xFFFFFFFF),
                ],
                stops: [0.1, 0.5, 0.7, 0.9],
              ),
            ),
            //color: Colors.black,
            padding: const EdgeInsets.all(16.0),
            // we use child container property and used most important property column that accepts multiple widgets

            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                        top: PrHeight * 0.22,
                      ),
                      child: Center(
                          child: Text(
                        "Sign In",
                        style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                                fontSize: 22,
                                color: Get.isDarkMode ? Colors.white : Colors.black,
                                //fontWeight: FontWeight.w600,
                                letterSpacing: .5)),
                      ))),
                  SizedBox(
                    width: 220,
                    height: 170,
                    child: Lottie.asset('assets/signup.json', fit: BoxFit.cover, repeat: true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: PrHeight * 0.01),
                    child: Center(
                      child: SizedBox(
                        width: 400,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // <-- Radius
                            ),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            // Call the login function here
                            bool isLoginSuccessful = await l_VmLogin.Fnc_GoogleLogin();
                            l_VmLogin.FncUploadContacts(l_VmLogin.Pr_contactList);

                            if (isLoginSuccessful) {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              bool isDialogShown = prefs.getBool('isDialogShown') ?? false;

                              if (!isDialogShown) {
                                // Show dialog if not shown before
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Lottie.asset('assets/reg.json', fit: BoxFit.cover, repeat: false),
                                    );
                                  },
                                ).then((value) {
                                  // Set isDialogShown to true when dialog is dismissed
                                  prefs.setBool('isDialogShown', true);
                                });
                              } else {
                                // Show Snackbar if dialog is already shown
                                Get.snackbar(
                                  "Login Successfully",
                                  "",
                                  backgroundColor: Colors.grey[50],
                                  icon: Icon(Icons.check_circle, color: Colors.green),
                                  duration: Duration(seconds: 3),
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.all(16),
                                  borderRadius: 10,
                                  borderWidth: 1,
                                  borderColor: Colors.white,
                                  messageText: Text(
                                    "Welcome back",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }
                            }
                            else{
                              Get.snackbar(
                                "",
                                "Login Failed",
                                backgroundColor: Colors.red,
                                icon: Icon(Icons.error_outline, color: Colors.white),
                                duration: Duration(seconds: 3),
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.all(16),
                                borderRadius: 10,
                                borderWidth: 1,
                                borderColor: Colors.white,
                                messageText: Text(
                                  "Please try again",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                          },


                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google.png',
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10), // Add some space between the icon and the text
                              Expanded(
                                child: Text(
                                  "Sign in with Google",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ubuntu(
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        ,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: PrHeight * 0.01),
                    child: Center(
                      child: SizedBox(
                        width: 400,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // <-- Radius
                            ),
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                          onPressed: (){
                            Get.to(() => VwPhoneNumber());
                            //Get.to(() => VwOTP());

                          },


                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/phone.png',
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10), // Add some space between the icon and the text
                              Expanded(
                                child: Text(
                                  "Sign in with Number",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ubuntu(
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        ,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        //when tap anywhere on screen keyboard dismiss
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              //Get device's screen height and width.
              double height = constraints.maxHeight;
              double width = constraints.maxWidth;

              if (width >= 300 && width < 500) {
                return _WidgetportraitMode(height, width);
              } else {
                return _WidgetportraitMode(height, width);
              }
            },
          );
        },
      ),
    );
  }
}
