class Worker {
  final String id;
  final String name;
  final String phone;
  final String role;
  final String? profileImageUrl;
  final String payType;
  final String wageAmount;
  final String idProofType;
  final String idProofNumber;
  final String state;
  final String city;

  Worker({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.profileImageUrl,
    required this.payType,
    required this.wageAmount,
    required this.idProofType,
    required this.idProofNumber,
    this.state = '',
    this.city = '',
  });

  Worker copyWith({
    String? name,
    String? phone,
    String? role,
    String? profileImageUrl,
    String? payType,
    String? wageAmount,
    String? idProofType,
    String? idProofNumber,
    String? state,
    String? city,
  }) {
    return Worker(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      payType: payType ?? this.payType,
      wageAmount: wageAmount ?? this.wageAmount,
      idProofType: idProofType ?? this.idProofType,
      idProofNumber: idProofNumber ?? this.idProofNumber,
      state: state ?? this.state,
      city: city ?? this.city,
    );
  }
}
