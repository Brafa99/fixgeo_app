import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_colors.dart';
import 'custom_text_field.dart';

class WorkerCitySelector extends StatefulWidget {
  const WorkerCitySelector({
    required this.selectedCity,
    required this.onSelected,
    required this.validator,
    super.key,
  });

  final String selectedCity;
  final ValueChanged<String> onSelected;
  final FormFieldValidator<String> validator;

  @override
  State<WorkerCitySelector> createState() => _WorkerCitySelectorState();
}

class _WorkerCitySelectorState extends State<WorkerCitySelector> {
  static const _cities = <String>[
    'La Paz',
    'El Alto',
    'Cochabamba',
    'Santa Cruz',
    'Sucre',
    'Oruro',
    'Potosí',
    'Tarija',
    'Trinidad',
    'Cobija',
  ];

  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedCity);
  }

  @override
  void didUpdateWidget(covariant WorkerCitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCity != widget.selectedCity) {
      _controller.text = widget.selectedCity;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openPicker() async {
    final city = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CitySearchSheet(
        cities: _cities,
        selectedCity: widget.selectedCity,
      ),
    );
    if (city == null || !mounted) return;
    _controller.text = city;
    widget.onSelected(city);
  }

  @override
  Widget build(BuildContext context) {
    return WorkerTextField(
      label: '¿Ciudad dónde vivís?',
      hintText: 'Seleccioná tu ciudad',
      controller: _controller,
      validator: widget.validator,
      readOnly: true,
      onTap: _openPicker,
      suffixIcon: const Icon(
        PhosphorIconsRegular.caretDown,
        color: AppColors.textSecondary,
        size: 20,
      ),
    );
  }
}

class _CitySearchSheet extends StatefulWidget {
  const _CitySearchSheet({required this.cities, required this.selectedCity});

  final List<String> cities;
  final String selectedCity;

  @override
  State<_CitySearchSheet> createState() => _CitySearchSheetState();
}

class _CitySearchSheetState extends State<_CitySearchSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.cities
        .where((city) => city.toLowerCase().contains(_query.toLowerCase()))
        .toList(growable: false);
    return SafeArea(
      top: false,
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.72,
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Seleccioná tu ciudad',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Buscar ciudad',
                prefixIcon: const Icon(PhosphorIconsRegular.magnifyingGlass),
                filled: true,
                fillColor: AppColors.primarySoft,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final city = filtered[index];
                  final selected = city == widget.selectedCity;
                  return ListTile(
                    onTap: () => Navigator.pop(context, city),
                    leading: const Icon(
                      PhosphorIconsRegular.mapPin,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      city,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight:
                            selected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(
                            PhosphorIconsFill.checkCircle,
                            color: AppColors.primary,
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
