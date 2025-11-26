import 'package:burger/data/repositories/partners_repository.dart';
import 'package:burger/data/services/partner_services.dart';
import 'package:burger/ui/restaurnts/pages/restaurant_profile.dart';
import 'package:burger/ui/partners/view_models/partners_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllPartners extends StatelessWidget {
  const AllPartners({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          PartnersViewModel(PartnersRepository(PartnersService()))
            ..loadPartners(), // load partners on initialization
      child: Consumer<PartnersViewModel>(
        builder: (context, viewModel, _) {
          final stateIsLoading = viewModel.isLoading;
          final stateError = viewModel.error;
          final partners = viewModel.partners;

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'All Partners',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              toolbarHeight: 100,
            ),
            body: Column(
              children: [
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey[200],
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(35, 35, 35, 0),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: (MediaQuery.of(context).size.height * 0.7) + 60,
                        width: double.infinity,
                        child: Builder(
                          builder: (context) {
                            // 🔹 Handle viewmodel states
                            if (stateIsLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (stateError != null) {
                              return Center(child: Text(stateError));
                            } else if (partners.isEmpty) {
                              return const Center(
                                child: Text('No partners found'),
                              );
                            }

                            return ListView.builder(
                              itemCount: partners.length,
                              itemBuilder: (context, index) {
                                final partner = partners[index];
                                final partnerId = partner.id;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      height: 173,
                                      width: 305,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          'assets/${partner.image}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RestaurantProfile(
                                                  partner: [partner],
                                                  restaurantId: partner.id,
                                                ),
                                          ),
                                        );
                                        print('rest id : $partnerId');
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            partner.title,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Image.asset('assets/verify.png'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      height: 20,
                                      width: 142,
                                      child: Row(
                                        children: [
                                          Text(
                                            partner.status,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Container(
                                            height: 2,
                                            width: 2,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffC1C7D0),
                                            ),
                                          ),
                                          SizedBox(width: 16),

                                          Text(
                                            partner.type,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 24,
                                      width: 256,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 24,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffEF9F27),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                    size: 10,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${partner.rating}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            height: 2,
                                            width: 2,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffC1C7D0),
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 11,
                                                color: Color(0xffC1C7D0),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                '${partner.distance}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Container(
                                            height: 2,
                                            width: 2,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffC1C7D0),
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/Time.png',
                                                height: 24,
                                                width: 24,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                partner.shipping,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
