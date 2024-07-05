import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/enum.dart';
import '../../model/profile_model.dart';
import '../../services/profile_service.dart';

class EditProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  DateTime selectedDate = DateTime(1990, 1, 1);
  String gender = 'Khác';
  String? selectedJob;
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  String? networkImageUrl;
  String _displayName = 'Người dùng';
  String get displayName => _displayName;

  EditProfileViewModel(){
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      User? user = await _profileService.getCurrentUser();
      if (user != null) {
        String userId = user.uid;
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _profileService.getProfile(userId);

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
            networkImageUrl = 'assets/images/profile.png';
          }
          _displayName = profile.displayName;
        } else {
          _displayName = user.email!.split('@')[0];
          nameController.text = _displayName;
          birthDateController.text = "1/1/1990";
        }
        notifyListeners();
      }
    } catch (e) {
      print("Lỗi khi tải hồ sơ: $e");
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      User? currentUser = await _profileService.getCurrentUser();
      if (currentUser != null) {
        String? imageUrl = await _profileService.uploadImage(currentUser.uid, pickedFile.path);
        if (imageUrl != null) {
          networkImageUrl = imageUrl;
          updateProfileImage(pickedFile.path);
          await saveProfile(); // Lưu thông tin hồ sơ ngay sau khi tải lên ảnh đại diện mới
        }
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
    imageFile = File(imagePath);
    notifyListeners(); // Thông báo cho UI rằng đã có sự thay đổi
  }

  Future<Profile?> saveProfile() async {
    User? user = await _profileService.getCurrentUser();
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

      await _profileService.saveProfile(profile);
      return profile;
    }
    _displayName = nameController.text;
    notifyListeners();
    return null;
  }
}

