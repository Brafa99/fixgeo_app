class CompanyRegistrationData {
  const CompanyRegistrationData({
    this.companyName = '',
    this.presentation = '',
    this.logoPath,
    this.logoUrl,
    this.representativeName = '',
    this.representativeLastName = '',
    this.document = '',
    this.city = '',
    this.countryCode = '+591',
    this.phone = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.services = const [],
    this.acceptedTerms = false,
  });

  final String companyName;
  final String presentation;
  final String? logoPath;
  final String? logoUrl;
  final String representativeName;
  final String representativeLastName;
  final String document;
  final String city;
  final String countryCode;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;
  final List<String> services;
  final bool acceptedTerms;

  CompanyRegistrationData copyWith({
    String? companyName,
    String? presentation,
    String? logoPath,
    bool clearLogoPath = false,
    String? logoUrl,
    String? representativeName,
    String? representativeLastName,
    String? document,
    String? city,
    String? countryCode,
    String? phone,
    String? email,
    String? password,
    String? confirmPassword,
    List<String>? services,
    bool? acceptedTerms,
  }) {
    return CompanyRegistrationData(
      companyName: companyName ?? this.companyName,
      presentation: presentation ?? this.presentation,
      logoPath: clearLogoPath ? null : logoPath ?? this.logoPath,
      logoUrl: logoUrl ?? this.logoUrl,
      representativeName: representativeName ?? this.representativeName,
      representativeLastName:
          representativeLastName ?? this.representativeLastName,
      document: document ?? this.document,
      city: city ?? this.city,
      countryCode: countryCode ?? this.countryCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      services: services ?? this.services,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
    );
  }
}
