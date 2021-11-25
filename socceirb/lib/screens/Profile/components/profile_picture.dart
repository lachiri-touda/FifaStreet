// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socceirb/constants.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}


class _ProfilePictureState extends State<ProfilePicture> {
  File? profilePic;

  void _uploadImage() async {
    final _picker = ImagePicker();
    var _pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      profilePic = File(_pickedImage!.path);
      //print(image);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple,
                ),
                margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.12),
                child: Stack(
                  children: [
                    circleArea(),
                    littleIcon(),
                  ],
                ),
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
                          color: Colors.red,
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  );
  }

  CircleAvatar circleArea() {
    return CircleAvatar(
                    radius: SizeConfig.screenWidth * 0.15,
                    backgroundColor: Colors.red,
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
                                        image: AssetImage(
                                            'assets/images/profile.png')),
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