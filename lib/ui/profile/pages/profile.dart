import 'package:burger/bloc/profile_bloc/profile_bloc.dart';
import 'package:burger/data/repositories/profile_repository.dart';
import 'package:burger/data/services/profile_services.dart';
import 'package:burger/ui/auth/pages/login.dart';
import 'package:burger/ui/cart/pages/orders.dart';
import 'package:burger/ui/cart/pages/partner_orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEBECF0),
      body: BlocProvider(
        create: (context) => ProfileBloc(
          repository: ProfileRepository(service: ProfileServices()),
        )..add(FetchProfile()),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final profile = state.profile;
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      height: 280,
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 100,
                            child: Center(
                              child: Text(
                                "Profile",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/${profile.imagePath!}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            profile.username!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("Email"),
                                subtitle: Text(
                                  profile.email!,
                                  style: TextStyle(color: Color(0xff7A869A)),
                                ),
                                leading: Icon(
                                  Icons.person,
                                  color: Color(0xff7A869A),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 1,
                                width: double.infinity,
                                color: const Color(0xFFEBECF0),
                              ),
                              ListTile(
                                title: Text("Address"),
                                subtitle: Text(
                                  profile.address!,
                                  style: TextStyle(color: Color(0xff7A869A)),
                                ),
                                leading: Icon(
                                  Icons.location_on,
                                  color: Color(0xff7A869A),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 1,
                                width: double.infinity,
                                color: const Color(0xFFEBECF0),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Orders(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  title: Text("My orders"),
                                  // subtitle: Text(
                                  //   profile.address!,
                                  //   style: TextStyle(color: Color(0xff7A869A)),
                                  // ),
                                  leading: Icon(
                                    Icons.receipt_long,
                                    color: Color(0xff7A869A),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 1,
                                width: double.infinity,
                                color: const Color(0xFFEBECF0),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PartnerOrders(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  title: Text("Customer orders"),
                                  // subtitle: Text(
                                  //   profile.address!,
                                  //   style: TextStyle(color: Color(0xff7A869A)),
                                  // ),
                                  leading: Icon(
                                    Icons.receipt,
                                    color: Color(0xff7A869A),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 1,
                                width: double.infinity,
                                color: const Color(0xFFEBECF0),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    await FirebaseAuth.instance.signOut();
                                    // Navigate to login screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  } catch (e) {
                                    print('Logout error: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to logout'),
                                      ),
                                    );
                                  }
                                },
                                child: ListTile(
                                  title: Text("Logout"),

                                  leading: Icon(
                                    Icons.logout,
                                    color: Color(0xff7A869A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Text('data');
            }
          },
        ),
      ),
    );
  }
}
