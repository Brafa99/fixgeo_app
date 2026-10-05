import '../../../models/service_request_model.dart';
import '../../../models/user_model.dart';

class ConfirmServiceRequestArguments {
  const ConfirmServiceRequestArguments({
    required this.request,
    required this.serviceName,
    this.user,
  });

  final ServiceRequestModel request;
  final String serviceName;
  final UserModel? user;
}
