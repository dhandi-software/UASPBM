import 'package:flutter/material.dart';
import 'package:uts_pbm/global.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
    if (_selectedIndex == index && index == 0) {
      if (!Navigator.canPop(context)) {
        // Hanya return jika sudah di Home dan tidak ada yg bisa di-pop
        return;
      }
    }

    if (index == 0) {
      if (Navigator.canPop(context)) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
      if (_selectedIndex != 0) {
        setState(() {
          _selectedIndex = 0;
        });
      }
    } else if (index == 1) {
      if (_selectedIndex != index ||
          !ModalRoute.of(context)!.settings.name!.endsWith('InputDataScreen')) {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const InputDataScreen(),
              settings: const RouteSettings(name: 'InputDataScreen')),
        ).then((_) {
          if (mounted) {
            setState(() {
              _selectedIndex = 0;
            });
          }
        });
      }
    } else if (index == 2) {
      if (_selectedIndex != index ||
          !ModalRoute.of(context)!.settings.name!.endsWith('LihatDataScreen')) {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LihatDataScreen(),
              settings: const RouteSettings(name: 'LihatDataScreen')),
        ).then((_) {
          if (mounted) {
            setState(() {
              _selectedIndex = 0;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      bottomNavigationBar: _bottomNavigationBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
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
              const SizedBox(height: 40),
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
                  ).then((_) {
                    if (mounted) {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    }
                  });
                },
              ),
              const SizedBox(height: 48),
              _buildStyledButton(
                buttonText: "Halaman Lihat Data",
                isPrimary: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LihatDataScreen()),
                  ).then((_) {
                    if (mounted) {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    }
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
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
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [
                              Color.fromARGB(
                                  255, 144, 2, 200), // Warna atas (0%)
                              Color.fromARGB(
                                  255, 72, 31, 147), // Warna bawah (100%)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                          ).createShader(bounds);
                        },
                        child: SvgPicture.asset(
                          'assets/svgs/orangduduk.svg',
                          width: 35,
                          height: 35,
                          color: Colors.white,
                          colorBlendMode: BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "DBS Application",
                        style: GoogleFonts.poppins(
                          // Pastikan GoogleFonts diimpor jika digunakan
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
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 144, 2, 200), // Warna atas (0%)
                    Color.fromARGB(255, 72, 31, 147), // Warna bawah (100%)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                ).createShader(bounds);
              },
              child: SvgPicture.asset(
                'assets/svgs/orangduduk.svg',
                height: 100,
                width: 60,
                // PENTING: Menggunakan color dan colorBlendMode agar ShaderMask efektif
                color: Colors.white, // SVG dijadikan putih (atau warna dasar)
                colorBlendMode:
                    BlendMode.srcIn, // Mode ini penting untuk ShaderMask
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
