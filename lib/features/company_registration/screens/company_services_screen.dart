import 'package:flutter/material.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/company_registration_controller.dart';
import '../models/service_category.dart';
import '../widgets/help_icon_button.dart';
import '../widgets/primary_bottom_button.dart';
import '../widgets/registration_layout.dart';
import '../widgets/registration_step_intro.dart';
import '../widgets/service_category_card.dart';

class CompanyServicesScreen extends StatefulWidget {
  const CompanyServicesScreen({this.controller, super.key});

  final CompanyRegistrationController? controller;

  @override
  State<CompanyServicesScreen> createState() => _CompanyServicesScreenState();
}

class _CompanyServicesScreenState extends State<CompanyServicesScreen> {
  late final CompanyRegistrationController _controller;
  late final bool _ownsController;
  String? _selectionError;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? CompanyRegistrationController();
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _toggleService(String serviceId) {
    _controller.toggleService(serviceId);
    if (_controller.data.services.isNotEmpty && _selectionError != null) {
      setState(() => _selectionError = null);
    }
  }

  void _continue() {
    if (_controller.data.services.isEmpty) {
      setState(() {
        _selectionError = 'Selecciona al menos un servicio.';
      });
      return;
    }
    Navigator.pushNamed(
      context,
      RouteNames.companyRegisterConfirmation,
      arguments: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CompanyRegistrationLayout(
        currentStep: 4,
        contentPadding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
        bottomButton: CompanyPrimaryButton(
          label: 'Siguiente',
          onPressed: _continue,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: CompanyStepIntro(
                title: 'Servicios de tu empresa',
                description:
                    'Elegí las categorías en las que tu empresa puede ayudar '
                    'a la comunidad.',
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Podés seleccionar varias',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.purpleSoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_controller.data.services.length} '
                      '${_controller.data.services.length == 1 ? 'seleccionado' : 'seleccionados'}',
                      style: const TextStyle(
                        color: AppColors.purple,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const CompanyHelpButton(
                    message:
                        'Selecciona todos los servicios que actualmente ofrece '
                        'tu empresa.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth < 280
                    ? 1
                    : constraints.maxWidth < 430
                        ? 2
                        : 3;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: CompanyServiceCategories.all.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: columns == 1 ? 1.35 : 0.96,
                  ),
                  itemBuilder: (context, index) {
                    final category = CompanyServiceCategories.all[index];
                    return CompanyServiceCategoryCard(
                      category: category,
                      isSelected:
                          _controller.data.services.contains(category.id),
                      onTap: () => _toggleService(category.id),
                    );
                  },
                );
              },
            ),
            if (_selectionError != null) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  _selectionError!,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
