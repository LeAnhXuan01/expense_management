import 'dart:io';
import 'package:expense_management/widget/custom_header_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/profile_model.dart';
import '../../view_model/user/edit_profile_view_model.dart';
import '../../widget/custom_ElevatedButton_1.dart';
import 'edit_profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EditProfileViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              CustomHeader_2(title: tr('profile')),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: viewModel.imageFile != null
                              ? FileImage(File(viewModel.imageFile!.path))
                              : (viewModel.networkImageUrl != null
                              ? NetworkImage(viewModel.networkImageUrl!)
                              : AssetImage('assets/images/profile.png'))
                          as ImageProvider,
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          viewModel.displayName,
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              tr('edit_profile'),
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                          ),
                          onTap: () async {
                            final updatedProfile = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(),
                              ),
                            );
                            if (updatedProfile != null && updatedProfile is Profile) {
                              await viewModel.loadProfile();
                            }
                          },
                        ),
                        SizedBox(height: 50.0),
                        // Settings Section
                        Text(
                          tr('settings'),
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Divider(),
                        ListTile(
                          onTap: () {
                            // Navigate to Change Password screen
                            Navigator.pushNamed(context, '/change-password');
                          },
                          leading: Icon(Icons.lock),
                          title: Text(tr('change_password')),
                        ),
                        ListTile(
                          onTap: () {
                            // Show Language Selection Dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(tr('select_language')),
                                content: Text(tr('select_language')),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.setLocale(Locale('vi'));
                                      Navigator.pop(context);
                                    },
                                    child: Text('Tiếng Việt'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.setLocale(Locale('en'));
                                      Navigator.pop(context);
                                    },
                                    child: Text('English'),
                                  ),
                                ],
                              ),
                            );
                          },
                          leading: Icon(Icons.language),
                          title: Text(tr('change_language')),
                        ),
                        ListTile(
                          onTap: () {
                            // Show Currency Selection Dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(tr('select_currency')),
                                content: Text(tr('select_currency')),
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
                          title: Text(tr('change_currency')),
                        ),
                        SizedBox(height: 20.0),
                        // Logout Button
                        SizedBox(
                          height: 50,
                          width: double.maxFinite,
                          child: CustomElavatedButton_1(
                            text: tr('logout'),
                            onPressed: () {
                              _showSignOutConfirmationDialog(context, viewModel);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  void _showSignOutConfirmationDialog(BuildContext context, EditProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr('confirm_logout')),
          content: Text(tr('are_you_sure_you_want_to_logout')),
          actions: <Widget>[
            TextButton(
              child: Text(tr('cancel'), style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(tr('logout'), style: TextStyle(color: Colors.blue),),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                viewModel.signOut(context); // Call sign out function
              },
            ),
          ],
        );
      },
    );
  }

}
