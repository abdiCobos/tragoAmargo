import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/coffee_shops_provider.dart';
import '../../../services/firestore_service.dart';
import '../../../services/storage_service.dart';
import '../../../models/coffee_shop.dart';
import '../../../l10n/app_localizations.dart';

class EditShopScreen extends StatefulWidget {
  final CoffeeShop shop;
  const EditShopScreen({super.key, required this.shop});

  @override
  State<EditShopScreen> createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<EditShopScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _originCtrl;
  late TextEditingController _addrCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _igCtrl;
  late List<String> _roastLevels;
  late List<String> _brewingMethods;
  late String _priceRange;
  late bool _hasWiFi;
  late String _seatingMode;
  late Map<String, TextEditingController> _hours;
  late List<String> _photos;
  bool _saving = false;
  bool _uploadingPhoto = false;
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
    final s = widget.shop;
    _nameCtrl = TextEditingController(text: s.name);
    _descCtrl = TextEditingController(text: s.description);
    _originCtrl = TextEditingController(text: s.originAndAltitude);
    _addrCtrl = TextEditingController(text: s.address);
    _phoneCtrl = TextEditingController(text: s.phone);
    _igCtrl = TextEditingController(text: s.instagram);
    _roastLevels = List.from(s.roastLevels);
    _brewingMethods = List.from(s.brewingMethods);
    _priceRange = s.priceRange;
    _hasWiFi = s.hasWiFi;
    _seatingMode = s.seatingMode;
    _hours = {};
    for (final d in _days) {
      _hours[d] = TextEditingController(text: s.openingHours[d] ?? '');
    }
    _photos = List.from(s.photos);
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _descCtrl.dispose(); _originCtrl.dispose();
    _addrCtrl.dispose(); _phoneCtrl.dispose(); _igCtrl.dispose();
    for (final c in _hours.values) c.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (photo == null || !mounted) return;

