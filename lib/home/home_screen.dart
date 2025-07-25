import 'package:flutter/material.dart';
import 'package:uts_pbm/global.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// Import halaman tujuan
import 'package:uts_pbm/input/input_data_screen.dart';
import 'package:uts_pbm/LihatData/lihat_data_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // Navigasi BottomNavBar tetap sama, namun kita akan reset state saat kembali
    if (_selectedIndex == index) return;

    // Navigasi ke halaman lain
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InputDataScreen()),
      ).then((_) =>
          setState(() => _selectedIndex = 0)); // Reset ke Home saat kembali
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LihatDataScreen()),
      ).then((_) =>
          setState(() => _selectedIndex = 0)); // Reset ke Home saat kembali
    }
  }

  // Widget untuk membangun Drawer (menu samping)
  Widget _buildAppDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header untuk Drawer dengan logo dan nama
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: ungugradient, // Menggunakan gradient dari global.dart
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo Anda di dalam Drawer
                SvgPicture.asset(
                  'assets/svgs/orangduduk.svg',
                  height: 60,
                  width: 60,
                  color: Colors.white,
                  colorBlendMode: BlendMode.srcIn,
                ),
                const SizedBox(height: 12),
                const Text(
                  'DBS Application',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Item menu untuk ke Halaman Input Data
          ListTile(
            leading: const Icon(Icons.home_rounded),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Tutup drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              ).then((_) => setState(() => _selectedIndex = 0));
            },
          ),
          ListTile(
            leading: const Icon(Icons.input_rounded),
            title: const Text('Input Data'),
            onTap: () {
              Navigator.pop(context); // Tutup drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InputDataScreen()),
              ).then((_) => setState(() => _selectedIndex = 0));
            },
          ),
          // Item menu untuk ke Halaman Lihat Data
          ListTile(
            leading: const Icon(Icons.list_alt_rounded),
            title: const Text('Lihat Data'),
            onTap: () {
              Navigator.pop(context); // Tutup drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LihatDataScreen()),
              ).then((_) => setState(() => _selectedIndex = 0));
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      // AppBar baru untuk menampilkan judul dan ikon Drawer
      appBar: AppBar(
        title: const Text('DBS Application'),
        backgroundColor: const Color(0xFF6750A4), // Warna konsisten dengan tema
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      // Menambahkan Drawer ke Scaffold
      drawer: _buildAppDrawer(context),
      bottomNavigationBar: _bottomNavigationBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 32), // Padding disesuaikan
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pemrograman Mobile",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: graytext,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Dhandi Adam",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: text,
                ),
              ),
              const SizedBox(height: 30),
              _buildInfoCard(),
              const SizedBox(height: 30),
              _buildStyledButton(
                buttonText: "Halaman Input Data",
                isPrimary: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InputDataScreen()),
                  ).then((_) => setState(() => _selectedIndex = 0));
                },
              ),
              const SizedBox(height: 20),
              _buildStyledButton(
                buttonText: "Halaman Lihat Data",
                isPrimary: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LihatDataScreen()),
                  ).then((_) => setState(() => _selectedIndex = 0));
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: ungugradient,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      // Logo Anda di dalam kartu
                      SvgPicture.asset(
                        'assets/svgs/orangduduk.svg',
                        width: 35,
                        height: 35,
                        color: Colors.white,
                        colorBlendMode: BlendMode.srcIn,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "DBS Application",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Home Page",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "DBS",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Ilustrasi di sisi kanan kartu
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [
                    Color(0xFFDF98FA),
                    Color(0xFF9055FF),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds);
              },
              child: SvgPicture.asset(
                'assets/svgs/orangduduk.svg',
                height: 100,
                width: 60,
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledButton({
    required String buttonText,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    const Color secondaryButtonBorderColor = Color(0xFFE0E0E0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isPrimary ? iconActive : secondaryButtonBorderColor,
            width: 1.5,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: iconActive.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            buttonText,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: text,
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar() => BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          _customBottomBarItem(
              iconAsset: "assets/svgs/house.svg", label: "Home"),
          _customBottomBarItem(
              iconAsset: "assets/svgs/input.svg", label: "Input"),
          _customBottomBarItem(
              iconAsset: "assets/svgs/history.svg", label: "History"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: BottomNavbar,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: iconActive,
        unselectedItemColor: text,
      );

  BottomNavigationBarItem _customBottomBarItem({
    required String iconAsset,
    required String label,
  }) =>
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          iconAsset,
          color: text,
          colorBlendMode: BlendMode.srcIn,
          width: 24,
          height: 24,
        ),
        activeIcon: SvgPicture.asset(
          iconAsset,
          color: iconActive,
          colorBlendMode: BlendMode.srcIn,
          width: 24,
          height: 24,
        ),
        label: label,
      );
}
