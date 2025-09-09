// import 'package:flutter/material.dart';
// import 'doctor_page.dart';
// //import 'main.dart';   // Import Home Page for Individual
// import 'parent_page.dart'; // Import Parent Page
// import 'homepage.dart';

// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _AuthPageState createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage> {
//   bool isSignIn = true; // Controls switching between Sign In and Sign Up
//   String? selectedRole; // Stores the selected role (Doctor, Individual, Parent)

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Autism Assessment App'),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: Center(
//         child: FractionallySizedBox(
//           widthFactor: 0.85, // Form width will be 85% of the screen width
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Switch between Sign In and Sign Up
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () => setState(() => isSignIn = true),
//                     child: Column(
//                       children: [
//                         Text(
//                           'Sign In',
//                           style: TextStyle(
//                             fontSize: 18, // Improved font size for better visibility
//                             fontWeight: isSignIn ? FontWeight.bold : FontWeight.normal,
//                             color: isSignIn ? Colors.black : Colors.grey,
//                           ),
//                         ),
//                         if (isSignIn)
//                           Container(
//                             height: 2,
//                             width: 50,
//                             color: Colors.blue,
//                           ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   GestureDetector(
//                     onTap: () => setState(() => isSignIn = false),
//                     child: Column(
//                       children: [
//                         Text(
//                           'Sign Up',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: !isSignIn ? FontWeight.bold : FontWeight.normal,
//                             color: !isSignIn ? Colors.black : Colors.grey,
//                           ),
//                         ),
//                         if (!isSignIn)
//                           Container(
//                             height: 2,
//                             width: 50,
//                             color: Colors.blue,
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20), // Add space between the tabs and the form

//               // Display either Sign In or Sign Up Form
//               isSignIn ? buildSignInForm() : buildSignUpForm(),

//               const SizedBox(height: 20), // Add space between the form and the social login options

//               // Google and Apple buttons for OAuth sign-in
//               buildSocialLoginOptions(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Sign In form widget
//   Widget buildSignInForm() {
//     return Column(
//       children: [
//         const TextField(
//           decoration: InputDecoration(
//             labelText: 'Email',
//             border: OutlineInputBorder(),
//             contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//           ),
//         ),
//         const SizedBox(height: 10),
//         const TextField(
//           obscureText: true,
//           decoration: InputDecoration(
//             labelText: 'Password',
//             border: OutlineInputBorder(),
//             contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//             suffixIcon: Icon(Icons.visibility_off),
//           ),
//         ),
//         const SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: () {
//             // Handle sign in logic here
//           },
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size(150, 45), // Button size
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//           child: const Text('Sign In', style: TextStyle(fontSize: 16)),
//         ),
//         const SizedBox(height: 10),
//         TextButton(
//           onPressed: () {
//             // Handle forgot password
//           },
//           child: const Text('Forgot Password?'),
//         ),
//       ],
//     );
//   }

//   // Sign Up form widget with role selection
//   Widget buildSignUpForm() {
//     return Column(
//       children: [
//         const TextField(
//           decoration: InputDecoration(
//             labelText: 'Email',
//             border: OutlineInputBorder(),
//             contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//           ),
//         ),
//         const SizedBox(height: 10),
//         const TextField(
//           obscureText: true,
//           decoration: InputDecoration(
//             labelText: 'Password',
//             border: OutlineInputBorder(),
//             contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//             suffixIcon: Icon(Icons.visibility_off),
//           ),
//         ),
//         const SizedBox(height: 10),
//         const TextField(
//           obscureText: true,
//           decoration: InputDecoration(
//             labelText: 'Confirm Password',
//             border: OutlineInputBorder(),
//             contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//             suffixIcon: Icon(Icons.visibility_off),
//           ),
//         ),
//         const SizedBox(height: 20),

//         // Role Selection Dropdown
//         DropdownButtonFormField<String>(
//           value: selectedRole,
//           decoration: const InputDecoration(
//             labelText: 'Select Role',
//             border: OutlineInputBorder(),
//             contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//           ),
//           items: const [
//             DropdownMenuItem(
//               value: 'Doctor',
//               child: Text('Doctor'),
//             ),
//             DropdownMenuItem(
//               value: 'Individual',
//               child: Text('Individual'),
//             ),
//             DropdownMenuItem(
//               value: 'Parent',
//               child: Text('Parent'),
//             ),
//           ],
//           onChanged: (value) {
//             setState(() {
//               selectedRole = value;
//             });
//           },
//         ),
//         const SizedBox(height: 10),

//         ElevatedButton(
//           onPressed: () {
//             if (selectedRole != null) {
//               // Navigate to the corresponding page based on the selected role
//               switch (selectedRole) {
//                 case 'Doctor':
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const DoctorPage()),
//                   );
//                   break;
//                 case 'Individual':
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const Homepage()),
//                   );
//                   break;
//                 case 'Parent':
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const ParentPage()),
//                   );
//                   break;
//                 default:
//                   break;
//               }
//             } else {
//               // Show error if role is not selected
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Please select a role to continue')),
//               );
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size(150, 45),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//           child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
//         ),
//       ],
//     );
//   }

//   // Social Login options
//   Widget buildSocialLoginOptions() {
//     return Column(
//       children: [
//         const Text('Or sign up with', style: TextStyle(color: Colors.grey)),
//         const SizedBox(height: 10),
//         ElevatedButton.icon(
//           onPressed: () {
            
//             // Handle Google Sign-In
//           },
//           icon: const Icon(Icons.account_circle, color: Colors.red),
//           label: const Text('Continue with Google'),
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.black,
//             backgroundColor: Colors.white,
//             minimumSize: const Size(180, 45),
//             side: const BorderSide(color: Colors.black),
//           ),
//         ),
//         const SizedBox(height: 10),
//         ElevatedButton.icon(
//           onPressed: () {
//             // Handle Apple Sign-In
//           },
//           icon: const Icon(Icons.apple, color: Colors.black),
//           label: const Text('Continue with Apple'),
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.black,
//             backgroundColor: Colors.white,
//             minimumSize: const Size(180, 45),
//             side: const BorderSide(color: Colors.black),
//           ),
//         ),
//       ],
//     );
//   }
// } 