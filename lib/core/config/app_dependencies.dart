import '../../data/mock/repositories/mock_company_repository.dart';
import '../../data/mock/repositories/mock_client_repository.dart';
import '../../data/mock/repositories/mock_service_request_repository.dart';
import '../../data/mock/repositories/mock_review_repository.dart';
import '../../data/mock/services/mock_auth_service.dart';
import '../../data/mock/repositories/mock_service_repository.dart';
import '../../data/mock/repositories/mock_worker_repository.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../services/company_service.dart';
import '../../services/client_service.dart';
import '../../services/request_service.dart';
import '../../services/review_service.dart';
import '../../services/service_service.dart';
import '../../services/worker_service.dart';

abstract final class AppDependencies {
  static final AuthRepository authRepository = AuthRepository(
    MockAuthService(),
  );

  static final ServiceService serviceService = ServiceService(
    MockServiceRepository(),
  );

  static final WorkerService workerService = WorkerService(
    MockWorkerRepository(),
  );

  static final CompanyService companyService = CompanyService(
    MockCompanyRepository(),
  );

  static final ClientService clientService = ClientService(
    MockClientRepository(),
  );

  static final RequestService requestService = RequestService(
    MockServiceRequestRepository(),
  );

  static final ReviewService reviewService = ReviewService(
    MockReviewRepository(),
  );
}
