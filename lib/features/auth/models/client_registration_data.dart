class ClientRegistrationData {
  const ClientRegistrationData({
    this.phoneNumber = '',
    this.email,
    this.password = '',
    this.acceptsTerms = false,
    this.acceptsPrivacyPolicy = false,
  });

  final String phoneNumber;
  final String? email;
  final String password;
  final bool acceptsTerms;
  final bool acceptsPrivacyPolicy;

  ClientRegistrationData copyWith({
    String? phoneNumber,
    String? email,
    bool clearEmail = false,
    String? password,
    bool? acceptsTerms,
    bool? acceptsPrivacyPolicy,
  }) {
    return ClientRegistrationData(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: clearEmail ? null : email ?? this.email,
      password: password ?? this.password,
      acceptsTerms: acceptsTerms ?? this.acceptsTerms,
      acceptsPrivacyPolicy: acceptsPrivacyPolicy ?? this.acceptsPrivacyPolicy,
    );
  }
}
