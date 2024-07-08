import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skardubazar/models/userProfile.dart';
import 'package:skardubazar/utils/flutter_toast.dart';

class SessionController {
  static final SessionController _session = SessionController._internal();

  String? userId;
  String? userName;
  String? userEmail;
  String? phoneNumber;
  String? image;
 

  factory SessionController() {
    return _session;
  }

  SessionController._internal();

  Future<void> fetchUserInfo(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        userName = userDoc['Name'];
        userEmail = userDoc['email'];
        phoneNumber = userDoc['phoneNumber'];
        image = userDoc['image'];
       
      }
    } catch (error) {
      print('Error fetching user information: $error');
    }
    
  }

  Future<void> updateUserInfo(UserProfile updatedProfile) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'Name': updatedProfile.Name,
       
        'email': updatedProfile.email,
        'phoneNumber': updatedProfile.phoneNumber,
        'image': updatedProfile.image,
        'dateofBirth': updatedProfile.dateofBirth,
      });

      userName = updatedProfile.Name;
      userEmail = updatedProfile.email;
      phoneNumber = updatedProfile.phoneNumber;
      image = updatedProfile.image;
    
    } catch (error) {
      Utils().toastMessage('Error updating user information: $error');
    }
  }

  void addListener(void Function() updateUserId) {}

  void removeListener(void Function() updateUserId) {}
}
