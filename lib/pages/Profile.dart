import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:barber_booking_app/pages/login.dart';
import 'package:barber_booking_app/services/auth.dart';
import 'package:barber_booking_app/services/shared_pref.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name, email, image;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  // 'getSharedPrefs' waxay soo raddaysaa dhammaan xogta uu abka ku xasuusto isticmaalaha.
  // Concept: Xogtan waxaa loo isticmaalaa in bogga Profile-ka lagu qurxiyo iyadoo aan loo baahnayn in markasta Firestore lala hadlo (Efficiency).
  Future<void> getSharedPrefs() async {
    final helper = sharedpreferenceHelper();
    name = await helper.getUserName();
    email = await helper.getUserEmail();
    image = await helper.getUserImage();
    setState(() {}); // Dib u dhis bogga markay xogtu timaado.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: name == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 50.0,
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: (image != null && image!.isNotEmpty)
                            ? Image.network(
                                image!,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildInitialsAvatar(),
                              )
                            : _buildInitialsAvatar(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildProfileTile("Name", name!, Icons.person_outline),
                  _buildProfileTile("Email", email!, Icons.email_outlined),
                  const SizedBox(height: 50),
                  _buildActionButton(
                    "Logout",
                    Icons.logout,
                    AppColors.card,
                    () async {
                      await FirebaseAuth.instance.signOut();
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildActionButton(
                    "Delete Account",
                    Icons.delete_forever,
                    AppColors.error.withOpacity(0.2),
                    () {
                      _showDeleteDialog();
                    },
                  ),
                ],
              ),
            ),
    );
  }

  // Build an avatar with the user's first 2 initials
  Widget _buildInitialsAvatar() {
    String initials = (name != null && name!.isNotEmpty)
        ? name!.substring(0, name!.length >= 2 ? 2 : name!.length).toUpperCase()
        : "?";
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(60),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    bool isSignOut = title == "Logout";
    bool isDelete = title == "Delete Account";
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: isSignOut ? Border.all(color: AppColors.primary) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: isDelete ? AppColors.error : AppColors.primary),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                color: isDelete ? AppColors.error : AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // '_showDeleteDialog' waa digniin ka hor intaanan tirtirin akoonka rasmiga ah.
  // Concept: 'Critical Actions' waxay u baahan yihiin in qofka la weydiiyo "Ma hubaal baa?" si looga fogaado khaladaadka dhaca markii qofku si lama filaan ah wax u taabto.
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          "Delete Account?",
          style: TextStyle(color: AppColors.primary),
        ),
        content: const Text(
          "This action is permanent and cannot be undone.",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Concept: Tirtiridda akoonka waxay dhex martaa dhawr meelood: Firestore, Firebase Auth, iyo xogta local-ka (Logout).
              await AuthMethods().deleteuser();
              if (!mounted) return;

              // Marka la tirtiro, ku celi bogga soo gelidda si uusan abka u isticmaali karin.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
