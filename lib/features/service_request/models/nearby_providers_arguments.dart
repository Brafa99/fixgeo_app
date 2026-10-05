import '../../../models/company_model.dart';
import '../../../models/service_model.dart';
import '../../../models/service_request_model.dart';
import '../../../models/user_model.dart';
import '../../../models/worker_model.dart';

class NearbyProvidersArguments {
  const NearbyProvidersArguments({
    required this.request,
    required this.service,
    required this.workers,
    required this.companies,
    this.user,
  });

  final ServiceRequestModel request;
  final ServiceModel service;
  final List<WorkerModel> workers;
  final List<CompanyModel> companies;
  final UserModel? user;
}
