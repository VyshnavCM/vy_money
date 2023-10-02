// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vy_money/colors/colors.dart';
import 'package:vy_money/data/model/profile/profile_model.dart';
// import 'dart:math';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _nameController;
  // final Random _random = Random();
  late int _selectedAvatrIndex;
  late UserProfile userProfile;
  @override
  void initState() {
    super.initState();
    final userProfile = Hive.box<UserProfile>('user_profile').get(0);

    _nameController = TextEditingController(text: userProfile!.name);
    _selectedAvatrIndex = userProfile.avatarIndex;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateUserProflie() async {
    final userProfileBox = Hive.box<UserProfile>('user_profile');
    userProfileBox.put(
        0, UserProfile(_nameController.text, _selectedAvatrIndex));
    setState(() {
      userProfile = userProfileBox.get(0)!;
    });
    Navigator.pop(context); // close the bottom sheet
  }

  void _showAvatarSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Select Avatar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 79,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close)),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatrIndex = 1;
                    });
                    _updateUserProflie();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar1.png'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatrIndex = 2;
                    });
                    _updateUserProflie();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar2.png'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatrIndex = 3;
                    });
                    _updateUserProflie();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar3.png'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatrIndex = 4;
                    });
                    _updateUserProflie();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar4.png'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatrIndex = 5;
                    });
                    _updateUserProflie();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar5.png'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatrIndex = 6;
                    });
                    _updateUserProflie();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar6.png'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatrIndex = 7;
                    });
                    _updateUserProflie();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar7.png'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatrIndex = 8;
                    });
                    _updateUserProflie();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar8.png'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatrIndex = 9;
                    });
                    _updateUserProflie();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar9.png'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatrIndex = 10;
                    });
                    _updateUserProflie();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar10.png'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatrIndex = 11;
                    });
                    _updateUserProflie();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar11.png'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatrIndex = 12;
                    });
                    _updateUserProflie();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar12.png'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showNameInputDialoge() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text('Change name',style: TextStyle(fontSize: 18),)),
          content: TextFormField(
            maxLength: 25,
            controller: _nameController,
            // decoration: InputDecoration(labelText: 'New Name'),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    ElevatedButton(
              onPressed: () {
                _updateUserProflie();
              },
              child: Text('Save'),
            ),SizedBox(width: 20,),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'))
              ],
            ),
            
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: mainBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 420,
              decoration: BoxDecoration(
                color: backgroundCardCOlor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showAvatarSelectionBottomSheet();
                    },
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.amber,
                      child: GestureDetector(
                        child: CircleAvatar(
                          radius: 73,
                          backgroundImage: AssetImage(
                              'assets/avatar$_selectedAvatrIndex.png'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                      onTap: () {
                        _showNameInputDialoge();
                      },
                      child: Text(
                        _nameController.text,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
