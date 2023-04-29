import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import '../ViewModel/VmPhoneNumber.dart';
import 'VwLogin.dart';

class VwPhoneNumber extends StatefulWidget {
  const VwPhoneNumber({Key? key}) : super(key: key);

  @override
  State<VwPhoneNumber> createState() => _VwPhoneNumberState();
}

class _VwPhoneNumberState extends State<VwPhoneNumber> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VmPhoneNumber l_Vmpass = Get.put(VmPhoneNumber());
  final TextEditingController PhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PhoneController.text = l_Vmpass.Pr_txtphonenumber_Text;

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
                    child: Lottie.asset('assets/pass.json', fit: BoxFit.cover, repeat: false),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: PrHeight * 0.04),
                    child: Center(
                      child: Text(
                        "Reset Password",
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
                        "Please enter your email to reset your password. We will send you a secure link to reset your password. Please do not share this link with anyone.",
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
                    padding: EdgeInsets.only(top: PrHeight * 0.05),
                    child: Center(
                      child: SizedBox(
                          width: PrWidth * .890,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: PhoneController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100],
                              hintText: 'Enter your number',
                              hintStyle: const TextStyle(color: Colors.black38),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide.none),
                              prefixIcon: const Icon(Icons.phone_iphone_rounded, size: 20, color: Colors.grey),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Number is required';
                              }
                              l_Vmpass.Pr_txtphonenumber_Text = value;

                            },
                            onChanged: (value) {
                              l_Vmpass.Pr_txtphonenumber_Text = value;
                            },
                          )),
                    ),
                  ),
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
                                if (_formKey.currentState!.validate()) {

                                } else {
                                  l_Vmpass.Pr_autoValidate.value = true;
                                }

                              },
                              child: l_Vmpass.Pr_isLoading_wid.value
                                  ? LoadingAnimationWidget.twistingDots(
                                leftDotColor: const Color(0xFF1A1A3F),
                                rightDotColor: const Color(0xFFFFFFFF),
                                size: 40,
                              )
                                  : Text(
                                "Tap",
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
