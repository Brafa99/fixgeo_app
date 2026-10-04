import 'package:flutter/material.dart';

import '../../features/account/screens/account_menu_screen.dart';
import '../../features/auth/screens/account_type_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/client/screens/client_home_screen.dart';
import '../../features/company/screens/company_home_screen.dart';
import '../../features/company_registration/controllers/company_registration_controller.dart';
import '../../features/company_registration/screens/company_business_data_screen.dart';
import '../../features/company_registration/screens/company_confirmation_screen.dart';
import '../../features/company_registration/screens/company_contact_screen.dart';
import '../../features/company_registration/screens/company_representative_screen.dart';
import '../../features/company_registration/screens/company_services_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../features/provider/screens/provider_home_screen.dart';
import '../../features/register/controllers/register_controller.dart';
import '../../features/register/screens/register_step_one_screen.dart';
import '../../features/register/screens/register_step_three_screen.dart';
import '../../features/register/screens/register_step_two_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/worker_registration/controllers/worker_registration_controller.dart';
import '../../features/worker_registration/screens/worker_basic_data_screen.dart';
import '../../features/worker_registration/screens/worker_confirmation_screen.dart';
import '../../features/worker_registration/screens/worker_contact_screen.dart';
import '../../features/worker_registration/screens/worker_presentation_screen.dart';
import '../../features/worker_registration/screens/worker_services_screen.dart';
import '../constants/app_strings.dart';
import 'route_names.dart';

abstract final class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final registerController = settings.arguments is RegisterController
        ? settings.arguments! as RegisterController
        : null;
    final workerController = settings.arguments is WorkerRegistrationController
        ? settings.arguments! as WorkerRegistrationController
        : null;
    final companyController =
        settings.arguments is CompanyRegistrationController
            ? settings.arguments! as CompanyRegistrationController
            : null;
    final Widget screen = switch (settings.name) {
      RouteNames.splash => const SplashScreen(),
      RouteNames.onboarding => const OnboardingScreen(),
      RouteNames.home => const HomeScreen(),
      RouteNames.orders => const OrdersScreen(),
      RouteNames.accountMenu => const AccountMenuScreen(),
      RouteNames.accountType => const AccountTypeScreen(),
      RouteNames.registerClientPersonal => const RegisterStepOneScreen(),
      RouteNames.registerClientContact =>
        RegisterStepTwoScreen(controller: registerController),
      RouteNames.registerClientAccess =>
        RegisterStepThreeScreen(controller: registerController),
      RouteNames.workerRegisterBasic => const WorkerBasicDataScreen(),
      RouteNames.workerRegisterPresentation =>
        WorkerPresentationScreen(controller: workerController),
      RouteNames.workerRegisterContact =>
        WorkerContactScreen(controller: workerController),
      RouteNames.workerRegisterServices =>
        WorkerServicesScreen(controller: workerController),
      RouteNames.workerRegisterConfirmation =>
        WorkerConfirmationScreen(controller: workerController),
      RouteNames.companyRegisterBusiness => const CompanyBusinessDataScreen(),
      RouteNames.companyRegisterRepresentative =>
        CompanyRepresentativeScreen(controller: companyController),
      RouteNames.companyRegisterContact =>
        CompanyContactScreen(controller: companyController),
      RouteNames.companyRegisterServices =>
        CompanyServicesScreen(controller: companyController),
      RouteNames.companyRegisterConfirmation =>
        CompanyConfirmationScreen(controller: companyController),
      RouteNames.login => const LoginScreen(),
      RouteNames.clientHome => const ClientHomeScreen(),
      RouteNames.providerHome => const ProviderHomeScreen(),
      RouteNames.companyHome => const CompanyHomeScreen(),
      _ => _UnknownRouteScreen(routeName: settings.name),
    };

    return MaterialPageRoute<void>(
      builder: (_) => screen,
      settings: settings,
    );
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen({this.routeName});

  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('${AppStrings.routeNotFound}: ${routeName ?? ''}'),
      ),
    );
  }
}
