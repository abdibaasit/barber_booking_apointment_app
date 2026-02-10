import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:barber_booking_app/services/database.dart';

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  Stream? usersStream;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    usersStream = await DatabaseService().getAllUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: const Text(
          "Registered Users",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: StreamBuilder(
          stream: usersStream,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No users found",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Theme(
                   data: Theme.of(context).copyWith(
                    dividerColor: AppColors.textSecondary.withOpacity(0.2),
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      AppColors.primary.withOpacity(0.1),
                    ),
                    dataRowColor: MaterialStateProperty.all(AppColors.card),
                    columns: const [
                       DataColumn(label: Text('Username', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                       DataColumn(label: Text('Email', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                       DataColumn(label: Text('Action', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                    ],
                    rows: _buildRows(snapshot.data.docs),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<DataRow> _buildRows(List<DocumentSnapshot> docs) {
    return docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return DataRow(
        cells: [
          DataCell(
            Row(
              children: [
                const Icon(Icons.person, color: AppColors.textSecondary, size: 16),
                const SizedBox(width: 8),
                Text(data['username'] ?? 'Unknown', style: const TextStyle(color: AppColors.textPrimary)),
              ],
            ),
          ),
          DataCell(Text(data['email'] ?? 'No Email', style: const TextStyle(color: AppColors.textSecondary))),
          DataCell(
            IconButton(
              icon: const Icon(Icons.info_outline, color: AppColors.primary),
              onPressed: () {
                // Future: Show detailed user info dialog
              },
            ),
          ),
        ],
      );
    }).toList();
  }
}
