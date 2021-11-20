class User {
   int id;
   String username;
   String token;
   String lastName;
   String firstName;
   String email;

  User(
      {required this.id,
        required this.username,
        required this.token,
        required this.lastName,
        required this.firstName,
        required this.email});

  factory User.fromDatabaseJson(Map<String, dynamic> data) => User(
    id: data['id'],
    username: data['username'],
    token: data['token'],
    firstName: data['first_name'],
    lastName: data['last_name'],
    email: data['email'],
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": id,
    "username": username,
    "token": token,
    "first_name": firstName,
    "last_name": lastName,
    "email": email
  };
}