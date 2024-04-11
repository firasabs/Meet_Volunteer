import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sce_project/helpers/designs.dart';
import 'package:sce_project/interface/meet_volunteer.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:sce_project/helpers/fetching_user.dart' as fetch;

class Setup extends StatefulWidget {
  const Setup({super.key, this.arrow});
  final bool? arrow;
  static String id = 'setup';

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  fetch.User? currentUser;
  int _currentPage = 0;
  int _currentAge = 13;
  String? _currentGoal;
  String? _currentCity;
  String _bioText = '';
  String _currentCountry = "Select your country";
  String? _selectedGender;
  final _pageController = PageController();
  FirebaseAuth user = FirebaseAuth.instance;
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    _bioController.addListener(_updateBioText);
  }

  void _updateBioText() {
    setState(() {
      _bioText = _bioController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GradientBackground,
      child: Scaffold(
        appBar: widget.arrow == true
            ? AppBar(
                title: const Text("Edit your profile",
                    style: TextStyle(
                        fontSize: 37,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Truculenta')),
                leading: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 12, 11, 11),
                    size: 30,
                  ),
                ),
                backgroundColor: const Color(0xF9F1DFFF),
                elevation: 0,
              )
            : AppBar(
                backgroundColor: Color(0xF9F1DFFF),
              ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xF9F1DFFF), Color(0xFFBBBB99)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: PageView(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            children: [
              Container(
                alignment: Alignment.center,
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Welcome, we have a few extra steps to complete your registeration\n\n\nLet us move there!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 34,
                      fontFamily: 'Truculenta',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Age:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontFamily: 'Truculenta',
                      ),
                    ).animate().fadeIn(duration: 1500.ms),
                    const SizedBox(
                      height: 30,
                    ),
                    NumberPicker(
                            textStyle: const TextStyle(
                                color: Colors.black, fontSize: 20),
                            selectedTextStyle: const TextStyle(
                                color: Color.fromARGB(255, 2, 109, 197),
                                fontSize: 34),
                            axis: Axis.vertical,
                            minValue: 13,
                            maxValue: 120,
                            value: _currentAge,
                            onChanged: (value) =>
                                setState(() => _currentAge = value))
                        .animate()
                        .fadeIn(duration: 1500.ms)
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Gender:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontFamily: 'Truculenta',
                      ),
                    ).animate().fadeIn(duration: 1500.ms),
                    const SizedBox(
                      height: 40,
                    ),
                    DropdownButton<String>(
                      hint: const Text("Select your gender"),
                      alignment: Alignment.center,
                      value: _selectedGender,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue!;
                        });
                      },
                      items: [
                        const DropdownMenuItem(
                            child: Text("Male"), value: "Male"),
                        const DropdownMenuItem(
                            child: Text("Female"), value: "Female"),
                      ],
                    ).animate().fadeIn(duration: 1500.ms),
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "What's your goal?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontFamily: 'Truculenta',
                      ),
                    ).animate().fadeIn(duration: 1500.ms),
                    const SizedBox(
                      height: 40,
                    ),
                    DropdownButton<String>(
                      hint: const Text("Select your goal"),
                      alignment: Alignment.center,
                      value: _currentGoal,
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentGoal = newValue!;
                        });
                      },
                      items: [
                        const DropdownMenuItem(
                            child: Text("My goal is to be a volunteer!"),
                            value: "Volunteer"),
                        const DropdownMenuItem(
                            child: Text("I'm an elderly"), value: "Elderly"),
                      ],
                    ).animate().fadeIn(duration: 1500.ms),
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bio:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontFamily: 'Truculenta',
                      ),
                    ).animate().fadeIn(duration: 1500.ms),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: TextFormField(
                              controller: _bioController,
                              maxLines: 4,
                              maxLength: 150,
                              decoration: const InputDecoration(
                                hintText: 'Enter your text here...',
                                contentPadding: EdgeInsets.all(10.0),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5.0,
                            right: 5.0,
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                '${_bioText.length}/150',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 1500.ms)
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Profile Picture:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontFamily: 'Truculenta',
                      ),
                    ).animate().fadeIn(duration: 1500.ms),
                    const SizedBox(
                      height: 40,
                    ),
                    FirebaseAuth.instance.currentUser!.photoURL != null
                        ? CircleAvatar(
                            radius: 50,
                            child: ClipOval(
                              child: Image.network(
                                FirebaseAuth.instance.currentUser!.photoURL!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ).animate().fadeIn(duration: 1500.ms)
                        : Container(),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _pickProfilePicture(context);
                      },
                      child: const Text('Select Picture'),
                    ).animate().fadeIn(duration: 1500.ms),
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Location:',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 34,
                            fontFamily: 'Truculenta',
                          ),
                        ).animate().fadeIn(duration: 1500.ms),
                        const Text(
                          '*',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 34,
                            fontFamily: 'Truculenta',
                          ),
                        ).animate().fadeIn(duration: 1500.ms),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var locationStatus = await Permission.location.status;
                        if (!locationStatus.isGranted) {
                          await Permission.location.request();
                        } else {
                          try {
                            await _getCurrentLocation();
                            showToast("Fetching Location...",
                                context: context,
                                position: StyledToastPosition.top,
                                backgroundColor: Colors.green);

                            if (_currentCity != null &&
                                _currentCountry != "Select your country") {
                              setState(() {});
                              showToast("Location fetched successfully",
                                  context: context,
                                  position: StyledToastPosition.top,
                                  backgroundColor: Colors.green);
                            }
                          } catch (e) {
                            print("Error fetching location: $e");
                            showToast("Failed to fetch location",
                                context: context,
                                position: StyledToastPosition.top,
                                backgroundColor: Colors.red);
                          }
                        }
                      },
                      child: Text(_currentCountry == "Select your country"
                          ? 'Locate me'
                          : '$_currentCountry , $_currentCity'),
                    ).animate().fadeIn(duration: 1500.ms),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "This part is required because we match users based on their location, you can't proceed without giving us your locaiton.",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Truculenta',
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ).animate().fadeIn(duration: 1500.ms)
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _currentPage != 6
            ? FloatingActionButton(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                onPressed: () {
                  if (_currentPage < 6) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: const Icon(Icons.navigate_next),
              )
            : FloatingActionButton(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.bottomSlide,
                    title: 'Confirmation',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      if (_selectedGender != null &&
                          _currentGoal != null &&
                          _currentCity != null) {
                        try {
                          saveUserData(
                              _currentAge,
                              _currentCountry!,
                              _selectedGender!,
                              _currentCity!,
                              _currentGoal!,
                              _bioText);
                          showToast("Saved your information successfully!",
                              context: context,
                              position: StyledToastPosition.top,
                              backgroundColor: Colors.green);

                          widget.arrow != true
                              ? Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MeetVolunteer()),
                                )
                              : Navigator.pop(context);
                        } catch (e) {
                          showToast("Something went wrong.",
                              context: context,
                              position: StyledToastPosition.top,
                              backgroundColor: Colors.red);
                        }
                      } else {
                        showToast(
                            "Info missing or location permission not granted.",
                            context: context,
                            position: StyledToastPosition.top,
                            backgroundColor: Colors.red);
                      }
                    },
                  ).show();
                },
                child: const Text("Next"),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickProfilePicture(BuildContext context) async {
    var status = await Permission.photos.request();
    print("Gallery Permission Status: $status");

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        try {
          final imageUrl = await uploadImageAndGetUrl(pickedFile);
          await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
          setState(() {});
          showToast("Profile picture updated successfully!",
              context: context,
              position: StyledToastPosition.top,
              backgroundColor: Colors.green);
        } catch (e) {
          print("Error updating profile picture: $e");
          showToast("Failed to update profile picture.",
              context: context,
              position: StyledToastPosition.top,
              backgroundColor: Colors.red);
        }
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      showToast("Gallery permission is required to pick a profile picture.",
          context: context,
          position: StyledToastPosition.top,
          backgroundColor: Colors.red);
    }
  }

  Future<void> getUser() async {
    try {
      currentUser = await fetch.Fetch.fetchUser(currentUser!.uid!);
    } catch (e) {
      print("User does not exist");
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    // Request permission to access location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }

    Position position = await Geolocator.getCurrentPosition();

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    _currentCity = placemarks.first.locality ?? '';
    print(_currentCity);
    _currentCountry = placemarks.first.country ?? '';
    print(_currentCountry);
  }
}

