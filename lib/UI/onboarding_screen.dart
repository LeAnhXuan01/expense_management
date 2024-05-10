import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import '../view_model/onboarding_view_model.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingViewModel(),
      child: OnboardingScreenContent(),
    );
  }
}

class OnboardingScreenContent extends StatelessWidget {
  final List<PageViewModel> pages = [
    PageViewModel(
        title: 'Giành quyền kiểm soát hoàn toàn tiền của bạn',
        body: 'Trở thành người quản lý tiền của riêng bạn và kiếm được từng xu',
        image: Image.asset('assets/images/onboarding_1.png'),
        decoration: PageDecoration(
          pageColor: Colors.white,
          bodyTextStyle: TextStyle(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
        )
    ),
    PageViewModel(
      title: 'Biết tiền của bạn đi đâu',
      body: 'Theo dõi giao dịch của bạn một cách dễ dàng với các danh mục và báo cáo tài chính',
      image: Image.asset('assets/images/onboarding_2.png'), // Đường dẫn ảnh
      decoration: const PageDecoration(
        pageColor: Colors.white,
        bodyTextStyle: TextStyle(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
      ),
    ),
    PageViewModel(
      title: 'Lập kế hoạch trước',
      body: 'Thiết lập ngân sách của bạn cho từng danh mục để bạn có thể kiểm soát',
      image: Image.asset('assets/images/onboarding_3.png'), // Đường dẫn ảnh
      decoration: const PageDecoration(
        pageColor: Colors.white,
        bodyTextStyle: TextStyle(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnboardingViewModel>(context);

    return IntroductionScreen(
      pages: pages,
      done: Text('Bắt đầu'),
      onDone: () => Navigator.of(context).pushNamed('/login'),
      next: Text('Tiếp theo'),
      skip: Text('Bỏ qua'),
      showSkipButton: true,
      onSkip: () => Navigator.of(context).pushNamed('/login'),
      dotsDecorator: DotsDecorator(
        color:  Color(0xFFBDBDBD), // Màu sắc của dấu chấm
        activeColor: Colors.deepPurpleAccent, // Màu sắc của dấu chấm đang hoạt động
      ),
      onChange: (index) {
        viewModel.setCurrentPageIndex(index);
      },
    );
  }
}
