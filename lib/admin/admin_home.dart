import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:barber_booking_app/services/database.dart';
import 'package:barber_booking_app/pages/custom_text_field.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  // Hardcoded services to seed if Firestore is empty
  final List<Map<String, dynamic>> initialServices = [
    {
      'name': 'Haircut',
      'price': '35',
      'discountPrice': '0',
      'image': 'https://i.pinimg.com/originals/58/57/07/5857077de07ee330c859069586c539a8.jpg',
    },
    {
      'name': 'Shave',
      'price': '4',
      'discountPrice': '0',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_qHIp-W7VIktWmHiphFv5ajInjiREC4OFNw&s',
    },
    {
      'name': 'Coloring',
      'price': '16',
      'discountPrice': '0',
      'image': 'https://assets.bleachlondon.com/image/upload/w_300,h_300,c_fill,q_80,f_auto/v1603976076/master_platform/how_to/type1_virgin_root_to_tip_roxy/2.tone/Root-To-Tip-Type-1-Tone-Step-2.jpg',
    },
    {
      'name': 'Facial',
      'price': '55',
      'discountPrice': '0',
      'image': 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=400',
    },
    {
      'name': 'Styling',
      'price': '33',
      'discountPrice': '0',
      'image': 'https://zorainsstudio.com/wp-content/uploads/2019/10/Personal-Grooming-Hair.jpg',
    },
    {
      'name': 'Beard Trim',
      'price': '9',
      'discountPrice': '0',
      'image': 'https://img.freepik.com/free-photo/young-man-getting-his-beard-styled-barber_23-2148985728.jpg?semt=ais_hybrid&w=740&q=80',
    },
  ];

  Stream? serviceStream;

  @override
  void initState() {
    super.initState();
    getServicesOnLoad();
  }

  Future<void> getServicesOnLoad() async {
    serviceStream = await DatabaseService().getServices();
    setState(() {});
  }

  Future<void> seedServices() async {
    // Get current services to check for duplicates
    QuerySnapshot currentServicesSnapshot = await FirebaseFirestore.instance.collection("Services").get();
    List<String> existingNames = currentServicesSnapshot.docs.map((doc) => doc['name'] as String).toList();

    int addedCount = 0;
    for (var service in initialServices) {
      if (!existingNames.contains(service['name'])) {
        await DatabaseService().addService(service);
        addedCount++;
      }
    }

    if (addedCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$addedCount New Services Added!"), backgroundColor: AppColors.success),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Services already exist!"), backgroundColor: Colors.orange),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildRevenueCard(),
              const SizedBox(height: 30),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Manage Services",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: seedServices,
                    child: const Icon(Icons.cloud_upload, color: AppColors.primary),
                  )
                ],
              ),
              const SizedBox(height: 20),
              _buildServiceGrid(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddServiceDialog(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Hello, Admin",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
             SizedBox(height: 5),
             Text(
              "Welcome back",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 30),
        ),
      ],
    );
  }

  Widget _buildRevenueCard() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Booking").snapshots(),
      builder: (context, snapshot) {
        double totalRevenue = 0;
        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            try {
              totalRevenue += double.parse(doc["Amount"].toString());
            } catch (e) {
              // Ignore parse errors
            }
          }
        }
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFFE99E1D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Total Revenue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   SizedBox(height: 5),
                   Text(
                    "All time earnings",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              Text(
                "\$${totalRevenue.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceGrid() {
    return StreamBuilder(
      stream: serviceStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8, // Adjusted for taller cards with buttons
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return _buildServiceCard(ds);
          },
        );
      },
    );
  }

  Widget _buildServiceCard(DocumentSnapshot ds) {
    Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
    String name = data['name'] ?? 'Service';
    String price = data['price'] ?? '0';
    String discount = data['discountPrice'] ?? '0';
    String image = data['image'] ?? '';

    return GestureDetector(
      onTap: () => _showEditServiceDialog(ds.id, name, price, discount),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                       Row(
                        children: [
                          Text(
                            "\$$price",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              decoration: double.parse(discount) > 0 ? TextDecoration.lineThrough : null,
                              fontSize: double.parse(discount) > 0 ? 12 : 16,
                            ),
                          ),
                          if (double.parse(discount) > 0) ...[
                            const SizedBox(width: 5),
                            Text(
                              "\$$discount",
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Delete Button
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () => _deleteService(ds.id),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteService(String id) async {
    await DatabaseService().deleteService(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Service Deleted"), backgroundColor: Colors.redAccent),
    );
  }

  void _showEditServiceDialog(String id, String name, String price, String discount) {
    TextEditingController priceController = TextEditingController(text: price);
    TextEditingController discountController = TextEditingController(text: discount);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text("Edit $name", style: const TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: "Price",
                labelStyle: TextStyle(color: AppColors.textSecondary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textSecondary)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: discountController,
              decoration: const InputDecoration(
                labelText: "Discount Price (0 for none)",
                labelStyle: TextStyle(color: AppColors.textSecondary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textSecondary)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseService().updateService(id, {
                'price': priceController.text,
                'discountPrice': discountController.text,
              });
              Navigator.pop(context);
            },
            child: const Text("Update", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showAddServiceDialog() {
    // Basic Add Service Dialog (could be expanded)
    // For now, relies on seeding for initial data.
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        backgroundColor: AppColors.card,
        title: Text("Add Service", style: TextStyle(color: AppColors.textPrimary)),
        content: Text("To add a new service, please use the seeding button for standard services or contact support for custom ones.", style: TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }
}
