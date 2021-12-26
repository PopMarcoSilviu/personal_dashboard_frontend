class User {

   String username;
   String password;
   String lastName;
   String firstName;
   String email;

  User(
      {
        required this.username,
        required this.password,
        required this.lastName,
        required this.firstName,
        required this.email});

  factory User.fromDatabaseJson(Map<String, dynamic> data) => User(

    username: data['username'],
    password: data['password'],
    firstName: data['first_name'],
    lastName: data['last_name'],
    email: data['email'],
  );

  Map<String, dynamic> toDatabaseJson() => {
    "username": username,
    "password": password,
    "first_name": firstName,
    "last_name": lastName,
    "email": email
  };
}