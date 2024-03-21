class Users {
  static String firstname = "";
  static String middlename = "";
  static String lastname = "";
  static String address = "";
  static String email = "";
  static String cpnumber = "";
  static String username = "";

  void SetInformation(
      firstName, middleName, lastName, address, email, cpNumber, username) {
    Users.firstname = firstName;
    Users.middlename = middleName;
    Users.lastname = lastName;
    Users.address = address;
    Users.email = email;
    Users.cpnumber = cpNumber;
    Users.username = username;
  }

  String getFirstName() {
    return firstname;
  }

  String getMiddleName() {
    return middlename;
  }

  String getLastName() {
    return lastname;
  }

  String getAddress() {
    return address;
  }

  String getEmail() {
    return email;
  }

  String getCPNumber() {
    return cpnumber;
  }

  String getUsername() {
    return username;
  }

  void clearInformation() {
    Users.firstname = "";
    Users.middlename = "";
    Users.lastname = "";
    Users.email = "";
    Users.cpnumber = "";
    Users.username = "";
  }
}
