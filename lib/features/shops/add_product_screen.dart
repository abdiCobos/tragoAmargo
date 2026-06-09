import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/coffee_shops_provider.dart';
import '../../../services/storage_service.dart';

class AddProductScreen extends StatefulWidget {
  final String shopId;
  const AddProductScreen({super.key, required this.shopId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  Uint8List? _photoBytes;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() => _photoBytes = bytes);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final storage = context.read<StorageService>();
    final shopProv = context.read<CoffeeShopsProvider>();

    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    String photoUrl = '';
    if (_photoBytes != null) {
      photoUrl = await storage.uploadImageBytes(_photoBytes!, name: 'product_${widget.shopId}');
    }

    await shopProv.addProduct(
      shopId: widget.shopId,
      name: _nameController.text.trim(),
      price: price,
      description: _descriptionController.text.trim(),
      photoUrl: photoUrl,
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bebida agregada'), backgroundColor: AppColors.brown800),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Bebida')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre de la bebida *', prefixIcon: Icon(Icons.local_drink)),
                validator: (v) => Validators.required(v, 'El nombre'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio *', prefixIcon: Icon(Icons.attach_money), prefixText: '\$ '),
                validator: Validators.price,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 14),
              Text('Foto (opcional)', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              if (_photoBytes != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(_photoBytes!, width: 120, height: 120, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 0, top: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: AppColors.error),
                        onPressed: () => setState(() => _photoBytes = null),
                      ),
                    ),
                  ],
                )
              else
                OutlinedButton.icon(
                  onPressed: _pickPhoto,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Seleccionar foto'),
                  style: OutlinedButton.styleFrom(minimumSize: Size.zero),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _submit,
                  icon: _saving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.add),
                  label: const Text('Agregar Bebida'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
