import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/icon_item_data.dart';
import '../../../view_model/transaction/icon_category_viewmodel.dart';
import '../../../widget/custom_ElevatedButton_2.dart';
import '../../../widget/custom_header.dart';

class IconCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IconCategoryViewModel(),
      child: IconCategoryScreenContent(),
    );
  }
}

class IconCategoryScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader(title: 'Danh sách danh mục'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: icons.length,
                    itemBuilder: (context, index) {
                      final category = icons[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                              category.name,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Wrap(
                              spacing: 5.0,
                              runSpacing: 10.0,
                              children: category.icons.map((icon) {
                                return GestureDetector(
                                  onTap: () {
                                    // Khi một biểu tượng được chọn, cập nhật biểu tượng đã chọn trong ViewModel
                                    Provider.of<IconCategoryViewModel>(context, listen: false).setSelectedIcon(icon);
                                  },
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Provider.of<IconCategoryViewModel>(context).selectedIcon == icon ? Border.all(color: Colors.black, width: 1.0) : null,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Provider.of<IconCategoryViewModel>(context).selectedIcon == icon ? Colors.deepPurpleAccent.shade200 : Colors.blueGrey.shade200,
                                        ),
                                        child: Icon(
                                          icon,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: CustomElevatedButton_2(
                      text: 'Chọn',
                      onPressed: Provider.of<IconCategoryViewModel>(context).selectedIcon != null ? () {
                        // Trả về biểu tượng đã chọn khi nhấn nút "Chọn"
                        Navigator.pop(context, Provider.of<IconCategoryViewModel>(context, listen: false).selectedIcon);
                        print('GUI BIEU TUONG THANH CONG');
                      } : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
