import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:barber_booking_app/pages/detail_page.dart';
import 'package:barber_booking_app/pages/service_tile.dart';
import 'package:barber_booking_app/services/shared_pref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = '';

  // 'initState' waa shaqada kowaad ee la fuliyo marka bogga la furayo.
  // Concept: Waxaan halkan ku boqanaa si aan u soo rarno xogta isticmaalaha inta uusan bogga soo muuqan.
  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // '_loadUserName' waxay magaca qofka ka soo aqrinaysaa xusuusta talifoonka (Local storage).
  // Concept: 'setState' waxay Flutter u sheegaysaa in xogtu isbeddeshay, markaasna bogga dib ha loo dhiso (UI Refresh).
  Future<void> _loadUserName() async {
    String? name = await sharedpreferenceHelper().getUserName();
    setState(() {
      userName = name ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        margin: const EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Xulshada Kaadhka Muuqda (Promotional Card / Hero)
            // Concept: Kaadhkan wuxuu soo jiidayaa isha isticmaalaha isagoo isticmaalaya sawir tayo leh (Visual Appeal).
            // Maaddaama aan madaxa hore meesha ka saarnay, kani waa waxa ugu horreeya ee uu arkayo isticmaalaha.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height:
                    180, // Wax yar ayaan kordhinay si uu booska u buuxiyo si qurux badan
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
                              "Look Sharp,\nFeel Sharp.", // Hal-ku-dheggii hore ayaan halkan u soo raray si uu u muuqdo mid premium ah
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
            const SizedBox(height: 10.0),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: AppColors.background),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        'Services',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    // 'Expanded' waxay ka dhigaysaa in liiska adeegyadu uu qaato booska harsan oo dhan.
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        // Concept: 'GridView' waxaa loo isticmaalaa in xogta lagu soo bandhigo qaab shaxan ah (Matrix).
                        // 'crossAxisCount: 2' waxay ka dhigan tahay labo tiir (columns) ayuu u qaybsan yahay muuqaalku.
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.85,
                          children: [
                            // Concept: 'ServiceTile' waa component aan dib u isticmaalayno (Reusable Widget).
                            // Halkii aan code kasta dib u qori lahayn, waxaan u yeeraynaa ServiceTile adoo u dhiibaya magaca iyo icon-ka.
                            ServiceTile(
                              name: 'Haircut',
                              icon: Icons.content_cut,
                              onTap: () => _navigateToDetail('Haircut'),
                            ),
                            ServiceTile(
                              name: 'Shave',
                              icon: Icons.face_retouching_natural,
                              onTap: () => _navigateToDetail('Shave'),
                            ),
                            ServiceTile(
                              name: 'Coloring',
                              icon: Icons.palette,
                              onTap: () => _navigateToDetail('Coloring'),
                            ),
                            ServiceTile(
                              name: 'Facial',
                              icon: Icons.spa,
                              onTap: () => _navigateToDetail('Facial'),
                            ),
                            ServiceTile(
                              name: 'Beard Trim',
                              icon: Icons.content_cut_outlined,
                              onTap: () => _navigateToDetail('Beard Trim'),
                            ),
                            ServiceTile(
                              name: 'Styling',
                              icon: Icons.brush,
                              onTap: () => _navigateToDetail('Styling'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Shaqada lagu gudbiyo bogga faahfaahinta adeegga
  void _navigateToDetail(String service) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(service: service)),
    );
  }
}
