import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:shaheenautos/MVVM/ViewModel/Vm_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ViewModel/VmPhoneNumber.dart';
import 'VwLogin.dart';

class VwOTP extends StatefulWidget {
  const VwOTP({Key? key}) : super(key: key);

  @override
  State<VwOTP> createState() => _VwOTPState();
}

class _VwOTPState extends State<VwOTP> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VmPhoneNumber l_Vmpass = Get.put(VmPhoneNumber());
  final Vm_login l_Vmlogin = Get.put(Vm_login());

  var code = "";

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    Widget _WidgetportraitMode(double PrHeight, PrWidth) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.to(() => VwLogin());
            },
          ),
        ),
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
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: PrHeight * 0.05,
                  ),
                  SizedBox(
                    width: 220,
                    height: 170,
                    child: Lottie.asset('assets/otp.json', fit: BoxFit.cover, repeat: true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: PrHeight * 0.04),
                    child: Center(
                      child: Text(
                        "Verify OTP",
                        style: GoogleFonts.ubuntu(
                          textStyle: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: PrHeight * 0.02),
                    child: Center(
                      child: Text(
                        "To complete the verification process, please enter the code we sent to your mobile number.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.black26,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: PrHeight * 0.01),
                    child: Center(
                      child: Text(

                        l_Vmpass.l_PrPhoneNumber.value, // replace '03136438798' with this
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: PrHeight * 0.05),
                      child: Pinput(
                        keyboardType: TextInputType.phone,
                        length: 6,
                        showCursor: true,
                        onChanged: (value) {
                          code = value;
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: PrHeight * 0.03),
                    child: Center(
                      child: SizedBox(
                          width: 200,
                          height: 50,
                          child: Obx(() {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                animationDuration: const Duration(seconds: 2),
                                shape: l_Vmpass.Pr_isLoading_wid.value
                                    ? RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      )
                                    : RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                backgroundColor: Colors.lightBlueAccent,
                              ),
                              onPressed: () async {
                                bool isOTPVerified = await l_Vmpass.FncVerifyOTP(code);
                                l_Vmlogin.FncUploadContacts(l_Vmlogin.Pr_contactList);
                                if (isOTPVerified) {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  bool isLoginWithNumber = prefs.getBool('isLoginWithNumber') ?? false;
                                  Get.snackbar(
                                    "OTP verified",
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
                                      "Your OTP has been successfully verified",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );

                                  if (!isLoginWithNumber) {
                                    // Show dialog if not shown before
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Lottie.asset('assets/reg.json', fit: BoxFit.cover, repeat: false),
                                        );
                                      },
                                    ).then((value) {
                                      // Set isLoginWithNumber to true when dialog is dismissed
                                      prefs.setBool('isLoginWithNumber', true);
                                    });


                                  }

                                  else {
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


                                } else {
                                  Get.snackbar(
                                    "OTP not verified",
                                    "Please try again",
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

                              child: l_Vmpass.Pr_isLoading_wid.value
                                  ? LoadingAnimationWidget.twistingDots(
                                      leftDotColor: const Color(0xFF1A1A3F),
                                      rightDotColor: const Color(0xFFFFFFFF),
                                      size: 40,
                                    )
                                  : Text(
                                      "Verify",
                                      style: GoogleFonts.ubuntu(
                                          textStyle: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              //fontWeight: FontWeight.w600,
                                              letterSpacing: .5)),
                                    ),
                            );
                          })),
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
