import 'dart:io';
import 'package:expense_management/widget/custom_ElevatedButton_2.dart';
import 'package:expense_management/widget/custom_header_1.dart';
import 'package:expense_management/widget/custom_snackbar_1.dart';
import 'package:expense_management/widget/custom_snackbar_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../view_model/user/edit_profile_view_model.dart';
import '../transaction/component/image_detail_screen.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<EditProfileViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            CustomHeader_1(title: 'Chỉnh sửa hồ sơ'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (viewModel.networkImageUrl != null || viewModel.imageFile != null) {
                            _viewProfilePicture(context, viewModel.networkImageUrl, viewModel.imageFile);
                          } else {
                            CustomSnackBar_1.show(context, 'Chưa có ảnh đại diện mới');
                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: viewModel.imageFile != null
                              ? FileImage(File(viewModel.imageFile!.path))
                              : (viewModel.networkImageUrl != null
                                      ? NetworkImage(viewModel.networkImageUrl!)
                                      : AssetImage('assets/images/profile.png'))
                                  as ImageProvider,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            _showAvatarOptionsDialog(context, viewModel),
                        child: Text('Chọn ảnh đại diện'),
                      ),
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(30),
                        ],
                        controller: viewModel.nameController,
                        decoration: InputDecoration(labelText: 'Tên hiển thị'),
                      ),
                      SizedBox(height: 10),
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
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        controller: viewModel.addressController,
                        decoration: InputDecoration(labelText: 'Địa chỉ'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        controller: viewModel.jobController,
                        decoration: InputDecoration(
                          labelText: 'Nghề nghiệp',
                          suffixIcon: DropdownButton(
                            underline: Container(),
                            onChanged: viewModel.setSelectedJob,
                            items: [
                              'Bác sĩ',
                              'Kế toán',
                              'Kiến trúc sư',
                              'Kỹ sư xây dựng',
                              'Lập trình viên',
                              'Văn phòng',
                              'Giáo viên',
                              'Khác'
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
                        onPressed: () async {
                          final updateProfile = await viewModel.saveProfile();
                          if (updateProfile != null) {
                            await CustomSnackBar_2.show(context, 'Lưu thông tin thành công');
                            Navigator.pop(context, updateProfile);
                          }
                        },
                        text: 'Lưu',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ));
  }

  void _showAvatarOptionsDialog(
      BuildContext context, EditProfileViewModel viewModel) {
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
            ],
          ),
        );
      },
    );
  }

  void _viewProfilePicture(BuildContext context, String? networkImageUrl, File? imageFile) {
    if (networkImageUrl == null && imageFile == null) {
      CustomSnackBar_1.show(context, 'Chưa có ảnh đại diện mới');
      return;
    }

    if (imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageDetailScreen(
            imageUrls: null,
            imageFiles: [imageFile],
            initialIndex: 0,
          ),
        ),
      );
    } else if (networkImageUrl != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageDetailScreen(
            imageUrls: [networkImageUrl],
            imageFiles: null,
            initialIndex: 0,
          ),
        ),
      );
    }
  }
}
