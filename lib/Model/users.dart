class UserData {
  String? id;
  String? name;
  String? email;
  String? studentId;
  String? password;
  String? level;
  String? gender;
  String? imagePath;

  UserData({
    this.id,
    this.name,
    this.email,
    this.studentId,
    this.password,
    this.level,
    this.gender,
    this.imagePath,
  });

  // Setter method to dynamically set the image path
  void setImagePath(String path) {
    imagePath = path;
  }

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'studentId': studentId,
      'password': password,
      'level': level,
      'gender': gender,
      'imagePath': imagePath,
    };
  }

  // Convert a Map object into a User object
  static UserData fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      studentId: map['studentId'],
      password: map['password'],
      level: map['level'],
      gender: map['gender'],
      imagePath: map['imagePath'],
    );
  }
}
