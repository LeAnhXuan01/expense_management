import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/enum.dart';
import '../../model/profile_model.dart';

class EditProfileViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  DateTime selectedDate = DateTime(1990, 1, 1);
  String gender = 'Khác';
  String? selectedJob;
  final ImagePicker picker = ImagePicker();
  PickedFile? imageFile;
  String? networkImageUrl;
  String _displayName = 'Người dùng';
  String get displayName => _displayName;

  EditProfileViewModel(){
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('profiles').doc(userId).get();

        if (documentSnapshot.exists) {
          Profile profile = Profile.fromMap(documentSnapshot.data()!);
          nameController.text = profile.displayName;
          birthDateController.text = profile.birthDate;
          gender = profile.gender == Gender.male ? 'Nam' :
          profile.gender == Gender.female ? 'Nữ' : 'Khác';
          addressController.text = profile.address;
          jobController.text = profile.job;
          if (profile.profileImageUrl.isNotEmpty) {
            networkImageUrl = profile.profileImageUrl;
          } else {
            networkImageUrl = 'assets/images/profile.png'; // Sử dụng ảnh mặc định nếu không có ảnh đại diện
          }
          _displayName = profile.displayName;
        } else {
          _displayName = user.email!.split('@')[0];
          nameController.text = _displayName!;
          birthDateController.text = "1/1/1990";
        }
        notifyListeners();
      }
    } catch (e) {
      print("Lỗi khi tải hồ sơ: $e");
    }
  }


  Future<String?> uploadImage(String path) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      File file = File(path);
      try {
        Reference ref = FirebaseStorage.instance.ref().child('user_avatars').child(userId);
        TaskSnapshot uploadTask = await ref.putFile(file);
        return await uploadTask.ref.getDownloadURL();
      } catch (e) {
        print("Lỗi khi tải ảnh lên: $e");
        return null;
      }
    }
    return null;
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      String? imageUrl = await uploadImage(pickedFile.path);
      if (imageUrl != null) {
        networkImageUrl = imageUrl;
        updateProfileImage(pickedFile.path);
        await saveProfile(); // Lưu thông tin hồ sơ ngay sau khi tải lên ảnh đại diện mới
      }
    }
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      birthDateController.text = "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
      notifyListeners();
    }
  }

  void setGender(String? value) {
    gender = value!;
    notifyListeners();
  }

  void setSelectedJob(String? newValue) {
    selectedJob = newValue;
    jobController.text = selectedJob!;
    notifyListeners();
  }

  // Hàm cập nhật ảnh đại diện
  void updateProfileImage(String imagePath) {
    imageFile = PickedFile(imagePath);
    notifyListeners(); // Thông báo cho UI rằng đã có sự thay đổi
  }

  Future<void> saveProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String profileImageUrl = networkImageUrl ?? 'assets/images/profile.png';

      Profile profile = Profile(
        profileId: user.uid,
        userId: user.uid,
        displayName: nameController.text,
        birthDate: birthDateController.text,
        gender: gender == 'Nam' ? Gender.male : (gender == 'Nữ' ? Gender.female : Gender.other),
        address: addressController.text,
        job: jobController.text,
        profileImageUrl: profileImageUrl,
      );

      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .set(profile.toMap());
    }
    _displayName = nameController.text;
    notifyListeners();
  }
}

