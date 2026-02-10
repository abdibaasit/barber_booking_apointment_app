import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:barber_booking_app/pages/detail_page.dart';
import 'package:barber_booking_app/services/database.dart';

class ServiceSelectionPage extends StatefulWidget {
  const ServiceSelectionPage({super.key});

  @override
  State<ServiceSelectionPage> createState() => _ServiceSelectionPageState();
}

class _ServiceSelectionPageState extends State<ServiceSelectionPage> {
  Stream? serviceStream;
  List<DocumentSnapshot> services = [];
  
  // Set to track selected services
  Set<String> selectedServicesName = {};
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    getServices();
  }

  Future<void> getServices() async {
    serviceStream = await DatabaseService().getServices();
    setState(() {});
  }

  void _toggleService(String name, double price) {
    setState(() {
      if (selectedServicesName.contains(name)) {
        selectedServicesName.remove(name);
        totalPrice -= price;
      } else {
        selectedServicesName.add(name);
        totalPrice += price;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Select Services"),
        centerTitle: true,
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Info text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Select one or more services to book",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ),
          // Service grid
          Expanded(
            child: StreamBuilder(
              stream: serviceStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return _buildServiceCard(ds);
                  },
                );
              },
            ),
          ),
          // Bottom section with total and button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Selected services summary
                  if (selectedServicesName.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${selectedServicesName.length} service${selectedServicesName.length > 1 ? 's' : ''} selected",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Total: \$${totalPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedServicesName.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    services: selectedServicesName.toList(),
                                    totalPrice: totalPrice.toStringAsFixed(0),
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedServicesName.isEmpty
                            ? AppColors.background.withOpacity(0.5)
                            : AppColors.primary,
                        foregroundColor: selectedServicesName.isEmpty
                            ? AppColors.textSecondary
                            : Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        selectedServicesName.isEmpty
                            ? "Select Services"
                            : "Continue to Booking - \$${totalPrice.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(DocumentSnapshot ds) {
    Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
    String name = data['name'] ?? 'Service';
    String image = data['image'] ?? '';
    double price = double.parse(data['price'].toString());
    double discount = double.parse(data['discountPrice'].toString());
    
    // Use discount price if available and greater than 0
    double finalPrice = discount > 0 ? discount : price;

    bool isSelected = selectedServicesName.contains(name);

    return GestureDetector(
      onTap: () => _toggleService(name, finalPrice),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
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
                    child: Icon(
                      Icons.content_cut,
                      size: 50,
                      color: AppColors.primary.withOpacity(0.5),
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
                    const SizedBox(height: 4),
                    Row(
                      children: [
                         if (discount > 0) ...[
                          Text(
                            "\$$price", // Old Price with strikethrough
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                         ],
                        Text(
                          "\$$finalPrice", // Final price (Discounted or Regular)
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Selection indicator
              if (isSelected)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
