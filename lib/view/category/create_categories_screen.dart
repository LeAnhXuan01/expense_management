import 'package:expense_management/widget/custom_snackbar_1.dart';
import 'package:expense_management/widget/custom_snackbar_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../view_model/category/create_category_view_model.dart';
import '../../widget/custom_ElevatedButton_2.dart';
import '../../widget/custom_header_1.dart';

class CreateCategoriesScreen extends StatefulWidget {
  final int initialSelectedValue;

  const CreateCategoriesScreen({super.key, this.initialSelectedValue = 0});

  @override
  State<CreateCategoriesScreen> createState() => _CreateCategoriesScreenState();
}

class _CreateCategoriesScreenState extends State<CreateCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CreateCategoryViewModel>(context, listen: false)
        .setSelectedValue(widget.initialSelectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CreateCategoryViewModel>(
          builder: (context, viewModel, child) {
        return Column(
          children: [
            CustomHeader_1(
              title: 'Tạo danh mục',
              action: IconButton(
                icon: Icon(Icons.check, color: Colors.white),
                onPressed: viewModel.enableButton ? () async {
                  final newCategory = await viewModel.createCategory();
                  if (newCategory != null) {
                    await CustomSnackBar_2.show(context, 'Tạo thành công');
                    Navigator.pop(context, newCategory);
                    viewModel.resetFields();
                  } else {
                    CustomSnackBar_1.show(context, 'Có lỗi xảy ra khi tạo danh mục');
                  }
                } : null,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 70),
                            child: TextFormField(
                              controller: viewModel.nameCategory,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Tên danh mục',
                              ),
                            ),
                          ),
                          if (viewModel.selectedIcon != null)
                            Positioned(
                              left: 2.0,
                              top: 5.0,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: viewModel.selectedColor ??
                                      Colors.blueGrey.shade200,
                                ),
                                child: Icon(
                                  viewModel.selectedIcon,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          if (viewModel.selectedIcon == null)
                            Positioned(
                              left: 2.0,
                              top: 5.0,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: viewModel.selectedColor ??
                                      Colors.blueGrey.shade200,
                                ),
                                child: Icon(
                                  FontAwesomeIcons.question,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            value: 0,
                            groupValue: viewModel.selectedValue,
                            onChanged: (value) {
                              viewModel.setSelectedValue(value as int);
                            },
                          ),
                          Text(
                            'Thu nhập',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(width: 50),
                          Radio(
                            value: 1,
                            groupValue: viewModel.selectedValue,
                            onChanged: (value) {
                              viewModel.setSelectedValue(value as int);
                            },
                          ),
                          Text(
                            'Chi tiêu',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Biểu tượng',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              viewModel.toggleShowPlusButtonIcon();
                            },
                            child: Icon(
                              viewModel.showPlusButtonIcon
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_drop_up,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      viewModel.showPlusButtonIcon
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,

                              ),
                              itemCount: viewModel.currentIconsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    viewModel.setSelectedIcon(
                                        viewModel.currentIconsList[index]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: viewModel.selectedIcon ==
                                              viewModel.currentIconsList[index]
                                          ? Border.all(
                                              color: Colors.black, width: 1.0)
                                          : null,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: viewModel.selectedIcon ==
                                                  viewModel
                                                      .currentIconsList[index]
                                              ? (viewModel.selectedColor ??
                                                  Colors.blueGrey.shade200)
                                              : Colors.blueGrey.shade200,
                                        ),
                                        child: Icon(
                                          viewModel.currentIconsList[index],
                                          size: 38,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : SizedBox.shrink(),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Text(
                            'Màu sắc:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              viewModel.toggleShowPlusButtonColor();
                            },
                            child: Icon(
                              viewModel.showPlusButtonColor
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_drop_up,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      viewModel.showPlusButtonColor
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              itemCount: viewModel.colors.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    viewModel.setSelectedColor(
                                        viewModel.colors[index]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: viewModel.selectedColor ==
                                              viewModel.colors[index]
                                          ? Border.all(
                                              color: Colors.black, width: 2.0)
                                          : null,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: viewModel.colors[index],
                                          shape: BoxShape.circle,
                                        ),
                                        child: viewModel.selectedColor ==
                                                viewModel.colors[index]
                                            ? Icon(Icons.check,
                                                color: Colors.white, size: 24)
                                            : null,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : SizedBox.shrink(),
                      CustomElevatedButton_2(
                        text: 'Tạo',
                        onPressed: viewModel.enableButton ? () async {
                          final newCategory = await viewModel.createCategory();
                          if (newCategory != null) {
                            await CustomSnackBar_2.show(context, 'Tạo thành công.');
                            Navigator.pop(context, newCategory);
                            viewModel.resetFields();
                          } else {
                            CustomSnackBar_1.show(context, 'Có lỗi xảy ra khi tạo danh mục');
                          }
                        } : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
