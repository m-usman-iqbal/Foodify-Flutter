import 'package:flutter/material.dart';

class Nearby extends StatelessWidget {
  const Nearby({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(35, 80, 35, 0),
          child: Column(
            children: [
              Image.asset('nearby.png'),
              SizedBox(height: 40),
              Container(
                height: 84,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 32,
                      child: Text(
                        'Find Nearby Restaurants',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                      height: 48,
                      child: Text(
                        'Enter your location or allow access to your location to find restaurants near you.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7A869A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                height: 96,
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      height: 44,
                      width: 305,
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F5F7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          'Use current location',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 44,
                      width: 305,
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F5F7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons
                                .location_on, // you can change this to any icon
                            color: Color(0xFFC1C7D0),
                          ),
                          hintText: 'Enter a new address',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          border: InputBorder.none, // removes default underline
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
