import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sce_project/interface/browse.dart';
import 'package:sce_project/main.dart';
import '../helpers/fetching_user.dart' as userInfo;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static String id = 'profile';
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  userInfo.User? user;
  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final fetchedUser = await userInfo.Fetch.fetchCurrentUser();
        setState(() {
          user = fetchedUser;
        });
      }
    } catch (e) {
      print('Failed to fetch current user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Card(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .5,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(
                                MediaQuery.of(context).size.width * 0.5, 100.0),
                            bottomRight: Radius.elliptical(
                                MediaQuery.of(context).size.width * 0.5, 100.0),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: _auth.currentUser!.photoURL != null
                                ? NetworkImage(_auth.currentUser!.photoURL!)
                                : const NetworkImage('https://firebasestorage.googleapis.com/v0/b/sce-project-679d8.appspot.com/o/profile_pictures%2Fperson-295.png?alt=media&token=034284ff-2eee-4158-a557-4dec345e701f'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Text(
                  FirebaseAuth.instance.currentUser!.displayName!,
                  style: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'Truculenta',
                      fontWeight: FontWeight.bold),
                ),
              ),
              user != null
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Text(
                        '${user!.bio!}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Truculenta',
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              if (user != null) // Conditional check for user object
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  children: [
                                    const Text('Age'),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      '${user!.age!}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 1,
                                color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  children: [
                                    const Text('Gender'),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      '${user!.gender!}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 1,
                                color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  children: [
                                    const Text('Goal'),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      '${user!.goal!}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 1,
                                color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  children: [
                                    const Text('Country'),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      '${user!.country!}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 1,
                                color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  children: [
                                    const Text('City'),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      '${user!.city!}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ).animate().fadeIn(duration: 1000.ms),
      ),
    );
  }
}
