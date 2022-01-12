// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socceirb/screens/Profile/components/user.dart';

class ProfilePicture extends StatefulWidget {
  ProfilePicture({
    Key? key,
    required this.myAppUser,
    required this.otherProfile,
  }) : super(key: key);

  final User myAppUser;
  final bool otherProfile;

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File? profilePic;
  final user = auth.FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final uid = auth.FirebaseAuth.instance.currentUser!.uid;

  void _uploadImage() async {
    final _picker = ImagePicker();
    var _pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (_pickedImage != null) profilePic = File(_pickedImage.path);
      uploadToFirebase();
    });
  }

  Future<String> uploadFile(File image) async {
    String downloadURL;
    String postId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("images")
        .child("post_$postId.jpg");
    await ref.putFile(image);
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  uploadToFirebase() async {
    String url = await uploadFile(profilePic!);
    await users.doc(uid).set(
      {
        'Profile Picture': url,
      },
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.purple,
      ),
      //margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.03),
      child: !widget.otherProfile
          ? Stack(
              children: [
                circleArea(),
                littleIcon(),
              ],
            )
          : circleArea(),
    );
  }

  Positioned littleIcon() {
    return Positioned(
      right: 4,
      bottom: 4,
      child: InkWell(
        onTap: _uploadImage,
        child: Container(
          height: 25,
          width: 25,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kGoldenColor,
          ),
          child: Icon(
            Icons.camera_alt_outlined,
            color: kBaseColor,
            size: 18,
          ),
        ),
      ),
    );
  }

  CircleAvatar circleArea() {
    var profileImage = widget.myAppUser.profilePic ?? '';
    return CircleAvatar(
      radius: SizeConfig.screenWidth * 0.15,
      backgroundColor: kGoldenColor,
      child: CircleAvatar(
        radius: SizeConfig.screenWidth * 0.15 - 3,
        backgroundColor: Colors.transparent,
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: profilePic == null
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          alignment: FractionalOffset.topCenter,
                          image: profileImage == ''
                              ? AssetImage('assets/images/profile.png')
                                  as ImageProvider
                              : NetworkImage(profileImage)),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: FractionalOffset.topCenter,
                        image: FileImage(
                          profilePic!,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
