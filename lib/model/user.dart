class UserAccount {
  String uiid;
  String email;
  String phonenumber;
  String displayname;
  String password;
  UserAccount(
      this.uiid, this.email, this.phonenumber, this.password, this.displayname);

  Map<String, dynamic> createMap() {
    return {
      'uid': uiid,
      'email': email,
      'phone': phonenumber,
      'displayname': displayname
    };
  }

  // UserAccount.fromFirestore(Map<String, dynamic> firestoreMap)
  //     : productId = firestoreMap['productId'],
  //       productName = firestoreMap['productName'],
  //       price = firestoreMap['productPrice'];
}
