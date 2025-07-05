import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uts_pbm/global.dart';
import 'package:uts_pbm/home/home_screen.dart';
import 'package:uts_pbm/LihatData/lihat_data_screen.dart';

class InputDataScreen extends StatefulWidget {
  const InputDataScreen({super.key});

  @override
  State<InputDataScreen> createState() => _InputDataScreenState();
}

class _InputDataScreenState extends State<InputDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();
  bool _isLoading = false;
  final int _selectedIndex = 1;

  Widget _buildAppDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white, // Latar belakang drawer putih
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: ungugradient,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svgs/orangduduk.svg',
                  height: 60,
                  width: 60,
                  // PERBAIKAN: Ganti 'colorFilter' kembali ke 'color' dan 'colorBlendMode'
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
          ListTile(
            // Menggunakan warna `text` dari global agar konsisten
            leading: Icon(Icons.home_rounded, color: text),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              _onBottomNavItemTapped(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.input_rounded, color: text),
            title: const Text('Input Data'),
            onTap: () {
              Navigator.pop(context);
              // Cukup pushReplacement agar tidak menumpuk halaman
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const InputDataScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt_rounded, color: text),
            title: const Text('Lihat Data'),
            onTap: () {
              Navigator.pop(context);
              // Jika sudah di halaman lihat data, cukup tutup drawer
              // Jika ingin refresh, bisa panggil _fetchData()
              // _onBottomNavItemTapped(2);
            },
          ),
        ],
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
                              Color.fromARGB(255, 144, 2, 200),
                              Color.fromARGB(255, 72, 31, 147),
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
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Input Page",
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
                    Color.fromARGB(255, 144, 2, 200),
                    Color.fromARGB(255, 72, 31, 147),
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
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _kirimData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final npmValue = int.tryParse(_npmController.text);
        if (npmValue == null) {
          throw Exception("NPM harus berupa angka yang valid.");
        }

        await Supabase.instance.client.from('InputData').insert({
          'nama': _namaController.text,
          'npm': npmValue,
          'pesan': _pesanController.text,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil dikirim!'),
              backgroundColor: Colors.green,
            ),
          );
          _namaController.clear();
          _npmController.clear();
          _pesanController.clear();
          FocusScope.of(context).unfocus();
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengirim data: ${error.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _npmController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  void _onBottomNavItemTapped(int index) {
    if (_selectedIndex == index) return;

    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 1:
        // Sudah di halaman ini, tidak perlu navigasi
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LihatDataScreen()),
        );
        break;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final Color defaultTextFieldBorderColor = Colors.grey.shade400;

    return Scaffold(
      backgroundColor: background,
      // AppBar ditambahkan untuk menampilkan judul dan ikon Drawer
      appBar: AppBar(
        title: const Text('Input Data'),
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
      ),
      // Menambahkan Drawer ke Scaffold
      drawer: _buildAppDrawer(context),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          _customBottomBarItem(
              iconAsset: "assets/svgs/house.svg", label: "Home"),
          _customBottomBarItem(
              iconAsset: "assets/svgs/input.svg", label: "Input"),
          _customBottomBarItem(
              iconAsset: "assets/svgs/history.svg", label: "History"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onBottomNavItemTapped,
        backgroundColor: BottomNavbar,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: iconActive,
        unselectedItemColor: text,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Halaman Input Data",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: text,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoCard(),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _namaController,
                  style: GoogleFonts.poppins(color: text),
                  decoration: InputDecoration(
                    hintText: 'Nama',
                    hintStyle:
                        GoogleFonts.poppins(color: graytext.withOpacity(0.8)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                          color: defaultTextFieldBorderColor, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                          color: defaultTextFieldBorderColor, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: iconActive, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _npmController,
                  style: GoogleFonts.poppins(color: text),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    hintText: 'Npm',
                    hintStyle:
                        GoogleFonts.poppins(color: graytext.withOpacity(0.8)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                          color: defaultTextFieldBorderColor, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                          color: defaultTextFieldBorderColor, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: iconActive, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NPM tidak boleh kosong';
                    }
                    if (int.tryParse(value) == null) {
                      return 'NPM hanya boleh berisi angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _pesanController,
                  style: GoogleFonts.poppins(color: text),
                  decoration: InputDecoration(
                    hintText: 'Pesan.............................',
                    hintStyle:
                        GoogleFonts.poppins(color: graytext.withOpacity(0.8)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                          color: defaultTextFieldBorderColor, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                          color: defaultTextFieldBorderColor, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: iconActive, width: 2.0),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pesan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _kirimData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            elevation: 3,
                          ),
                          child: Text(
                            'KIRIM',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
