

class user {
  int id;
  String username;
  String password;
  String role;

  user(this.id, this.username, this.password, this.role);

  user.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        password = json['password'],
        role = json['role'];


  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'username': username,
        'password': password,
        'role': role,
      };
}
