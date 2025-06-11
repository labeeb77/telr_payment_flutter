/// Billing information for the payment
class BillingInfo {
  /// Customer title (Mr, Mrs, Ms, etc.)
  final String title;
  
  /// Customer first name
  final String firstName;
  
  /// Customer last name
  final String lastName;
  
  /// Billing address line 1
  final String addressLine1;
  
  /// City
  final String city;
  
  /// State/Region
  final String region;
  
  /// Country code (2-letter ISO code)
  final String country;
  
  /// ZIP/Postal code
  final String zipCode;
  
  /// Phone number
  final String phone;
  
  /// Email address
  final String email;

  const BillingInfo({
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.addressLine1,
    required this.city,
    required this.region,
    required this.country,
    required this.zipCode,
    required this.phone,
    required this.email,
  });

  /// Creates a copy of this BillingInfo with the given fields replaced
  BillingInfo copyWith({
    String? title,
    String? firstName,
    String? lastName,
    String? addressLine1,
    String? city,
    String? region,
    String? country,
    String? zipCode,
    String? phone,
    String? email,
  }) {
    return BillingInfo(
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      addressLine1: addressLine1 ?? this.addressLine1,
      city: city ?? this.city,
      region: region ?? this.region,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  /// Full name getter
  String get fullName => '$firstName $lastName';

  @override
  String toString() {
    return 'BillingInfo(name: $fullName, email: $email, country: $country)';
  }
}