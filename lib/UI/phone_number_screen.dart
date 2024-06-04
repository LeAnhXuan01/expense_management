import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneVerificationPage extends StatefulWidget {
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();

  void _verifyPhoneNumber() async {
    String phoneNumber = _phoneNumberController.text.trim();
    // Kiểm tra xem người dùng đã nhập mã quốc gia hay chưa
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+84' + phoneNumber.substring(1); // Thay thế số 0 ở đầu bằng +84
    }
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-sign in the user if the code is correct
        await _auth.signInWithCredential(credential);
        // Handle successful auto-sign in
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failed
        print('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }


  void _signInWithPhoneNumber() async {
    String smsCode = _smsCodeController.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );
    try {
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      // Handle successful sign in
    } catch (e) {
      // Handle error
      print('Sign in failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              keyboardType: TextInputType.phone,
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _verifyPhoneNumber,
              child: Text('Send Verification Code'),
            ),
            SizedBox(height: 16.0),
            Visibility(
              visible: _verificationId.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _smsCodeController,
                    decoration: InputDecoration(labelText: 'Verification Code'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _signInWithPhoneNumber,
                    child: Text('Verify Code'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
