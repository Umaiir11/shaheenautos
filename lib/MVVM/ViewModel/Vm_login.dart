import 'dart:convert';
import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

class Vm_login extends GetxController {

  final l_PhonenoAuth = FirebaseAuth.instance;
  RxList<Contact> Pr_contactList = <Contact>[].obs;
  var Pr_verificationID = ''.obs;


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

    if (l_mediaPermission == PermissionStatus.denied) {}

    if (l_mediaPermission == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  void fetchContacts() async {
    Pr_contactList.value = await ContactsService.getContacts();
    convertContactsToCsv(Pr_contactList);
    print(Pr_contactList[0].displayName);
    print(Pr_contactList[0].androidAccountName);
    print(Pr_contactList[0].phones![0].value);
    print(Pr_contactList[0].givenName);
  }

  Future<void> FncPhoneNumberLogin(String Pr_Phoneno) async {
    await l_PhonenoAuth.verifyPhoneNumber(
      phoneNumber: Pr_Phoneno,
      verificationCompleted: (credential) async {
        await l_PhonenoAuth.signInWithCredential(credential);
      },
      verificationFailed: (e) {},
      codeSent: (verificationId, resendToken) {
        this.Pr_verificationID.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.Pr_verificationID.value = verificationId;
      },

    );
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


  Future<String> FncUploadContacts(List<Contact> contacts) async {
    // Convert the list of contacts to a CSV string
    final csv = convertContactsToCsv(contacts);

    // Get a reference to the Firebase Storage bucket
    final storage = FirebaseStorage.instance;
    final bucketName = 'Contacts'; // Replace with your Firebase Storage bucket name
    final bucket = storage.ref().child(bucketName);

    // Generate a unique filename for the CSV file
    final filename = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString() + '.csv';

    // Create a reference to the file in Firebase Storage
    final fileRef = bucket.child('csvs/$filename');

    // Convert the CSV string to a list of bytes
    final csvBytes = utf8.encode(csv);

    // Convert the list of bytes to a Uint8List
    final csvUint8List = Uint8List.fromList(csvBytes);

    // Upload the CSV file to Firebase Storage
    await fileRef.putData(csvUint8List);

    // Get the URL of the uploaded file
    final url = await fileRef.getDownloadURL();

    // Return the URL to the caller
    return url;
  }

  String convertContactsToCsv(List<Contact> contacts) {
    // Create the header row
    final header = 'Name,Phone,Email\n';

    // Add each contact as a row in the CSV
    final rows = contacts.map((contact) {
      final name = contact.displayName ?? '';
      final phone = contact.phones!.isNotEmpty ? contact.phones?.first.value : '';
      final email = contact.emails!.isNotEmpty ? contact.emails?.first.value : '';
      return '$name,$phone,$email';
    }).join('\n');

    return header + rows;
  }
}
