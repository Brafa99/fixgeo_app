import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/config/app_dependencies.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_image_cache.dart';
import '../../../shared/widgets/app_back_button.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_password_field.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/optimized_asset_image.dart';
import '../../../core/enums/user_role.dart';
import '../repositories/auth_repository.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({this.authRepository, super.key});

  final AuthRepository? authRepository;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AuthRepository _authRepository;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? AppDependencies.authRepository;
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authRepository.signIn(
        identifier: _identifierController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;

      final targetRoute = switch (user.role) {
        UserRole.worker => RouteNames.providerHome,
        UserRole.company => RouteNames.companyHome,
        _ => RouteNames.home,
      };

      await Navigator.of(context).pushNamedAndRemoveUntil(
        targetRoute,
        (route) => false,
        arguments: user,
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = AppStrings.unexpectedLoginError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF0F7FF), Colors.white, Color(0xFFFBF6FF)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxHeight < 700;

              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  20,
                  isCompact ? 8 : 16,
                  20,
                  28,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSizes.maxContentWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: _LoginBackButton(),
                        ),
                        SizedBox(height: isCompact ? 8 : 18),
                        _LoginHeader(isCompact: isCompact),
                        SizedBox(height: isCompact ? 20 : 28),
                        _LoginCard(
                          formKey: _formKey,
                          identifierController: _identifierController,
                          passwordController: _passwordController,
                          isLoading: _isLoading,
                          errorMessage: _errorMessage,
                          onSignIn: _signIn,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LoginBackButton extends StatelessWidget {
  const _LoginBackButton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const AppBackButton(fallbackRoute: RouteNames.home),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: isCompact ? 62 : 72,
          height: isCompact ? 62 : 72,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: const [
              BoxShadow(
                color: Color(0x24083B8C),
                blurRadius: 22,
                offset: Offset(0, 9),
              ),
            ],
          ),
          child: const OptimizedAssetImage(
            assetName: AppAssets.logo,
            cacheWidth: AppImageDecodeSize.logo,
          ),
        ),
        const SizedBox(height: AppSizes.spacingMd),
        const Text(
          AppStrings.loginWelcome,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 29,
            fontWeight: FontWeight.w900,
            height: 1.1,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: AppSizes.spacingSm),
        const Text(
          AppStrings.loginDescription,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.formKey,
    required this.identifierController,
    required this.passwordController,
    required this.isLoading,
    required this.onSignIn,
    this.errorMessage,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A083B8C),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: AutofillGroup(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                AppStrings.login,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: identifierController,
                label: AppStrings.identifier,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [
                  AutofillHints.username,
                  AutofillHints.email,
                ],
                prefixIcon: const Icon(Icons.person_outline_rounded),
                validator: (value) => value == null || value.trim().isEmpty
                    ? AppStrings.identifierRequired
                    : null,
              ),
              const SizedBox(height: AppSizes.spacingMd),
              AppPasswordField(
                controller: passwordController,
                label: AppStrings.password,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                validator: (value) => value == null || value.isEmpty
                    ? AppStrings.passwordRequired
                    : null,
                onFieldSubmitted: (_) => onSignIn(),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: AppSizes.spacingMd),
                _LoginError(message: errorMessage!),
              ],
              const SizedBox(height: AppSizes.spacingLg),
              AppButton(
                label: AppStrings.signIn,
                isLoading: isLoading,
                onPressed: onSignIn,
              ),
              const SizedBox(height: 22),
              const _AccountDivider(),
              const SizedBox(height: AppSizes.spacingMd),
              OutlinedButton.icon(
                onPressed: isLoading
                    ? null
                    : () => Navigator.pushNamed(
                          context,
                          RouteNames.accountType,
                        ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
                  side: const BorderSide(
                    color: AppColors.primary,
                    width: 1.4,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 20),
                label: const Text(AppStrings.createAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginError extends StatelessWidget {
  const _LoginError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(color: const Color(0xFFFECACA)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFB91C1C),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Color(0xFF991B1B),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountDivider extends StatelessWidget {
  const _AccountDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            AppStrings.newToFixGeo,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
