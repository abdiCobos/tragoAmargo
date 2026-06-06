import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/coffee_shops_provider.dart';
import '../../../services/firestore_service.dart';
import '../../../services/storage_service.dart';
import '../../../services/geocoding_service.dart';
import '../../../models/coffee_shop.dart';

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
  bool _saving = false;
  bool _showExtras = false;
  bool _showHours = false;

  final _roastOptions = ['Claro', 'Medio', 'Oscuro'];
  final _brewingOptions = ['V60', 'Chemex', 'Aeropress', 'French Press', 'Espresso', 'Cold Brew', 'Sifón'];
  final _seatingOptions = ['', 'Mesas y sillas', 'Solo para llevar', 'Espacio público'];
  final _days = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];

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
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _descCtrl.dispose(); _originCtrl.dispose();
    _addrCtrl.dispose(); _phoneCtrl.dispose(); _igCtrl.dispose();
    for (final c in _hours.values) c.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_roastLevels.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona al menos un nivel de tostado')));
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
    );

    final fs = context.read<FirestoreService>();
    await fs.updateCoffeeShop(updated);
    if (mounted) context.read<CoffeeShopsProvider>().selectShop(widget.shop.id);

    if (mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cafetería actualizada'), backgroundColor: AppColors.secondary));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Cafetería')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Información básica', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 12),
            TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nombre', prefixIcon: Icon(Icons.store)), validator: (v) => Validators.required(v, 'El nombre')),
            const SizedBox(height: 14),
            TextFormField(controller: _originCtrl, decoration: const InputDecoration(labelText: 'Origen y Altura', prefixIcon: Icon(Icons.landscape)), validator: (v) => Validators.required(v, 'El origen y altura')),
            const SizedBox(height: 14),
            TextFormField(controller: _addrCtrl, decoration: const InputDecoration(labelText: 'Dirección', prefixIcon: Icon(Icons.location_on_outlined)), validator: (v) => Validators.required(v, 'La dirección')),
            const SizedBox(height: 14),
            const Text('Niveles de Tostado', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Wrap(spacing: 8, children: _roastOptions.map((r) {
              final sel = _roastLevels.contains(r);
              return FilterChip(label: Text(r), selected: sel, selectedColor: AppColors.secondary.withValues(alpha: 0.3),
                onSelected: (v) => setState(() { if (v) {_roastLevels.add(r);} else {_roastLevels.remove(r);} }));
            }).toList()),
            const SizedBox(height: 14),
            SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('WiFi disponible'), value: _hasWiFi, activeTrackColor: AppColors.secondary, onChanged: (v) => setState(() => _hasWiFi = v)),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _seatingMode, decoration: const InputDecoration(labelText: 'Tipo de espacio', prefixIcon: Icon(Icons.chair)),
              items: _seatingOptions.map((o) => DropdownMenuItem(value: o, child: Text(o.isEmpty ? 'Seleccionar...' : o))).toList(),
              onChanged: (v) => setState(() => _seatingMode = v ?? ''),
            ),
            const SizedBox(height: 28),
            InkWell(onTap: () => setState(() => _showExtras = !_showExtras), child: Row(children: [
              Icon(_showExtras ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary),
              const SizedBox(width: 8), const Text('Más detalles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ])),
            if (_showExtras) ...[
              const SizedBox(height: 12),
              TextFormField(controller: _descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Descripción')),
              const SizedBox(height: 14),
              const Text('Métodos de Preparación', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, children: _brewingOptions.map((m) {
                final sel = _brewingMethods.contains(m);
                return FilterChip(label: Text(m), selected: sel, onSelected: (v) => setState(() { if (v) {_brewingMethods.add(m);} else {_brewingMethods.remove(m);} }));
              }).toList()),
              const SizedBox(height: 14),
              const Text('Rango de Precio', style: TextStyle(fontWeight: FontWeight.w600)),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: r'$', label: Text(r'$')),
                  ButtonSegment(value: r'$$', label: Text(r'$$')),
                  ButtonSegment(value: r'$$$', label: Text(r'$$$')),
                ],
                selected: {_priceRange}, onSelectionChanged: (v) => setState(() => _priceRange = v.first),
              ),
              const SizedBox(height: 10),
              TextFormField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone))),
              const SizedBox(height: 14),
              TextFormField(controller: _igCtrl, decoration: const InputDecoration(labelText: 'Instagram (sin @)', prefixIcon: Icon(Icons.camera_alt))),
            ],
            const SizedBox(height: 20),
            InkWell(onTap: () => setState(() => _showHours = !_showHours), child: Row(children: [
              Icon(_showHours ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary),
              const SizedBox(width: 8), const Text('Horarios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ])),
            if (_showHours) ..._days.map((d) => Padding(
              padding: const EdgeInsets.only(top: 8), child: Row(children: [
                SizedBox(width: 100, child: Text(d[0].toUpperCase() + d.substring(1))),
                Expanded(child: TextFormField(controller: _hours[d], decoration: InputDecoration(hintText: '7:00-21:00', isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
              ]),
            )),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(
              onPressed: _saving ? null : _submit,
              icon: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save),
              label: const Text('Guardar Cambios'),
            )),
            const SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }
}
