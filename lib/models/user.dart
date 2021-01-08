class User {
  int userid;
  String firstname;
  String lastname;
  String email;
  String phone;
  String avatar;
  String description;

  User(
      this.userid,
      this.firstname,
      this.lastname,
      this.email,
      this.phone,
      this.avatar,
      this.description);

  Map<String, dynamic> toMap() {
    return {
      'userid': this.userid,
      'firstname': this.firstname,
      'lastname': this.lastname,
      'email': this.email,
      'phone': this.phone,
      'avatar': this.avatar,
      'description': this.description,
    };
  }
}
