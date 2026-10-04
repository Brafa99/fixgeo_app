class WorkerRegistrationData {
  const WorkerRegistrationData({
    this.firstName = '',
    this.lastName = '',
    this.document = '',
    this.city = '',
    this.imagePath,
    this.imageUrl,
    this.presentation = '',
    this.countryCode = '+591',
    this.phone = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.categories = const [],
    this.acceptedTerms = false,
  });

  final String firstName;
  final String lastName;
  final String document;
  final String city;
  final String? imagePath;
  final String? imageUrl;
  final String presentation;
  final String countryCode;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;
  final List<String> categories;
  final bool acceptedTerms;

  WorkerRegistrationData copyWith({
    String? firstName,
    String? lastName,
    String? document,
    String? city,
    String? imagePath,
    bool clearImagePath = false,
    String? imageUrl,
    String? presentation,
    String? countryCode,
    String? phone,
    String? email,
    String? password,
    String? confirmPassword,
    List<String>? categories,
    bool? acceptedTerms,
  }) {
    return WorkerRegistrationData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      document: document ?? this.document,
      city: city ?? this.city,
      imagePath: clearImagePath ? null : imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      presentation: presentation ?? this.presentation,
      countryCode: countryCode ?? this.countryCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      categories: categories ?? this.categories,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
    );
  }
}
