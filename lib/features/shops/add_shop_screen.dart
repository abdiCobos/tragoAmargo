import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../providers/coffee_shops_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/geocoding_service.dart';

class AddShopScreen extends StatefulWidget {
  const AddShopScreen({super.key});

  @override
  State<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _originController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instagramController = TextEditingController();

  final _roastLevels = <String>[];
  final _brewingMethods = <String>[];
  String _priceRange = r'$';
  bool _hasWiFi = false;
  String _seatingMode = '';
  final _photos = <Uint8List>[];
  final _openingHours = <String, TextEditingController>{};
  List<Map<String, dynamic>> _addressSuggestions = [];
  bool _showSuggestions = false;

  bool _showExtras = false;
  bool _showHours = false;

  final _roastOptions = ['Claro', 'Medio', 'Oscuro', 'Espresso'];
  final _brewingOptions = ['V60', 'Chemex', 'Aeropress', 'French Press', 'Espresso', 'Cold Brew', 'Sifón'];
  final _seatingOptions = ['', 'Mesas y sillas', 'Solo para llevar', 'Espacio público'];
  final _days = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];

  @override
  void initState() {
    super.initState();
    for (final day in _days) {
      _openingHours[day] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _originController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _instagramController.dispose();
    for (final ctrl in _openingHours.values) ctrl.dispose();
    super.dispose();
  }

  Future<void> _searchAddress(String query) async {
    if (query.length < 3) {
      setState(() { _addressSuggestions = []; _showSuggestions = false; });
      return;
    }
    final geo = context.read<GeocodingService>();
    final results = await geo.searchPlaces(query);
    if (mounted) {
      setState(() {
        _addressSuggestions = results;
        _showSuggestions = results.isNotEmpty;
      });
    }
  }

  void _selectAddress(Map<String, dynamic> suggestion) {
    _addressController.text = suggestion['displayName'] as String;
    setState(() { _addressSuggestions = []; _showSuggestions = false; });
  }

  Future<void> _pickPhotos() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(imageQuality: 80);
    if (images.isNotEmpty) {
      for (final img in images) {
        final bytes = await img.readAsBytes();
        setState(() => _photos.add(bytes));
      }
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() => _photos.add(bytes));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_roastLevels.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un nivel de tostado')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final provider = context.read<CoffeeShopsProvider>();

    final openingHours = <String, String>{};
    for (final day in _days) {
      final v = _openingHours[day]!.text.trim();
      if (v.isNotEmpty) openingHours[day] = v;
    }

    final shopId = await provider.addCoffeeShop(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      originAndAltitude: _originController.text.trim(),
      roastLevels: _roastLevels,
      brewingMethods: _brewingMethods,
      priceRange: _priceRange,
      hasWiFi: _hasWiFi,
      seatingMode: _seatingMode,
      openingHours: openingHours,
      phone: _phoneController.text.trim(),
      instagram: _instagramController.text.trim(),
      address: _addressController.text.trim(),
      photos: _photos,
      userId: auth.user?.uid,
    );

    if (shopId != null && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cafetería agregada'), backgroundColor: AppColors.secondary),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Cafetería')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface, borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.secondary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Solo necesitas nombre, origen del café y dirección. El resto es opcional.',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('Requerido',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la cafetería *',
                  prefixIcon: Icon(Icons.store),
                ),
                validator: (v) => Validators.required(v, 'El nombre'),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _originController,
                decoration: const InputDecoration(
                  labelText: 'Origen y Altura del Café *',
                  hintText: 'Ej: Etiopía Yirgacheffe, 1,900 msnm',
                  prefixIcon: Icon(Icons.landscape),
                ),
                validator: (v) => Validators.required(v, 'El origen y altura'),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Dirección *',
                  hintText: 'Ej: Av. Juárez 123, Guadalajara',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  suffixIcon: _showSuggestions
                      ? const Icon(Icons.search, size: 20)
                      : null,
                ),
                validator: (v) => Validators.required(v, 'La dirección'),
                onChanged: _searchAddress,
              ),
              if (_showSuggestions) ...[
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  constraints: const BoxConstraints(maxHeight: 160),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _addressSuggestions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) => ListTile(
                      dense: true,
                      leading: const Icon(Icons.location_on, size: 18, color: AppColors.secondary),
                      title: Text(_addressSuggestions[i]['displayName'] as String,
                          style: const TextStyle(fontSize: 13)),
                      onTap: () => _selectAddress(_addressSuggestions[i]),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),

              const Text('Niveles de Tostado *',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: _roastOptions.map((r) {
                  final selected = _roastLevels.contains(r);
                  return FilterChip(
                    label: Text(r),
                    selected: selected,
                    selectedColor: AppColors.secondary.withValues(alpha: 0.3),
                    onSelected: (val) {
                      setState(() {
                        if (val) {_roastLevels.add(r);} else {_roastLevels.remove(r);}
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('WiFi disponible *',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                value: _hasWiFi,
                activeTrackColor: AppColors.secondary,
                onChanged: (v) => setState(() => _hasWiFi = v),
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _seatingMode,
                decoration: const InputDecoration(
                  labelText: 'Tipo de espacio',
                  prefixIcon: Icon(Icons.chair),
                ),
                items: _seatingOptions.map((o) => DropdownMenuItem(
                  value: o,
                  child: Text(o.isEmpty ? 'Seleccionar...' : o),
                )).toList(),
                onChanged: (v) => setState(() => _seatingMode = v ?? ''),
              ),

              const SizedBox(height: 28),
              InkWell(
                onTap: () => setState(() => _showExtras = !_showExtras),
                child: Row(
                  children: [
                    Icon(_showExtras ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    const Text('Más detalles (opcional)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (_showExtras) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController, maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Descripción', prefixIcon: Icon(Icons.description)),
                ),
                const SizedBox(height: 14),
                const Text('Métodos de Preparación', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: _brewingOptions.map((m) {
                    final selected = _brewingMethods.contains(m);
                    return FilterChip(
                      label: Text(m), selected: selected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {_brewingMethods.add(m);} else {_brewingMethods.remove(m);}
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                const Text('Rango de Precio', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: r'$', label: Text(r'$')),
                    ButtonSegment(value: r'$$', label: Text(r'$$')),
                    ButtonSegment(value: r'$$$', label: Text(r'$$$')),
                  ],
                  selected: {_priceRange},
                  onSelectionChanged: (val) => setState(() => _priceRange = val.first),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController, keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone)),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _instagramController,
                  decoration: const InputDecoration(labelText: 'Instagram (sin @)', prefixIcon: Icon(Icons.camera_alt)),
                ),
              ],

              const SizedBox(height: 20),
              InkWell(
                onTap: () => setState(() => _showHours = !_showHours),
                child: Row(
                  children: [
                    Icon(_showHours ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    const Text('Horarios (opcional)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (_showHours)
                ..._days.map((day) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          SizedBox(width: 100, child: Text(day[0].toUpperCase() + day.substring(1))),
                          Expanded(
                            child: TextFormField(
                              controller: _openingHours[day],
                              decoration: InputDecoration(
                                hintText: '7:00-21:00', isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

              const SizedBox(height: 20),
              const Row(children: [
                Icon(Icons.photo_library_outlined, color: AppColors.secondary),
                SizedBox(width: 8),
                Text('Fotos (opcional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 8),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _pickPhotos,
                    icon: const Icon(Icons.photo_library, size: 18),
                    label: const Text('Galería'),
                    style: OutlinedButton.styleFrom(minimumSize: Size.zero),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: const Text('Cámara'),
                    style: OutlinedButton.styleFrom(minimumSize: Size.zero),
                  ),
                ],
              ),
              if (_photos.isNotEmpty) ...[
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _photos.length,
                    itemBuilder: (_, i) => Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(_photos[i], width: 80, height: 80, fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          right: 4, top: -4,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: AppColors.error, size: 18),
                            onPressed: () => setState(() => _photos.removeAt(i)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),
              Consumer<CoffeeShopsProvider>(
                builder: (context, provider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (provider.error != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(provider.error!, style: const TextStyle(color: AppColors.error)),
                        ),
                      SizedBox(
                        width: double.infinity, height: 52,
                        child: ElevatedButton.icon(
                          onPressed: provider.isLoading ? null : _submit,
                          icon: provider.isLoading
                              ? const SizedBox(width: 20, height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.add_location),
                          label: const Text('Agregar Cafetería'),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
