import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FindSpecialistsPage extends StatefulWidget {
  const FindSpecialistsPage({super.key});

  @override
  State<FindSpecialistsPage> createState() => _FindSpecialistsPageState();
}

class _FindSpecialistsPageState extends State<FindSpecialistsPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Specialists'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Search for doctors
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search doctors or clinics...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Location input
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Find a Doctor button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String query =
                      '${_searchController.text.trim()}, ${_locationController.text.trim()}';
                  if (query.trim().isNotEmpty) {
                    _launchGoogleMaps(query);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter both a clinic name and location.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Find a Doctor'),
              ),
            ),
            const SizedBox(height: 20),

            // Popular Clinics section
            const Text(
              'Popular Clinics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // List of clinics
            Expanded(
              child: ListView(
                children: const [
                  ClinicCard(
                    imageUrl: 'clinic1.jpg', // replace with the actual image paths
                    clinicName: 'Dr A M Reddy Autism Center',
                    location: 'Hyderabad, Telangana',
                    description:
                        'With his vast experience, Dr. A M Reddy has cured and provided relief to many children.',
                  ),
                  ClinicCard(
                    imageUrl: 'clinic2.png',
                    clinicName: 'Child Development Clinic',
                    location: 'Bangalore, Karnataka',
                    description:
                        'Specialized in autism and child development, offering expert care for children.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchGoogleMaps(String query) async {
    final Uri googleMapsUrl =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }
}

class ClinicCard extends StatelessWidget {
  final String imageUrl;
  final String clinicName;
  final String location;
  final String description;

  const ClinicCard({
    super.key,
    required this.imageUrl,
    required this.clinicName,
    required this.location,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Image.asset(
          imageUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        title: Text(clinicName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 5),
            Text(description),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.location_on, color: Colors.blue),
          onPressed: () {
            final query = '$clinicName, $location';
            _launchGoogleMaps(query);
          },
        ),
      ),
    );
  }

  void _launchGoogleMaps(String query) async {
    final Uri googleMapsUrl =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }
}
