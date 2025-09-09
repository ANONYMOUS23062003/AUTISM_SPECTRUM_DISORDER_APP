// import 'package:asd_app/create_account.dart';
// import 'package:asd_app/login.dart';
// import 'package:asd_app/firebase_options.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'assessment_page.dart';
// import 'find_specialists_page.dart';
// import 'game_selection_page.dart';
// import 'intro_pages.dart';
// import 'doctor_page.dart' as doctor;
// import 'parent_page.dart' as parent;
// import 'resources_page.dart';
// import 'matchinggame.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const AutismDetectionApp());
// }

// // class Matchinggame extends StatelessWidget {
// //   const Matchinggame({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: "Matching Game",
// //       home: HomePage(),
// //     );
// //   }
// // }

// // class AnimalIdentificationgame extends StatelessWidget {
// //   const AnimalIdentificationgame({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: "Animal Identification Game",
// //       home: HomePage(),
// //     );
// //   }
// // }

// class AutismDetectionApp extends StatelessWidget {
//   const AutismDetectionApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Autism Detection App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const AuthWrapper(), // Initial page set to AuthWrapper
//     );
//   }
// }

// class IntroPages extends StatefulWidget {
//   const IntroPages({super.key, required this.onIntroCompleted});

//   final VoidCallback onIntroCompleted;

//   @override
//   IntroPagesState createState() => IntroPagesState();
// }

// class IntroPagesState extends State<IntroPages> {
//   final PageController _pageController = PageController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         children: [
//           IntroPage(
//             title: 'Welcome to Autism Detection App',
//             description: 'Assess the early signs of autism with our app.',
//             imagePath: 'assets/intro1.png',
//             onNext: () {
//               _pageController.nextPage(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeIn,
//               );
//             },
//           ),
//           IntroPage(
//             title: 'Assessment',
//             description: 'Get a preliminary assessment with a few questions.',
//             imagePath: 'assets/intro2.webp',
//             onNext: () {
//               _pageController.nextPage(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeIn,
//               );
//             },
//           ),
//           IntroPage(
//             title: 'Resources',
//             description: 'Find helpful resources and tips for autism support.',
//             imagePath: 'assets/intro3.jpg',
//             onNext: () {
//               widget.onIntroCompleted();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// Future<void> saveScoreToFirebase(int score) async {
//   try {
//     await FirebaseFirestore.instance.collection('scores').add({
//       'score': score,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//     print("Score saved to Firebase!");
//   } catch (e) {
//     print("Error saving score: $e");
//   }
// }

// class AuthWrapper extends StatefulWidget {
//   const AuthWrapper({super.key});

//   @override
//   State<AuthWrapper> createState() => _AuthWrapperState();
// }

// class _AuthWrapperState extends State<AuthWrapper> {
//   bool isLoggedIn = false;
//   bool hasSeenIntro = false;
//   String? userRole;

//   @override
//   void initState() {
//     super.initState();
//     checkIntroStatus();
//     checkLoginStatus();
//   }

//   void checkIntroStatus() async {
//     setState(() {
//       hasSeenIntro = false;
//     });
//   }

//   void checkLoginStatus() {
//     setState(() {
//       isLoggedIn = false;
//       userRole = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!hasSeenIntro) {
//       return IntroPages(
//         onIntroCompleted: () {
//           setState(() {
//             hasSeenIntro = true;
//           });
//         },
//       );
//     }

//     if (!isLoggedIn) {
//       return const LoginScreen();
//     }

//     if (userRole == 'parent') {
//       return const parent.ParentPage();
//     } else if (userRole == 'doctor') {
//       return const doctor.DoctorPage();
//     } else {
//       return const CreateAccount();
//     }
//   }
// }

// class RoleSelectionPage extends StatefulWidget {
//   const RoleSelectionPage({super.key});

//   @override
//   State<RoleSelectionPage> createState() => _RoleSelectionPageState();
// }

