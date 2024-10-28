class Auth {
  int? id;
  String? name;
  String? email;
  String? password;
  String? avatar;
  String? token;

  // Constructor
  Auth(
      {this.id, this.name, this.email, this.password, this.avatar, this.token});

  // Named constructor to initialize from JSON
  Auth.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        password = json['password'],
        avatar = json['avatar'],
        token = json['token'];

  Map<String, dynamic> toJson() {
    return {
      'id': id?.toString(),
      'name': name,
      'email': email,
      'password': password,
      'avatar': avatar,
    };
  }
}

class Registration {
  String? name;
  String? email;
  String? password;

  // Constructor
  Registration({this.name, this.email, this.password});

  // Named constructor to initialize from JSON
  Registration.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
