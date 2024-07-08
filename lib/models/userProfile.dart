class UserProfile {
  String? id;
  String? Name;

  String? email;
  String? phoneNumber;
  String? dateofBirth;
  String? image;
  String? userId;

  UserProfile({
    this.id,
    this.Name,
    this.email,
    this.phoneNumber,
    this.dateofBirth,
    this.image,
    this.userId,
  });

  UserProfile copyWith({
    String? id,
    String? Name,
    String? email,
    String? phoneNumber,
    String? dateOfBirth,
    String? image,
    String? userId,
  }) {
    return UserProfile(
      id: id ?? this.id,
      Name: Name ?? this.Name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      image: image ?? this.image,
      userId: userId ?? this.userId,
    );
  }
}
