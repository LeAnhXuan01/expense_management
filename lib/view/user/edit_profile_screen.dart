import 'dart:io';
import 'package:expense_management/view/user/profile_picture_details_screen.dart';
import 'package:expense_management/widget/custom_ElevatedButton_2.dart';
import 'package:expense_management/widget/custom_header_1.dart';
import 'package:expense_management/widget/custom_snackbar_1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../view_model/user/edit_profile_view_model.dart';


class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Consumer<EditProfileViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  CustomHeader_1(title: 'Chỉnh sửa hồ sơ cá nhân'),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: viewModel.imageFile != null
                              ? FileImage(File(viewModel.imageFile!.path))
                              : AssetImage('assets/images/profile.png') as ImageProvider,
                        ),
                        TextButton(
                          onPressed: () => _showAvatarOptionsDialog(context, viewModel),
                          child: Text('Chọn ảnh đại diện'),
                        ),
                        TextField(
                          controller: viewModel.nameController,
                          decoration: InputDecoration(labelText: 'Tên hiển thị'),
                        ),
                        TextFormField(
                          controller: viewModel.birthDateController,
                          decoration: InputDecoration(
                            labelText: 'Ngày sinh',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () => viewModel.selectDate(context),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: 'Nam',
                                  groupValue: viewModel.gender,
                                  onChanged: viewModel.setGender,
                                ),
                                const Text('Nam'),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                  value: 'Nữ',
                                  groupValue: viewModel.gender,
                                  onChanged: viewModel.setGender,
                                ),
                                const Text('Nữ'),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                  value: 'Khác',
                                  groupValue: viewModel.gender,
                                  onChanged: viewModel.setGender,
                                ),
                                const Text('Khác'),
                              ],
                            ),
                          ],
                        ),
                        TextField(
                          controller: viewModel.addressController,
                          decoration: InputDecoration(labelText: 'Địa chỉ'),
                        ),
                        TextField(
                          controller: viewModel.occupationController,
                          decoration: InputDecoration(
                            labelText: 'Nghề nghiệp',
                            suffixIcon: DropdownButton(
                              underline: Container(),
                              onChanged: viewModel.setSelectedOccupation,
                              items: [
                                'Bác sĩ', 'Kế toán', 'Kiến trúc sư', 'Kỹ sư xây dựng',
                                'Lập trình viên', 'Văn phòng', 'Giáo viên', 'Khác'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomElevatedButton_2(
                          onPressed: () {
                            // Chức năng lưu thông tin
                          },
                          text: 'Lưu',
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );

  }

  void _showAvatarOptionsDialog(BuildContext context, EditProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đổi ảnh đại diện'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Chọn từ thư viện ảnh'),
                onTap: () async {
                  Navigator.pop(context);
                  await viewModel.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Chụp ảnh'),
                onTap: () async {
                  Navigator.pop(context);
                  await viewModel.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Xem ảnh đại diện'),
                onTap: () {
                  Navigator.pop(context);
                  if (viewModel.imageFile != null) {
                    _viewProfilePicture(context, viewModel.imageFile!.path);
                  } else {
                    CustomSnackBar_1.show(context, 'Chưa có ảnh đại diện mới.');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _viewProfilePicture(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePictureDetailsScreen(imagePath: imagePath),
      ),
    );
  }
}
