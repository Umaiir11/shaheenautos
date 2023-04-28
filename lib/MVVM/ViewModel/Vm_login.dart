
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Vm_login extends GetxController  {

  RxList<Contact> Pr_contactList = <Contact>[].obs;

  Future<bool> Fnc_GoogleLogin() async {
    print("Google Login method called");

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

      if (googleAccount == null) {
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        print("Google sign-in successful!");
        print("User display name: ${user.displayName}");
        print("User email: ${user.email}");
        print("User photo URL: ${user.photoURL}");
        return true;
      } else {
        print("Google sign-in failed.");
        return false;
      }
    } catch (error) {
      print("Error during Google sign-in: $error");
      return false;
    }
  }



  Future<void> logout(GoogleSignIn googleSignIn) async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }

  Future<void> FncPermissions() async {
    PermissionStatus l_mediaPermission = await Permission.contacts.request();

    if (l_mediaPermission == PermissionStatus.granted) {
      fetchContacts();
    }

    if (l_mediaPermission == PermissionStatus.denied) {

    }

    if (l_mediaPermission == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  void fetchContacts() async {
    Pr_contactList.value = await ContactsService.getContacts();
    print(Pr_contactList[0].displayName);
    print(Pr_contactList[0].androidAccountName);
    print(Pr_contactList[0].phones![0].value);
    print(Pr_contactList[0].givenName);
  }


}