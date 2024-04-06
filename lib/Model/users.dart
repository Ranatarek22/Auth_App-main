class User {
  int? id;
  String? name;
  String? email;
  String? studentId;
  String? password;

  User({this.id, this.name, this.email, this.studentId, this.password});

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'studentId': studentId,
      'password': password,
    };
  }

  // Convert a Map object into a User object
  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      studentId: map['studentId'],
      password: map['password'],
    );
  }
}
