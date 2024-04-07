class User {
  int? id;
  String? name;
  String? email;
  String? studentId;
  String? password;
  String? level;
  String? gender; // New attribute

  User({
    this.id,
    this.name,
    this.email,
    this.studentId,
    this.password,
    this.level,
    this.gender, // Include gender attribute
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'studentId': studentId,
      'password': password,
      'level': level,
      'gender': gender, // Include gender in the map
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
      level: map['level'],
      gender: map['gender'], // Assign gender from the map
    );
  }
}
