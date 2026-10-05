import 'package:flutter/material.dart';

import '../../features/account/screens/client_account_screen.dart';
import '../../features/auth/screens/account_type_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/categories/models/service_category_detail_arguments.dart';
import '../../features/categories/screens/all_categories_screen.dart';
import '../../features/categories/screens/service_category_detail_screen.dart';
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
import '../../features/service_request/models/create_service_request_arguments.dart';
import '../../features/service_request/models/confirm_service_request_arguments.dart';
import '../../features/service_request/models/nearby_providers_arguments.dart';
import '../../features/service_request/models/searching_providers_arguments.dart';
import '../../features/service_request/screens/confirm_service_request_screen.dart';
import '../../features/service_request/screens/create_service_request_screen.dart';
import '../../features/service_request/screens/nearby_providers_screen.dart';
import '../../features/service_request/screens/searching_providers_screen.dart';
import '../../features/worker_registration/controllers/worker_registration_controller.dart';
import '../../features/worker_registration/screens/worker_basic_data_screen.dart';
import '../../features/worker_registration/screens/worker_confirmation_screen.dart';
import '../../features/worker_registration/screens/worker_contact_screen.dart';
import '../../features/worker_registration/screens/worker_presentation_screen.dart';
import '../../features/worker_registration/screens/worker_services_screen.dart';
import '../../models/user_model.dart';
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
    final authenticatedUser = settings.arguments is UserModel
        ? settings.arguments! as UserModel
        : null;
    final createRequestArguments =
        settings.arguments is CreateServiceRequestArguments
            ? settings.arguments! as CreateServiceRequestArguments
            : null;
    final serviceDetailArguments =
        settings.arguments is ServiceCategoryDetailArguments
            ? settings.arguments! as ServiceCategoryDetailArguments
            : null;
    final confirmRequestArguments =
        settings.arguments is ConfirmServiceRequestArguments
            ? settings.arguments! as ConfirmServiceRequestArguments
            : null;
    final nearbyProvidersArguments =
        settings.arguments is NearbyProvidersArguments
            ? settings.arguments! as NearbyProvidersArguments
            : null;
    final searchingProvidersArguments =
        settings.arguments is SearchingProvidersArguments
            ? settings.arguments! as SearchingProvidersArguments
            : null;
    final Widget screen = switch (settings.name) {
      RouteNames.splash => const SplashScreen(),
      RouteNames.onboarding => const OnboardingScreen(),
      RouteNames.home => HomeScreen(user: authenticatedUser),
      RouteNames.orders => OrdersScreen(user: authenticatedUser),
      RouteNames.accountMenu => ClientAccountScreen(user: authenticatedUser),
      RouteNames.allCategories => AllCategoriesScreen(user: authenticatedUser),
      RouteNames.serviceCategoryDetail => serviceDetailArguments == null
          ? _UnknownRouteScreen(routeName: settings.name)
          : ServiceCategoryDetailScreen(
              serviceId: serviceDetailArguments.serviceId,
              user: serviceDetailArguments.user,
            ),
      RouteNames.createServiceRequest => createRequestArguments == null
          ? _UnknownRouteScreen(routeName: settings.name)
          : CreateServiceRequestScreen(
              serviceId: createRequestArguments.serviceId,
              user: createRequestArguments.user,
            ),
      RouteNames.confirmServiceRequest => confirmRequestArguments == null
          ? _UnknownRouteScreen(routeName: settings.name)
          : ConfirmServiceRequestScreen(
              request: confirmRequestArguments.request,
              serviceName: confirmRequestArguments.serviceName,
              user: confirmRequestArguments.user,
            ),
      RouteNames.nearbyProviders => nearbyProvidersArguments == null
          ? _UnknownRouteScreen(routeName: settings.name)
          : NearbyProvidersScreen(
              request: nearbyProvidersArguments.request,
              serviceName: nearbyProvidersArguments.service.name,
              workers: nearbyProvidersArguments.workers,
              companies: nearbyProvidersArguments.companies,
              user: nearbyProvidersArguments.user,
            ),
      RouteNames.searchingProviders => searchingProvidersArguments == null
          ? _UnknownRouteScreen(routeName: settings.name)
          : SearchingProvidersScreen(
              request: searchingProvidersArguments.request,
              service: searchingProvidersArguments.service,
              user: searchingProvidersArguments.user,
            ),
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
