import 'package:flutter/material.dart';

import '../../../widget/custom_ElevatedButton_2.dart';
import '../../../widget/custom_header.dart';


class CatalogColorScreen extends StatefulWidget {
  final List<Color> colors; // Define the colors parameter
  final Color? initialColor; // Add initialColor parameter to store the initially selected color
  const CatalogColorScreen({Key? key, required this.colors, this.initialColor}) : super(key: key);

  @override
  _CatalogColorScreenState createState() => _CatalogColorScreenState();
}

class _CatalogColorScreenState extends State<CatalogColorScreen> {
  // Biến để theo dõi màu cơ bản đã chọn
  Color? selectedBaseColor;

  // Biến để theo dõi shade được chọn
  Color? selectedShadeColor;

  @override
  void initState() {
    super.initState();
    // Initialize the selected color with the initialColor if provided
    selectedShadeColor = widget.initialColor;
  }


  @override
  Widget build(BuildContext context) {
    final List<Color> baseColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.brown,
      Colors.deepPurpleAccent,
      Colors.cyanAccent,
      Colors.black
    ];

    return Scaffold(
      body: Column(
        children: [
          CustomHeader(title: 'Chọn màu'),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 15,
                          children: List.generate(baseColors.length, (index) {
                            return _buildColorShades(baseColors[index], () {
                              // Khi một màu cơ bản được chọn, cập nhật màu cơ bản đã chọn
                              setState(() {
                                selectedBaseColor = baseColors[index];
                                selectedShadeColor = baseColors[index]; // Thiết lập shade mặc định cho màu cơ bản
                              });
                            });
                          }),
                        ),
                        SizedBox(height: 15),
                        selectedBaseColor != null ? _buildShadeColors(selectedBaseColor!) : SizedBox(), // Hiển thị shade màu nếu đã chọn màu cơ bản
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: CustomElevatedButton_2(
                    text: 'Chọn',
                    onPressed: selectedShadeColor != null ? () {
                      Navigator.pop(context, selectedShadeColor);
                    } : null,
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorShades(Color color, Function()? onPressed) {
    final List<Color> shades = [
      color,
      Color.lerp(color, Colors.white, 0.1)!,
      Color.lerp(color, Colors.white, 0.2)!,
      Color.lerp(color, Colors.white, 0.3)!,
      Color.lerp(color, Colors.white, 0.4)!,
      Color.lerp(color, Colors.white, 0.5)!,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 20,
            children: List.generate(shades.length, (index) {
              return GestureDetector(
                onTap: () {
                  // Khi một shade được chọn, cập nhật shade đã chọn
                  setState(() {
                    selectedShadeColor = shades[index];
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: shades[index],
                  ),
                  child: selectedShadeColor == shades[index]
                      ? Icon(Icons.check, color: Colors.white, size: 24) // Hiển thị biểu tượng check cho shade được chọn
                      : null, // Không hiển thị biểu tượng check cho các shade khác
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildShadeColors(Color baseColor) {
    final List<Color> shades = [
      baseColor,
      Color.lerp(baseColor, Colors.white, 0.1)!,
      Color.lerp(baseColor, Colors.white, 0.2)!,
      Color.lerp(baseColor, Colors.white, 0.3)!,
      Color.lerp(baseColor, Colors.white, 0.4)!,
      Color.lerp(baseColor, Colors.white, 0.5)!,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Chọn shade:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 20,
            children: List.generate(shades.length, (index) {
              return GestureDetector(
                onTap: () {
                  // Khi một shade được chọn, cập nhật shade đã chọn
                  setState(() {
                    selectedShadeColor = shades[index];
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: shades[index],
                  ),
                  child: selectedShadeColor == shades[index]
                      ? Icon(Icons.check, color: Colors.white, size: 24,) // Hiển thị biểu tượng check cho shade được chọn
                      : null, // Không hiển thị biểu tượng check cho các shade khác
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
