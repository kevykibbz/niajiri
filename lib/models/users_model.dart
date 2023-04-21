class UserModel {
  final String? id;
  final String? fullName;
  final String? username;
  final double? rating;
  final double? balance;
  final String? role;
  final String? location;
  final String? photoUri;
  final int? phone;
  final int? idNumber;
  final String email;
  final String? bio;
  final String password;
  final bool? isEmailVerified;
  final bool? isPhoneVerified;
  final bool isBusy;
  final bool? isEmailLinkSent;

  UserModel(
      {this.id,
      this.fullName,
      this.phone,
      this.idNumber,
      this.rating,
      this.balance,
      this.bio,
      this.location,
      this.isEmailVerified,
      this.isPhoneVerified,
      this.isEmailLinkSent,
      this.role,
      this.isBusy=false,
      this.photoUri,
      this.username,
      required this.email,
      required this.password});

  toJson() {
    return {
      "FullName": fullName,
      "UserName": username,
      "IdNumber": idNumber,
      "Location": location,
      "Bio": bio,
      "isEmailLinkSent":isEmailLinkSent,
      "isEmailVerified": isEmailVerified,
      "isPhoneVerified": isPhoneVerified,
      "Rating": rating,
      "Wallet": balance,
      "IsBusy": isBusy,
      "Email": email,
      "Phone": phone,
      "PhotoURI": photoUri,
      "Role": role,
      "Password": password,
    };
  }
}
