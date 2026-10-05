import '../../../models/service_model.dart';
import '../../../models/service_request_model.dart';
import '../../../models/user_model.dart';

class SearchingProvidersArguments {
  const SearchingProvidersArguments({
    required this.request,
    required this.service,
    this.user,
  });

  final ServiceRequestModel request;
  final ServiceModel service;
  final UserModel? user;
}
