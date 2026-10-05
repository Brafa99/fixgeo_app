import '../../../models/user_model.dart';

class ServiceCategoryDetailArguments {
  const ServiceCategoryDetailArguments({
    required this.serviceId,
    this.user,
  });

  final String serviceId;
  final UserModel? user;
}
