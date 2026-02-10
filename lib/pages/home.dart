import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:barber_booking_app/pages/detail_page.dart';
import 'package:barber_booking_app/pages/service_selection_page.dart';
import 'package:barber_booking_app/services/shared_pref.dart';
import 'package:barber_booking_app/services/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = '';

  Stream? serviceStream;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    getServices();
  }

  Future<void> getServices() async {
    serviceStream = await DatabaseService().getServices();
    setState(() {});
  }

  Future<void> _loadUserName() async {
    String? name = await sharedpreferenceHelper().getUserName();
    setState(() {
      userName = name ?? 'User';
    });
  }

  // Function to launch URLs
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Handle error silently
    }
  }

  // Function to make phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');
    if (!await launchUrl(uri)) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/handsome-man-cutting-beard-barber.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black.withOpacity(0.85),
                          Colors.black.withOpacity(0.2),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Welcome, $userName",
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Look Sharp,\nFeel Sharp.",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                          ),
                          child: const Icon(
                            Icons.content_cut_rounded,
                            color: AppColors.primary,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Services Section Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Our Services',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Services Grid with Images (StreamBuilder)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: StreamBuilder(
                  stream: serviceStream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data.docs.isEmpty) {
                      return const Center(child: Text("No services available.", style: TextStyle(color: AppColors.textSecondary)));
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return _buildServiceCard(ds);
                      },
                    );
                  }
                ),
              ),
              const SizedBox(height: 25),
              // Book A Service Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ServiceSelectionPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Book A Service",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Footer - now part of scrollable content
              _buildFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(DocumentSnapshot ds) {
    Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
    String name = data['name'] ?? 'Service';
    String image = data['image'] ?? '';
    // Handle number parsing safely
    double price = double.tryParse(data['price'].toString()) ?? 0.0;
    double discount = double.tryParse(data['discountPrice'].toString()) ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Service image
            Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.card,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.content_cut,
                        size: 50,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ],
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.card,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Service info
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      if (discount > 0) ...[
                        Text(
                          "\$${price.toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        "\$${(discount > 0 ? discount : price).toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Grid Row Location (left) and Social Links (right)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left  Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Location",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Somalia, Mogadisho\nHodan, Banaadir\nKalkaal Hospital Opposite",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              // Right  Social Links
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Follow Us",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildSocialIcon(
                        FontAwesomeIcons.facebook,
                        'https://facebook.com',
                        const Color(0xFF1877F2),
                      ),
                      const SizedBox(width: 12),
                      _buildSocialIcon(
                        FontAwesomeIcons.tiktok,
                        'https://tiktok.com',
                        AppColors.textPrimary,
                      ),
                      const SizedBox(width: 12),
                      _buildSocialIcon(
                        FontAwesomeIcons.instagram,
                        'https://instagram.com',
                        const Color(0xFFE4405F),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Divider
          Divider(
            color: AppColors.textSecondary.withOpacity(0.2),
            thickness: 1,
          ),
          const SizedBox(height: 12),
          // Phone Numbers Row
          Row(
            children: [
              Expanded(
                child: _buildPhoneNumber('0613085746'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPhoneNumber('0619254366'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumber(String number) {
    return GestureDetector(
      onTap: () => _makePhoneCall(number),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone,
              color: AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              number,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url, Color color) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.background,
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: FaIcon(
          icon,
          color: color,
          size: 18,
        ),
      ),
    );
  }
}
