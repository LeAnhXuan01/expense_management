import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Biến để theo dõi trang hiện tại
  int _currentPageIndex = 0;

  // Danh sách các PageViewModel
  final List<PageViewModel> pages = [
    PageViewModel(
      title: 'Giành quyền kiểm soát hoàn toàn tiền của bạn',
      body: 'Trở thành người quản lý tiền của riêng bạn và kiếm được từng xu',
      image: Image.asset('assets/images/onboarding_1.png'),
      decoration: PageDecoration(
        pageColor: Colors.white,
        bodyTextStyle: TextStyle(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
      ),
    ),
    PageViewModel(
      title: 'Biết tiền của bạn đi đâu',
      body: 'Theo dõi giao dịch của bạn một cách dễ dàng với các danh mục và báo cáo tài chính',
      image: Image.asset('assets/images/onboarding_2.png'),
      decoration: const PageDecoration(
        pageColor: Colors.white,
        bodyTextStyle: TextStyle(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
      ),
    ),
    PageViewModel(
      title: 'Lập kế hoạch trước',
      body: 'Thiết lập ngân sách của bạn cho từng danh mục để bạn có thể kiểm soát',
      image: Image.asset('assets/images/onboarding_3.png'),
      decoration: const PageDecoration(
        pageColor: Colors.white,
        bodyTextStyle: TextStyle(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: pages,
        done: Text('Bắt đầu', style: TextStyle(color: Colors.black)),
        onDone: () => Navigator.pushReplacementNamed(context, '/login'),
        next: Text('Tiếp theo', style: TextStyle(color: Colors.black)),
        skip: Text('Bỏ qua', style: TextStyle(color: Colors.black)),
        showSkipButton: true,
        onSkip: () => Navigator.pushReplacementNamed(context, '/login'),
        dotsDecorator: DotsDecorator(
          color: Color(0xFFBDBDBD), // Màu sắc của dấu chấm
          activeColor: Colors.green, // Màu sắc của dấu chấm đang hoạt động
        ),
        onChange: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
    );
  }
}