    setState(() => _uploadingPhoto = true);
    try {
      final bytes = await photo.readAsBytes();
      final storage = context.read<StorageService>();
      final url = await storage.uploadImageBytes(bytes, name: 'shop_${widget.shop.id}');
      setState(() => _photos.add(url));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.uploadError), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.selectRoastLevels)));
      return;
    }
    setState(() => _saving = true);

    final oh = <String, String>{};
    for (final d in _days) { final v = _hours[d]!.text.trim(); if (v.isNotEmpty) oh[d] = v; }

    final updated = widget.shop.copyWith(
      name: _nameCtrl.text.trim(), description: _descCtrl.text.trim(),
      originAndAltitude: _originCtrl.text.trim(), address: _addrCtrl.text.trim(),
      roastLevels: _roastLevels, brewingMethods: _brewingMethods, priceRange: _priceRange,
      hasWiFi: _hasWiFi, seatingMode: _seatingMode, openingHours: oh,
      phone: _phoneCtrl.text.trim(), instagram: _igCtrl.text.trim(),
      photos: _photos,
    );

    final fs = context.read<FirestoreService>();
    await fs.updateCoffeeShop(updated);
    if (mounted) context.read<CoffeeShopsProvider>().selectShop(widget.shop.id);

    if (mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.shopUpdated), backgroundColor: AppColors.secondary));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.editCoffeeShop)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.basicInfo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 12),
            TextFormField(controller: _nameCtrl, decoration: InputDecoration(labelText: l10n.name, prefixIcon: const Icon(Icons.store)), validator: (v) => Validators.required(v, l10n.name)),
            const SizedBox(height: 14),
            TextFormField(controller: _originCtrl, decoration: InputDecoration(labelText: l10n.originAltitudeRequired, prefixIcon: const Icon(Icons.landscape)), validator: (v) => Validators.required(v, l10n.originAltitude)),
            const SizedBox(height: 14),
            TextFormField(controller: _addrCtrl, decoration: InputDecoration(labelText: l10n.addressRequired, prefixIcon: const Icon(Icons.location_on_outlined)), validator: (v) => Validators.required(v, l10n.address)),
            const SizedBox(height: 14),
            Text(l10n.roastingLevels, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Wrap(spacing: 8, children: _roastOptions.map((r) {
              final sel = _roastLevels.contains(r);
              return FilterChip(label: Text(r), selected: sel, selectedColor: AppColors.secondary.withValues(alpha: 0.3),
                onSelected: (v) => setState(() { if (v) {_roastLevels.add(r);} else {_roastLevels.remove(r);} }));
            }).toList()),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(l10n.photos, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const Spacer(),
                Text('${_photos.length} ${l10n.photos.toLowerCase()}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 12),
            if (_photos.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _photos.length,
                  itemBuilder: (_, i) => Stack(
                    children: [
                      Container(
                        width: 100, height: 100, margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(image: NetworkImage(_photos[i]), fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 4, right: 12,
                        child: GestureDetector(
                          onTap: () => setState(() => _photos.removeAt(i)),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                            child: const Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _uploadingPhoto ? null : _addPhoto,
                icon: _uploadingPhoto
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.add_a_photo),
                label: Text(_uploadingPhoto ? l10n.uploading : l10n.addPhoto),
              ),
            ),
            const SizedBox(height: 14),
            SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l10n.wifiAvailable), value: _hasWiFi, activeTrackColor: AppColors.secondary, onChanged: (v) => setState(() => _hasWiFi = v)),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _seatingMode, decoration: InputDecoration(labelText: l10n.seatingMode, prefixIcon: const Icon(Icons.chair)),
              items: _seatingOptions.map((o) => DropdownMenuItem(value: o, child: Text(o.isEmpty ? l10n.seatingEmpty : o))).toList(),
              onChanged: (v) => setState(() => _seatingMode = v ?? ''),
            ),
            const SizedBox(height: 28),
            InkWell(onTap: () => setState(() => _showExtras = !_showExtras), child: Row(children: [
              Icon(_showExtras ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary),
              const SizedBox(width: 8), Text(l10n.moreDetails, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ])),
            if (_showExtras) ...[
              const SizedBox(height: 12),
              TextFormField(controller: _descCtrl, maxLines: 3, decoration: InputDecoration(labelText: l10n.description)),
              const SizedBox(height: 14),
              Text(l10n.brewingMethods, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, children: _brewingOptions.map((m) {
                final sel = _brewingMethods.contains(m);
                return FilterChip(label: Text(m), selected: sel, onSelected: (v) => setState(() { if (v) {_brewingMethods.add(m);} else {_brewingMethods.remove(m);} }));
              }).toList()),
              const SizedBox(height: 14),
              Text(l10n.priceRange, style: const TextStyle(fontWeight: FontWeight.w600)),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: r'$', label: Text(r'$')),
                  ButtonSegment(value: r'$$', label: Text(r'$$')),
                  ButtonSegment(value: r'$$$', label: Text(r'$$$')),
                ],
                selected: {_priceRange}, onSelectionChanged: (v) => setState(() => _priceRange = v.first),
              ),
              const SizedBox(height: 10),
              TextFormField(controller: _phoneCtrl, decoration: InputDecoration(labelText: l10n.phone, prefixIcon: const Icon(Icons.phone))),
              const SizedBox(height: 14),
              TextFormField(controller: _igCtrl, decoration: InputDecoration(labelText: l10n.instagramHint, prefixIcon: const Icon(Icons.camera_alt))),
            ],
            const SizedBox(height: 20),
            InkWell(onTap: () => setState(() => _showHours = !_showHours), child: Row(children: [
              Icon(_showHours ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary),
              const SizedBox(width: 8), Text(l10n.hours, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ])),
            if (_showHours) ..._days.map((d) => Padding(
              padding: const EdgeInsets.only(top: 8), child: Row(children: [
                SizedBox(width: 100, child: Text(_dayLabel(d))),
                Expanded(child: TextFormField(controller: _hours[d], decoration: const InputDecoration(hintText: '7:00-21:00', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
              ]),
            )),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(
              onPressed: _saving ? null : _submit,
              icon: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save),
              label: Text(l10n.saveChanges),
            )),
            const SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }
}
