import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../View/Vw_OTP.dart';


class VmPhoneNumber extends GetxController {

  final l_PhonenoAuth = FirebaseAuth.instance;
  var Pr_verificationID = ''.obs;

  RxBool Pr_autoValidate = false.obs;
  RxBool Pr_CheckBox = false.obs;

  RxBool Pr_isLoading = false.obs;

  RxBool get Pr_isLoading_wid {
    return Pr_isLoading;
  }

  set Pr_isLoading_wid(RxBool value) {
    Pr_isLoading = value;
  }

  RxString l_PrPhoneNumber = ''.obs;

  String get Pr_txtphonenumber_Text {
    return l_PrPhoneNumber.value;
  }

  set Pr_txtphonenumber_Text(String value) {
    l_PrPhoneNumber.value = value;
  }

  String? Pr_validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Number';
    }
    return null;
  }



  Future<void> FncPhoneNumberLogin(String Pr_Phoneno) async {
    try {
      await l_PhonenoAuth.verifyPhoneNumber(
        phoneNumber: Pr_Phoneno,
        verificationCompleted: (credential) async {
          await l_PhonenoAuth.signInWithCredential(credential);
          // Navigate to the next screen here
          Get.to(() => VwOTP());
        },
        verificationFailed: (e) {
          // Handle verification failure here
          print('Verification failed: ${e.message}');
        },
        codeSent: (verificationId, resendToken) {
          print('Verification code sent to $Pr_Phoneno');
          this.Pr_verificationID.value = verificationId;
          // Navigate to the next screen here
          Get.to(() => VwOTP());
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.Pr_verificationID.value = verificationId;
          // Navigate to the next screen here
          Get.to(() => VwOTP());
        },
      );
    } catch (e) {
      // Handle other errors here
      print('Error during phone number verification: ${e.toString()}');
    }
  }

  Future<bool> FncVerifyOTP(String Pr_OTP) async {
    var credentials = await l_PhonenoAuth.signInWithCredential(PhoneAuthProvider.credential
      (
        verificationId: this.Pr_verificationID.value, smsCode: Pr_OTP),);
    if (credentials.user != null) {
      print("Verification successful!");
      print("User display name: ${credentials.user?.displayName}");
      print("User email: ${credentials.user?.email}");
      print("User photo URL: ${credentials.user?.photoURL}");
      return true;
    } else {
      print("Verification failed.");
      return false;
    }
  }



}