Future<String> uploadImageAndGetUrl(XFile pickedFile) async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String fileName = userId + '_profile_picture.png';
  final firebase_storage.Reference ref = firebase_storage
      .FirebaseStorage.instance
      .ref()
      .child('profile_pictures')
      .child(fileName);
  await ref.putFile(File(pickedFile.path));

  final imageUrl = await ref.getDownloadURL();

  return imageUrl;
}

Future<void> saveUserDataToFirestore(String userId, int age, String country,
    String gender, String city, String goal, String bio) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'age': age,
      'country': country,
      'gender': gender,
      'city': city,
      'goal': goal,
      'email': FirebaseAuth.instance.currentUser!.email!,
      'username': FirebaseAuth.instance.currentUser!.displayName!,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'avatar': FirebaseAuth.instance.currentUser!.photoURL,
      'bio': bio,
      'timecreated': DateTime.now(),
    });
    print('User data added to Firestore successfully!');
  } catch (error) {
    print('Error adding user data to Firestore: $error');
  }
}

void saveUserData(
    int _currentAge,
    String _currentCountry,
    String _selectedGender,
    String _currentCity,
    String _currentGoal,
    String bio) {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String userId = user.uid;
    print(userId);
    saveUserDataToFirestore(userId, _currentAge, _currentCountry,
        _selectedGender!, _currentCity, _currentGoal, bio);
  } else {
    print('User is not authenticated.');
  }
}
