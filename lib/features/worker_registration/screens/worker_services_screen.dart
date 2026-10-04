import 'package:flutter/material.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/worker_registration_controller.dart';
import '../models/service_category.dart';
import '../widgets/category_card.dart';
import '../widgets/help_icon_button.dart';
import '../widgets/primary_bottom_button.dart';
import '../widgets/worker_registration_layout.dart';
import '../widgets/worker_step_intro.dart';

class WorkerServicesScreen extends StatefulWidget {
  const WorkerServicesScreen({this.controller, super.key});

  final WorkerRegistrationController? controller;

  @override
  State<WorkerServicesScreen> createState() => _WorkerServicesScreenState();
}

class _WorkerServicesScreenState extends State<WorkerServicesScreen> {
  late final WorkerRegistrationController _controller;
  late final bool _ownsController;
  String? _selectionError;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? WorkerRegistrationController();
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _toggleCategory(String categoryId) {
    _controller.toggleCategory(categoryId);
    if (_controller.data.categories.isNotEmpty && _selectionError != null) {
      setState(() => _selectionError = null);
    }
  }

  void _continue() {
    if (_controller.data.categories.isEmpty) {
      setState(() => _selectionError = 'Elegí al menos un servicio.');
      return;
    }
    Navigator.pushNamed(
      context,
      RouteNames.workerRegisterConfirmation,
      arguments: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => WorkerRegistrationLayout(
        currentStep: 4,
        contentPadding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
        bottomButton: WorkerPrimaryButton(
          label: 'Siguiente',
          onPressed: _continue,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: WorkerStepIntro(
                title: '¿Qué servicios ofrecés?',
                description:
                    'Podés seleccionar varias categorías. Elegí todas las que '
                    'representen tu trabajo.',
                helpButton: WorkerHelpButton(
                  message:
                      'Estas categorías ayudan a que los clientes te encuentren '
                      'cuando publican un pedido relacionado.',
                ),
              ),
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_controller.data.categories.length} '
                  '${_controller.data.categories.length == 1 ? 'seleccionado' : 'seleccionados'}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
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
                  itemCount: WorkerServiceCategories.all.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: columns == 1 ? 1.35 : 0.96,
                  ),
                  itemBuilder: (context, index) {
                    final category = WorkerServiceCategories.all[index];
                    return WorkerCategoryCard(
                      category: category,
                      isSelected: _controller.data.categories.contains(
                        category.id,
                      ),
                      onTap: () => _toggleCategory(category.id),
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
