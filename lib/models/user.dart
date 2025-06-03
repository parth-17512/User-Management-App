import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;
  final String gender; // <--- Add this line

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imageUrl,
    required this.gender, // <--- Add to constructor
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      imageUrl: json['image'], // The API uses 'image' for avatar URL
      gender: json['gender'], // <--- Add this line for parsing
    );
  }

  // Combine first and last name for full name display
  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName, email, imageUrl, gender]; // <--- Add gender to props
}
