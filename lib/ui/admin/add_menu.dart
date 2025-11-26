import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:burger/bloc/add_menu_bloc/add_menu_bloc.dart';
import 'package:burger/bloc/add_menu_bloc/add_menu_event.dart';
import 'package:burger/bloc/add_menu_bloc/add_menu_state.dart';
import 'package:burger/data/repositories/add_menu_repository.dart';
import 'package:burger/data/services/add_menu_services.dart';

// Simple button widget
class AddMenuButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AddMenuButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF9F27), // base color
          foregroundColor: Colors.white, // text color
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: onPressed,
        child: const Text('Add Item', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

// Add Menu Form
class AddMenuForm extends StatefulWidget {
  const AddMenuForm({super.key});

  @override
  State<AddMenuForm> createState() => _AddMenuFormState();
}

class _AddMenuFormState extends State<AddMenuForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  bool _popular = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MenuBloc(repository: MenuRepository(service: MenuService())),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Add item",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        body: BlocListener<MenuBloc, MenuState>(
          listener: (context, state) {
            if (state is MenuSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Menu item added!')));
              _titleController.clear();
              _descriptionController.clear();
              _priceController.clear();
              _imageController.clear();

              setState(() => _popular = false);
              Navigator.pop(context, true);
            } else if (state is MenuError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) => value!.isEmpty ? 'Enter title' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter description' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Enter price' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _imageController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL (optional)',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Popular'),
                      Checkbox(
                        value: _popular,
                        onChanged: (value) {
                          setState(() {
                            _popular = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<MenuBloc, MenuState>(
                    builder: (context, state) {
                      if (state is MenuLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return AddMenuButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<MenuBloc>().add(
                              AddMenuItemEvent(
                                title: _titleController.text.trim(),
                                description: _descriptionController.text.trim(),
                                price: double.parse(
                                  _priceController.text.trim(),
                                ),
                                popular: _popular,
                                imagePath: _imageController.text.trim(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
