import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/enum.dart';
import '../../model/profile_model.dart';

class EditProfileViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  DateTime selectedDate = DateTime(1990, 1, 1);
  String gender = 'Khác';
  String? selectedOccupation;
  final ImagePicker picker = ImagePicker();
  PickedFile? imageFile;

  EditProfileViewModel() {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .get();

      if (profileSnapshot.exists) {
        Profile profile = Profile.fromMap(profileSnapshot.data() as Map<String, dynamic>);
        nameController.text = profile.displayName;
        addressController.text = profile.address;
        birthDateController.text = profile.birthDate;
        selectedDate = DateTime.parse(profile.birthDate);
        gender = profile.gender == Gender.male ? 'Nam' : (profile.gender == Gender.female ? 'Nữ' : 'Khác');
        selectedOccupation = profile.displayName;
        notifyListeners();
      } else {
        init(user);
      }
    }
  }

  void init(User user) {
    String displayName = user.email!.split('@')[0];
    nameController.text = displayName;
    birthDateController.text = "${selectedDate.toLocal().day}/${selectedDate.toLocal().month}/${selectedDate.toLocal().year}";
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

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    imageFile = pickedFile != null ? PickedFile(pickedFile.path) : null;
    notifyListeners();
  }

  void setGender(String? value) {
    gender = value!;
    notifyListeners();
  }

  void setSelectedOccupation(String? newValue) {
    selectedOccupation = newValue;
    occupationController.text = selectedOccupation!;
    notifyListeners();
  }

  Future<void> saveProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String profileImageUrl = imageFile != null ? imageFile!.path : 'assets/images/profile.png';

      Profile profile = Profile(
        profileId: user.uid,
        userId: user.uid,
        displayName: nameController.text,
        birthDate: birthDateController.text,
        gender: gender == 'Nam' ? Gender.male : (gender == 'Nữ' ? Gender.female : Gender.other),
        address: addressController.text,
        profileImageUrl: profileImageUrl,
      );

      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .set(profile.toMap());
    }
  }
}
