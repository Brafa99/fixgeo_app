import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/register_controller.dart';
import '../controllers/register_validators.dart';
import '../widgets/register_page_layout.dart';
import '../widgets/register_primary_button.dart';
import '../widgets/register_step_intro.dart';
import '../widgets/register_text_field.dart';

class RegisterStepOneScreen extends StatefulWidget {
  const RegisterStepOneScreen({this.controller, super.key});

  final RegisterController? controller;

  @override
  State<RegisterStepOneScreen> createState() => _RegisterStepOneScreenState();
}

class _RegisterStepOneScreenState extends State<RegisterStepOneScreen> {
  static const _cities = <String>[
    'La Paz',
    'El Alto',
    'Cochabamba',
    'Santa Cruz',
    'Sucre',
    'Tarija',
    'Oruro',
    'Potosí',
    'Trinidad',
  ];

  final _formKey = GlobalKey<FormState>();
  late final RegisterController _controller;
  late final bool _ownsController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? RegisterController();
    _firstNameController = TextEditingController(
      text: _controller.data.firstName,
    );
    _lastNameController = TextEditingController(
      text: _controller.data.lastName,
    );
    _cityController = TextEditingController(text: _controller.data.city);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cityController.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  Future<void> _selectCity() async {
    final selectedCity = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CityPicker(
        cities: _cities,
        selectedCity: _cityController.text,
      ),
    );
    if (selectedCity == null || !mounted) return;
    setState(() => _cityController.text = selectedCity);
    _controller.updatePersonalData(city: selectedCity);
    _formKey.currentState?.validate();
  }

  void _continue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _controller.updatePersonalData(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      city: _cityController.text,
    );
    Navigator.pushNamed(
      context,
      RouteNames.registerClientContact,
      arguments: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RegisterPageLayout(
      currentStep: 1,
      bottomButton: RegisterPrimaryButton(
        label: 'Siguiente',
        onPressed: _continue,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RegisterStepIntro(
              title: 'Datos personales',
              description: 'Contanos quién sos y dónde necesitás ayuda.',
            ),
            const SizedBox(height: 28),
            RegisterTextField(
              label: 'Nombre',
              hintText: 'Ej: Juan',
              controller: _firstNameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.givenName],
              validator: (value) =>
                  RegisterValidators.requiredText(value, 'El nombre'),
              onChanged: (value) =>
                  _controller.updatePersonalData(firstName: value),
            ),
            const SizedBox(height: 20),
            RegisterTextField(
              label: 'Apellido',
              hintText: 'Ej: González',
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.familyName],
              validator: (value) =>
                  RegisterValidators.requiredText(value, 'El apellido'),
              onChanged: (value) =>
                  _controller.updatePersonalData(lastName: value),
            ),
            const SizedBox(height: 20),
            RegisterTextField(
              label: '¿Ciudad dónde vivís?',
              hintText: 'Seleccioná tu ciudad',
              controller: _cityController,
              readOnly: true,
              onTap: _selectCity,
              validator: (value) =>
                  RegisterValidators.requiredText(value, 'La ciudad'),
              suffixIcon: const Icon(
                PhosphorIconsRegular.caretDown,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CityPicker extends StatelessWidget {
  const _CityPicker({required this.cities, required this.selectedCity});

  final List<String> cities;
  final String selectedCity;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.72,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 18, 22, 12),
              child: Align(
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
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  final selected = city == selectedCity;
                  return ListTile(
                    onTap: () => Navigator.pop(context, city),
                    leading: const Icon(
                      PhosphorIconsRegular.mapPin,
                      color: AppColors.blue,
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
                            color: AppColors.success,
                          )
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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
