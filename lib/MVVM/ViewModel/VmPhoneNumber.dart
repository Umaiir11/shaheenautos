import 'package:get/get.dart';
import 'package:tuple/tuple.dart';


class VmPhoneNumber extends GetxController {
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







}
