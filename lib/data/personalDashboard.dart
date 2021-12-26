class PersonalDashboard {
  int id;
  String name;
  int user;
  String type_of_pd;

  PersonalDashboard({
    required this.id,
    required this.name,
    required this.type_of_pd,
    required this.user,
  });

  factory PersonalDashboard.fromDatabaseJson(Map<String, dynamic> data) =>
      PersonalDashboard(
          id: data['id'],
          name: data['name'],
          user: data['user_id'],
          type_of_pd: data['type_of_pd']);

  Map<String, dynamic> toDatabaseJson() => {
        "id": id,
        "name": name,
        "user": user,
        "type_of_pd": type_of_pd,
      };
}
