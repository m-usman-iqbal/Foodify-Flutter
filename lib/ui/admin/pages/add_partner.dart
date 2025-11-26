//
import 'package:burger/bloc/add_partner_bloc/add_partner_bloc.dart';
import 'package:burger/bloc/add_partner_bloc/add_partner_event.dart';
import 'package:burger/bloc/add_partner_bloc/add_partner_state.dart';
import 'package:burger/data/repositories/add_partner_repository.dart';
import 'package:burger/data/services/add_partner_servies.dart';
import 'package:burger/domain/models/add_partner_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Partner extends StatelessWidget {
  Partner({super.key});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _shippingController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  Widget buildTextField(
    String hint,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      height: 44,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
        ),
        style: const TextStyle(fontSize: 14, color: Color(0xFF7A869A)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = PartnerRepository(service: PartnerService());

    return BlocProvider(
      create: (_) => PartnerBloc(repository: repository),
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.fromLTRB(35, 80, 35, 42),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Add Partner",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                buildTextField("Title", _titleController),
                buildTextField("Address", _addressController),
                buildTextField(
                  "Distance (km)",
                  _distanceController,
                  type: TextInputType.number,
                ),
                buildTextField(
                  "Rating",
                  _ratingController,
                  type: TextInputType.number,
                ),
                buildTextField("Shipping", _shippingController),
                buildTextField("Status", _statusController),
                buildTextField("Price", _priceController),
                buildTextField("Type", _typeController),
                buildTextField("Image file name", _imageController),

                const SizedBox(height: 20),

                BlocConsumer<PartnerBloc, PartnerState>(
                  listener: (context, state) {
                    if (state is PartnerSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("✅ Partner added successfully!"),
                          backgroundColor: Colors.green,
                        ),
                      );

                      _titleController.clear();
                      _addressController.clear();
                      _distanceController.clear();
                      _ratingController.clear();
                      _shippingController.clear();
                      _statusController.clear();
                      _priceController.clear();
                      _typeController.clear();
                      _imageController.clear();
                    } else if (state is PartnerFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("❌ Error: ${state.message}")),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is PartnerLoading;

                    return GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                              final partner = AddPartner(
                                title: _titleController.text.trim(),
                                address: _addressController.text.trim(),
                                distance:
                                    double.tryParse(
                                      _distanceController.text.trim(),
                                    ) ??
                                    0.0,
                                rating:
                                    double.tryParse(
                                      _ratingController.text.trim(),
                                    ) ??
                                    0.0,
                                shipping: _shippingController.text.trim(),
                                status: _statusController.text.trim(),
                                price: _priceController.text.trim(),
                                type: _typeController.text.trim(),
                                image: _imageController.text.trim(),
                                owner: FirebaseAuth.instance.currentUser!.uid,
                              );
                              context.read<PartnerBloc>().add(
                                AddPartnerPressed(partner),
                              );
                            },
                      child: Container(
                        height: 44,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF9F27),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Add Partner',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
