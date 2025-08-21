class UserProfile {
  final String id, name, phone;
  final List<String> address;

  UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      address:
          (map['address'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phone': phone, 'address': address};
  }

  UserProfile copyWith({String? name, String? phone, List<String>? address}) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}
