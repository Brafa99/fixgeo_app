import 'package:flutter/material.dart';

import '../../../core/config/app_dependencies.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../models/user_model.dart';
import '../../../services/client_service.dart';
import '../../../services/request_service.dart';
import '../../../services/service_service.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../controllers/create_service_request_controller.dart';
import '../models/confirm_service_request_arguments.dart';
import '../services/service_request_image_picker.dart';
import '../widgets/mock_location_map.dart';
import '../widgets/request_location_card.dart';
import '../widgets/request_photo_picker.dart';
import '../widgets/request_flow_progress.dart';
import '../widgets/request_primary_button.dart';

class CreateServiceRequestScreen extends StatefulWidget {
  const CreateServiceRequestScreen({
    required this.serviceId,
    this.user,
    this.serviceService,
    this.clientService,
    this.requestService,
    this.imagePicker,
    this.clock,
    super.key,
  });

  final String serviceId;
  final UserModel? user;
  final ServiceService? serviceService;
  final ClientService? clientService;
  final RequestService? requestService;
  final ServiceRequestImagePicker? imagePicker;
  final DateTime Function()? clock;

  @override
  State<CreateServiceRequestScreen> createState() =>
      _CreateServiceRequestScreenState();
}

class _CreateServiceRequestScreenState
    extends State<CreateServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  late final CreateServiceRequestController _controller;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controller = CreateServiceRequestController(
      serviceId: widget.serviceId,
      user: widget.user,
      serviceService: widget.serviceService ?? AppDependencies.serviceService,
      clientService: widget.clientService ?? AppDependencies.clientService,
      requestService: widget.requestService ?? AppDependencies.requestService,
      imagePicker: widget.imagePicker ?? LocalServiceRequestImagePicker(),
      clock: widget.clock,
    );
    _controller.initialize();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goBack() async {
    if (_currentStep == 1) {
      setState(() => _currentStep = 0);
      return;
    }
    final navigator = Navigator.of(context);
    if (await navigator.maybePop()) return;
    if (mounted) {
      await navigator.pushReplacementNamed(
        RouteNames.home,
        arguments: widget.user,
      );
    }
  }

  Future<void> _continue() async {
    if (_currentStep == 0) {
      if (!(_formKey.currentState?.validate() ?? false)) return;
      setState(() => _currentStep = 1);
      return;
    }
    final request = await _controller.submit();
    if (!mounted) return;
    if (request == null) {
      final message = _controller.actionError;
      if (message != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
      return;
    }
    await Navigator.of(context).pushNamed(
      RouteNames.confirmServiceRequest,
      arguments: ConfirmServiceRequestArguments(
        request: request,
        serviceName: _controller.service!.name,
        user: widget.user,
      ),
    );
    if (mounted) {
      setState(() => _currentStep = 0);
    }
  }

  Future<void> _showPhotoSourcePicker() async {
    final source = await showModalBottomSheet<ServiceRequestImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                AppStrings.addPhotos,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Elegir de la galería'),
                onTap: () => Navigator.pop(
                  context,
                  ServiceRequestImageSource.gallery,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Tomar una foto'),
                onTap: () => Navigator.pop(
                  context,
                  ServiceRequestImageSource.camera,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (source != null) await _controller.addImages(source);
  }

  Future<void> _changeLocation() async {
    final addressController = TextEditingController(text: _controller.address);
    final address = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.changeLocation),
        content: TextField(
          key: const ValueKey('request-location-field'),
          controller: addressController,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Dirección',
            hintText: 'Ej. Sopocachi, La Paz',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, addressController.text),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    addressController.dispose();
    if (address != null && address.trim().isNotEmpty) {
      _controller.updateLocation(address: address);
    }
  }

  Future<void> _chooseDate() async {
    _controller.setScheduleOption(ServiceScheduleOption.chooseDate);
    final now = widget.clock?.call() ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentDate = _controller.scheduledDate;
    final initialDate = currentDate != null && !currentDate.isBefore(today)
        ? currentDate
        : today;
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: DateTime(today.year + 1, today.month, today.day),
      helpText: AppStrings.whenDoYouNeedIt,
      cancelText: 'Cancelar',
      confirmText: 'Elegir',
    );
    if (selected != null) _controller.setScheduledDate(selected);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final serviceName = _controller.service?.name;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              onPressed: _goBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: Text(
              _currentStep == 0
                  ? serviceName == null
                      ? AppStrings.requestService
                      : '${AppStrings.requestService} ($serviceName)'
                  : 'Ubicación y fecha',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(child: _buildBody()),
          bottomNavigationBar: _buildBottomAction(),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const LoadingIndicator(message: 'Cargando solicitud...');
    }
    if (_controller.loadError != null) {
      return _RequestLoadMessage(
        message: _controller.loadError!,
        onRetry: _controller.initialize,
      );
    }
    if (!_controller.hasValidService) {
      return const _RequestLoadMessage(
        message: 'El servicio seleccionado no está disponible.',
      );
    }

    return _currentStep == 0 ? _buildDetailsStep() : _buildLocationStep();
  }

  Widget _buildDetailsStep() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
            children: [
              const RequestFlowProgress(currentStep: 1),
              const SizedBox(height: 22),
              const Text(
                'Detalla tu pedido',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              const _SectionTitle(title: AppStrings.whatDoYouNeed),
              const SizedBox(height: 10),
              TextFormField(
                key: const ValueKey('request-description-field'),
                controller: _descriptionController,
                minLines: 5,
                maxLines: 7,
                maxLength:
                    CreateServiceRequestController.descriptionMaxLength,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _controller.validateDescription,
                onChanged: _controller.updateDescription,
                decoration: const InputDecoration(
                  hintText: AppStrings.requestDescriptionHint,
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'Agregar fotos (opcional)'),
              const SizedBox(height: 6),
              const Text(
                AppStrings.addPhotosHelp,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              RequestPhotoPicker(
                imagePaths: _controller.images,
                isLoading: _controller.isPickingImages,
                canAddMore: _controller.images.length <
                    CreateServiceRequestController.maxImages,
                onAdd: _showPhotoSourcePicker,
                onRemove: _controller.removeImage,
              ),
              const SizedBox(height: 26),
              _LocationTextField(
                label: 'Ciudad',
                value: _cityFromAddress(_controller.address),
                suffixIcon: Icons.keyboard_arrow_down_rounded,
                onTap: _changeLocation,
              ),
              const SizedBox(height: 14),
              _LocationTextField(
                label: 'Barrio (opcional)',
                value: _controller.locationSummary,
                onTap: _changeLocation,
              ),
              if (_controller.actionError != null) ...[
                const SizedBox(height: 12),
                Text(
                  _controller.actionError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationStep() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          children: [
            const RequestFlowProgress(currentStep: 2),
            const SizedBox(height: 18),
            MockLocationMap(
              neighborhood: _controller.locationSummary,
              onLocate: _useCurrentLocation,
            ),
            const SizedBox(height: 18),
            const _SectionTitle(title: 'Dirección'),
            const SizedBox(height: 9),
            RequestLocationCard(
              address: _controller.address,
              onChange: _changeLocation,
            ),
            const SizedBox(height: 24),
            const _SectionTitle(title: AppStrings.whenDoYouNeedIt),
            const SizedBox(height: 10),
            _ScheduleOptionTile(
              key: const ValueKey('schedule-asap'),
              label: AppStrings.asSoonAsPossible,
              leadingIcon: Icons.bolt_rounded,
              selected: _controller.scheduleOption ==
                  ServiceScheduleOption.asSoonAsPossible,
              onTap: () => _controller.setScheduleOption(
                ServiceScheduleOption.asSoonAsPossible,
              ),
            ),
            const SizedBox(height: 10),
            _ScheduleOptionTile(
              key: const ValueKey('schedule-date'),
              label: AppStrings.chooseDate,
              leadingIcon: Icons.calendar_month_outlined,
              detail:
                  _controller.scheduleOption == ServiceScheduleOption.chooseDate
                      ? _controller.dateSummary
                      : null,
              selected: _controller.scheduleOption ==
                  ServiceScheduleOption.chooseDate,
              onTap: _chooseDate,
            ),
          ],
        ),
      ),
    );
  }

  String _cityFromAddress(String address) {
    final parts = address.split(',');
    return parts.isEmpty || parts.last.trim().isEmpty
        ? 'La Paz'
        : parts.last.trim();
  }

  void _useCurrentLocation() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Ubicación actual seleccionada.')),
      );
  }

  Widget? _buildBottomAction() {
    if (_controller.isLoading || !_controller.hasValidService) return null;
    return SafeArea(
      top: false,
      child: Container(
        key: const ValueKey('request-bottom-action'),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
          boxShadow: AppShadows.card,
        ),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: RequestPrimaryButton(
              label: AppStrings.continueLabel,
              isLoading: _controller.isSubmitting,
              onPressed: _canContinueCurrentStep ? _continue : null,
            ),
          ),
        ),
      ),
    );
  }

  bool get _canContinueCurrentStep {
    if (_currentStep == 0) {
      return _controller.hasValidService &&
          _controller.validateDescription(_controller.description) == null;
    }
    return _controller.canContinue;
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _ScheduleOptionTile extends StatelessWidget {
  const _ScheduleOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.leadingIcon,
    this.detail,
    super.key,
  });

  final String label;
  final String? detail;
  final bool selected;
  final VoidCallback onTap;
  final IconData leadingIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primarySoft : AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                leadingIcon,
                color: selected ? AppColors.cyan : AppColors.textSecondary,
              ),
              const SizedBox(width: 10),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color:
                    selected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (detail != null)
                Text(
                  detail!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationTextField extends StatelessWidget {
  const _LocationTextField({
    required this.label,
    required this.value,
    this.suffixIcon,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData? suffixIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 7),
        Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (suffixIcon != null)
                    Icon(suffixIcon, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RequestLoadMessage extends StatelessWidget {
  const _RequestLoadMessage({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(AppStrings.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
