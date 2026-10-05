import '../../../models/user_model.dart';

class CreateServiceRequestArguments {
  const CreateServiceRequestArguments({
    required this.serviceId,
    this.user,
  });

  final String serviceId;
  final UserModel? user;
}
