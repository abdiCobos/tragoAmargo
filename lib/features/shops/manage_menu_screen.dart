import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../services/firestore_service.dart';
import '../../../services/storage_service.dart';
import '../../../models/menu_item.dart';

class ManageMenuScreen extends StatefulWidget {
  final String shopId;
  const ManageMenuScreen({super.key, required this.shopId});

  @override
  State<ManageMenuScreen> createState() => _ManageMenuScreenState();
}

class _ManageMenuScreenState extends State<ManageMenuScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  String _category = 'Bebida';
  bool _showPrice = true;
  bool _isSignature = false;
  Uint8List? _photoBytes;
  bool _saving = false;

  final _categories = ['Bebida', 'Comida', 'Postre', 'Té', 'Especial'];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
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
    final fs = context.read<FirestoreService>();

    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    String photoUrl = '';
    if (_photoBytes != null) {
      photoUrl = await storage.uploadProductPhoto(widget.shopId, _photoBytes!);
    }

    await fs.addMenuItem(MenuItem(
      id: '', shopId: widget.shopId,
      name: _nameController.text.trim(),
      category: _category, price: price, showPrice: _showPrice,
      description: _descController.text.trim(),
      photo: photoUrl, isSignature: _isSignature,
      createdAt: DateTime.now(),
    ));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ítem agregado al menú'), backgroundColor: AppColors.brown800),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar al Menú')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre *', prefixIcon: Icon(Icons.local_drink)),
                validator: (v) => Validators.required(v, 'El nombre'),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Categoría', prefixIcon: Icon(Icons.category)),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _category = v ?? 'Bebida'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio *', prefixIcon: Icon(Icons.attach_money), prefixText: '\$ '),
                validator: Validators.price,
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Mostrar precio'),
                subtitle: const Text('El precio será visible para los clientes'),
                value: _showPrice,
                activeTrackColor: AppColors.brown800,
                onChanged: (v) => setState(() => _showPrice = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Bebida insignia'),
                subtitle: const Text('Aparece destacada en el perfil de la cafetería'),
                value: _isSignature,
                activeTrackColor: AppColors.gold,
                onChanged: (v) => setState(() => _isSignature = v),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 14),
              Text('Foto', style: theme.textTheme.titleSmall),
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
                  label: const Text('Agregar al Menú'),
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
