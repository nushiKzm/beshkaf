class UserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String mobile;
  final String address;
  final String postalCode;
  final int overallHeight;
  final int size;

  UserEntity(
    this.id,
    this.firstName,
    this.lastName,
    this.mobile,
    this.address,
    this.postalCode,
    this.overallHeight,
    this.size,
  );

  UserEntity.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        mobile = json['mobile'],
        address = json['address'],
        postalCode = json['postal_code'],
        overallHeight = json['overall_height'],
        size = json['size'];
}
