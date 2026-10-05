import '../../../models/service_request_model.dart';
import '../../../models/user_model.dart';

class RequestSentArguments {
  const RequestSentArguments({
    required this.request,
    required this.providerName,
    this.user,
  });

  final ServiceRequestModel request;
  final String providerName;
  final UserModel? user;
}
