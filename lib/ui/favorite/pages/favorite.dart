import 'package:burger/bloc/favorite_bloc/favorite_block.dart';
import 'package:burger/bloc/favorite_bloc/favorite_event.dart';
import 'package:burger/bloc/favorite_bloc/favorite_state.dart';
import 'package:burger/domain/models/partners_model.dart';
import 'package:burger/ui/restaurnts/pages/restaurant_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:burger/utils/add_favorite_restaurant.dart';
import 'package:burger/data/repositories/favorite_repository.dart';
import 'package:burger/data/services/favorite_services.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          FavoriteBloc(FavoriteRepository(FavoriteService()))
            ..add(LoadFavorites()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Favorite Restaurants",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            height: 700,
            child: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null) {
                  return Center(child: Text("Error: ${state.error}"));
                }

                if (state.favorites.isEmpty) {
                  return const Center(child: Text('No favorites yet.'));
                }

                return ListView.builder(
                  itemCount: state.favorites.length,
                  itemBuilder: (context, index) {
                    final fav = state.favorites[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          final partner = Partner(
                            image: fav.image,
                            title: fav.title,
                            status: fav.status,
                            type: fav.type,
                            rating: fav.rating,
                            distance: fav.distance.toString(),
                            shipping: fav.shipping,
                            id: fav.id,
                            address: fav.address,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantProfile(
                                partner: [partner],
                                restaurantId: fav.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                          height: 128,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        'assets/${fav.image}',
                                        fit: BoxFit.cover,
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              fav.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            FavoriteButton(
                                              restaurantId: fav.id,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${fav.price} USD",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xffEF9F27),
                                              ),
                                            ),
                                            const Text('•'),
                                            Text(
                                              fav.type,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                width: double.infinity, // full width
                                height: 1, // 1 pixel tall
                                color: Color(0xFFECECEC),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
