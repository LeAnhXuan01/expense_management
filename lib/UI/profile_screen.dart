import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/custom_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image and Username
                CustomHeader(title: 'Hồ Sơ'),
                Expanded(child:
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 50.0,
                                child: ClipOval(
                                  child: Image.asset('assets/images/profile.png'),
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Text(
                                'Lê Anh Xuân',
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 50,),
                              Icon(Icons.edit),
                            ],
                          ),
                          SizedBox(height: 20.0),

                          // Settings Section
                          Text(
                            'Cài đặt',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () {
                              // Navigate to Change Password screen
                              Navigator.pushNamed(context, '/change-pass');
                            },
                            leading: Icon(Icons.lock),
                            title: Text('Đổi mật khẩu'),
                          ),
                          ListTile(
                            onTap: () {
                              // Show Language Selection Dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Chọn ngôn ngữ'),
                                  content: Text('Chọn ngôn ngữ bạn muốn sử dụng:'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Set language to Vietnamese
                                        // ... Update language settings
                                        Navigator.pop(context);
                                      },
                                      child: Text('Tiếng Việt'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Set language to English
                                        // ... Update language settings
                                        Navigator.pop(context);
                                      },
                                      child: Text('English'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            leading: Icon(Icons.language),
                            title: Text('Thay đổi ngôn ngữ'),
                          ),
                          ListTile(
                            onTap: () {
                              // Show Currency Selection Dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Chọn loại tiền tệ'),
                                  content: Text('Chọn loại tiền tệ bạn muốn sử dụng:'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Set currency to VND
                                        // ... Update currency settings
                                        Navigator.pop(context);
                                      },
                                      child: Text('VND'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Set currency to USD
                                        // ... Update currency settings
                                        Navigator.pop(context);
                                      },
                                      child: Text('USD'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            leading: Icon(Icons.monetization_on),
                            title: Text('Thay đổi loại tiền tệ'),
                          ),
                          SizedBox(height: 20.0),
                          // Logout Button
                          SizedBox(
                            height: 50,
                            width: double.maxFinite,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/login');
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.deepPurple), // Đặt màu nền cho nút
                              ),
                              child: const Text(
                                'Đăng xuất',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ),
              ],
            ),
    );
  }
}
