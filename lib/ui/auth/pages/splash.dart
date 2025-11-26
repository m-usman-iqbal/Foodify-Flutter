import 'package:burger/ui/auth/pages/login.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var step = 0;
  final List<String> titleList = [
    'Diverse & sparkling food.',
    'Free shipping on all orders.',
    '+24K Restaurants.',
  ];
  final List<String> textList = [
    'We use the best local ingredients to create fresh and delicious food and drinks.',
    'Free shipping on the primary order whilst the usage of CaPay fee method.',
    'Easily find your favorite food and have it delivered in record time.',
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = ['group.png', 'Frame.png', 'Frame13.png'];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 272.31,
            margin: EdgeInsets.fromLTRB(35, 135, 35, 80),
            child: PageView.builder(
              itemBuilder: (context, index) {
                final img = imgList[index];
                return Image.asset('assets/$img', fit: BoxFit.cover);
              },
              itemCount: imgList.length,
              onPageChanged: (index) {
                setState(() {
                  step = index;
                });
              },
            ),
          ),
          SizedBox(
            width: 305,
            height: 92,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32,
                  width: double.infinity,
                  child: Text(
                    titleList[step],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  width: double.infinity,

                  child: Text(
                    textList[step],
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          SizedBox(
            width: 72,
            height: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: step == 0 ? 32 : 12,
                  decoration: BoxDecoration(
                    color: step == 0 ? Color(0xFFEF9F27) : Color(0xFFEBECF0),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                Container(
                  width: step == 1 ? 32 : 12,
                  decoration: BoxDecoration(
                    color: step == 1 ? Color(0xFFEF9F27) : Color(0xFFEBECF0),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                Container(
                  width: step == 2 ? 32 : 12,
                  decoration: BoxDecoration(
                    color: step == 2 ? Color(0xFFEF9F27) : Color(0xFFEBECF0),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 64),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Container(
              width: 305,
              height: 44,
              decoration: BoxDecoration(
                color: Color(0xFFEF9F27),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
