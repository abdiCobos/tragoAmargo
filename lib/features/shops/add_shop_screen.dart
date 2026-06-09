import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:async';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../providers/coffee_shops_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/geocoding_service.dart';
import '../../l10n/app_localizations.dart';

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
  bool _searchingAddress = false;
  Timer? _searchTimer;

  bool _showExtras = false;
  bool _showHours = false;

  final _roastOptions = ['Claro', 'Medio', 'Oscuro'];
  final _brewingOptions = ['V60', 'Chemex', 'Aeropress', 'French Press', 'Espresso', 'Cold Brew', 'Sifón'];
  final _seatingOptions = ['', 'Mesas y sillas', 'Solo para llevar', 'Espacio público'];
  final _days = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];

  AppLocalizations get l10n => AppLocalizations.of(context);

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
    _searchTimer?.cancel();
    super.dispose();
  }

  void _onAddressChanged(String query) {
    _searchTimer?.cancel();
    if (query.length < 3) {
      setState(() { _addressSuggestions = []; _showSuggestions = false; _searchingAddress = false; });
      return;
    }
    _searchTimer = Timer(const Duration(milliseconds: 500), () => _searchAddress(query));
  }

  Future<void> _searchAddress(String query) async {
    if (query.length < 3) return;
    setState(() => _searchingAddress = true);
    final geo = context.read<GeocodingService>();
    final results = await geo.searchStructured(query);
    if (mounted) {
      setState(() {
        _addressSuggestions = results;
        _showSuggestions = results.isNotEmpty;
        _searchingAddress = false;
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

  String _dayLabel(String day) {
    switch (day) {
      case 'lunes': return l10n.monday;
      case 'martes': return l10n.tuesday;
      case 'miércoles': return l10n.wednesday;
      case 'jueves': return l10n.thursday;
      case 'viernes': return l10n.friday;
      case 'sábado': return l10n.saturday;
      case 'domingo': return l10n.sunday;
      default: return day;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_roastLevels.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectRoastLevels)),
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
        SnackBar(content: Text(l10n.shopAdded), backgroundColor: AppColors.brown800),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addCoffeeShop)),
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
                  color: AppColors.brown50, borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(l10n.optionalNote, style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(l10n.requiredFields, style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.nameRequired,
                  prefixIcon: const Icon(Icons.store),
                ),
                validator: (v) => Validators.required(v, l10n.name),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _originController,
                decoration: InputDecoration(
                  labelText: l10n.originAltitudeRequired,
                  hintText: l10n.originHint,
                  prefixIcon: const Icon(Icons.landscape),
                ),
                validator: (v) => Validators.required(v, l10n.originAltitude),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: l10n.addressRequired,
                  hintText: l10n.address,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  suffixIcon: _showSuggestions
                      ? const Icon(Icons.search, size: 20)
                      : null,
                ),
                validator: (v) => Validators.required(v, l10n.address),
                onChanged: _onAddressChanged,
              ),
              if (_searchingAddress)
                const Padding(padding: EdgeInsets.only(top: 8), child: LinearProgressIndicator()),
              if (_showSuggestions) ...[
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.brown100),
                  ),
                  constraints: const BoxConstraints(maxHeight: 160),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _addressSuggestions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) => ListTile(
                      dense: true,
                      leading: Icon(Icons.location_on, size: 18, color: theme.colorScheme.primary),
                      title: Text(_addressSuggestions[i]['displayName'] as String,
                          style: theme.textTheme.bodyMedium),
                      onTap: () => _selectAddress(_addressSuggestions[i]),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),

              Text(l10n.roastLevelsRequired, style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: _roastOptions.map((r) {
                  final selected = _roastLevels.contains(r);
                  return FilterChip(
                    label: Text(r),
                    selected: selected,
                    selectedColor: AppColors.gold.withValues(alpha: 0.2),
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
                title: Text(l10n.wifiSwitch, style: theme.textTheme.titleSmall),
                value: _hasWiFi,
                activeTrackColor: AppColors.brown800,
                onChanged: (v) => setState(() => _hasWiFi = v),
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _seatingMode,
                decoration: InputDecoration(
                  labelText: l10n.spaceType,
                  prefixIcon: const Icon(Icons.chair),
                ),
                items: _seatingOptions.map((o) => DropdownMenuItem(
                  value: o,
                  child: Text(o.isEmpty ? l10n.seatingEmpty : o),
                )).toList(),
                onChanged: (v) => setState(() => _seatingMode = v ?? ''),
              ),

              const SizedBox(height: 28),
              InkWell(
                onTap: () => setState(() => _showExtras = !_showExtras),
                child: Row(
                  children: [
                    Icon(_showExtras ? Icons.expand_less : Icons.expand_more, color: AppColors.gray600),
                    const SizedBox(width: 8),
                    Text(l10n.moreDetailsOpt, style: theme.textTheme.titleMedium),
                  ],
                ),
              ),
              if (_showExtras) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController, maxLines: 3,
                  decoration: InputDecoration(labelText: l10n.description, prefixIcon: const Icon(Icons.description)),
                ),
                const SizedBox(height: 14),
                Text(l10n.brewingMethods, style: theme.textTheme.titleSmall),
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
                Text(l10n.priceRange, style: theme.textTheme.titleSmall),
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
                  decoration: InputDecoration(labelText: l10n.phone, prefixIcon: const Icon(Icons.phone)),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _instagramController,
                  decoration: InputDecoration(labelText: l10n.instagramHint, prefixIcon: const Icon(Icons.camera_alt)),
                ),
              ],

              const SizedBox(height: 20),
              InkWell(
                onTap: () => setState(() => _showHours = !_showHours),
                child: Row(
                  children: [
                    Icon(_showHours ? Icons.expand_less : Icons.expand_more, color: AppColors.gray600),
                    const SizedBox(width: 8),
                    Text(l10n.hoursOpt, style: theme.textTheme.titleMedium),
                  ],
                ),
              ),
              if (_showHours)
                ..._days.map((day) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          SizedBox(width: 100, child: Text(_dayLabel(day))),
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
              Row(children: [
                Icon(Icons.photo_library_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(l10n.photosOpt, style: theme.textTheme.titleMedium),
              ]),
              const SizedBox(height: 8),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _pickPhotos,
                    icon: const Icon(Icons.photo_library, size: 18),
                    label: Text(l10n.gallery),
                    style: OutlinedButton.styleFrom(minimumSize: Size.zero),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: Text(l10n.camera),
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
                          label: Text(l10n.addCoffeeShop),
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