// class _RoleSelectionPageState extends State<RoleSelectionPage> {
//   String? selectedRole;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SizedBox(
//           width: 300,
//           child: DropdownButtonFormField<String>(
//             value: selectedRole,
//             hint: const Text('Select Role'),
//             items: ['Individual', 'Parent', 'Doctor'].map((String role) {
//               return DropdownMenuItem<String>(
//                 value: role,
//                 child: Text(role),
//               );
//             }).toList(),
//             onChanged: (String? newRole) {
//               setState(() {
//                 selectedRole = newRole;
//               });
//             },
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: Colors.white,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/logo.png',
//               height: 30,
//             ),
//             const SizedBox(width: 10),
//             const Text(
//               'Autism Detection App',
//               style: TextStyle(color: Colors.blue),
//             ),
//           ],
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Welcome to Autism Detection App',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Get.to(() => const AssessmentPage());
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//               ),
//               child: const Text('Start Assessment'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Get.to(() => ResourcesPage());
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//               ),
//               child: const Text('View Resources'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Get.to(() => const FindSpecialistsPage());
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//               ),
//               child: const Text('Find Specialists'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Get.to(() => const GamesSelectionPage());
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//               ),
//               child: const Text('Games'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:asd_app/create_account.dart';
import 'package:asd_app/drawer.dart';
import 'package:asd_app/login.dart';
import 'package:asd_app/firebase_options.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'assessment_page.dart';
import 'find_specialists_page.dart';
import 'game_selection_page.dart';
import 'intro_pages.dart';
//import 'doctor_page.dart' as doctor;
//import 'parent_page.dart' as parent;
import 'resources_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const AutismDetectionApp());
}

class AutismDetectionApp extends StatelessWidget {
  const AutismDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Autism Detection App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(), // Initial page set to AuthWrapper
    );
  }
}

// Ensure IntroPages Widget is properly defined or imported here
class IntroPages extends StatefulWidget {
  const IntroPages({super.key, required this.onIntroCompleted});

  final VoidCallback onIntroCompleted;

  @override
  _IntroPagesState createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          IntroPage(
            title: 'Welcome to Autism Detection App',
            description: 'Assess the early signs of autism with our app.',
            imagePath: 'assets/intro1.png',
            onNext: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
          ),
          IntroPage(
            title: 'Assessment',
            description: 'Get a preliminary assessment with a few questions.',
            imagePath: 'assets/intro2.webp',
            onNext: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
          ),
          IntroPage(
            title: 'Resources',
            description: 'Find helpful resources and tips for autism support.',
            imagePath: 'assets/intro3.jpg',
            onNext: () {
              widget.onIntroCompleted();
            },
          ),
        ],
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoggedIn = false;
  bool hasSeenIntro = false;
  String? userRole;

  @override
  void initState() {
    super.initState();
    checkIntroStatus();
    checkLoginStatus();
  }

  void checkIntroStatus() async {
    // Retrieve from shared preferences or another persistent storage if needed
    setState(() {
      hasSeenIntro =
          false; // Assuming the intro has not been seen, modify as needed
    });
  }

  void checkLoginStatus() {
    setState(() {
      isLoggedIn = FirebaseAuth.instance.currentUser != null;
      userRole = 'parent'; // Replace with actual role logic if available
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!hasSeenIntro) {
      return IntroPages(
        onIntroCompleted: () {
          setState(() {
            hasSeenIntro = true;
          });
        },
      );
    }

    if (!isLoggedIn) {
      return const LoginScreen();
    }

    if (userRole == 'parent') {
      return const HomeScreen();
    } else if (userRole == 'doctor') {
      return const HomeScreen();
    } else {
      return const CreateAccount();
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? "User";
    final email = user?.email ?? "user@example.com";

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.jpg',
              height: 30,
            ),
            const SizedBox(width: 10),
            const Text(
              'Autism Detection App',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: AppDrawer(userName: userName, email: email),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Autism Detection App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const AssessmentPage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text('Start Assessment'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => ResourcesPage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text('View Resources'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const FindSpecialistsPage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text('Find Specialists'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const GamesSelectionPage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text('Games'),
            ),
          ],
        ),
      ),
    );
  }
}
