import '../../../core/enums/provider_type.dart';
import '../../../models/user_model.dart';

class ProviderDetailArguments {
  const ProviderDetailArguments({
    required this.providerId,
    required this.providerType,
    required this.requestId,
    this.user,
  });

  final String providerId;
  final ProviderType providerType;
  final String requestId;
  final UserModel? user;
}
