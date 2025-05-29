import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uts_pbm/global.dart';
import 'package:uts_pbm/home/home_screen.dart'; // Pastikan path ini benar
import 'package:uts_pbm/input/input_data_screen.dart'; // Pastikan path ini benar

class LihatDataScreen extends StatefulWidget {
  const LihatDataScreen({super.key});

  @override
  State<LihatDataScreen> createState() => _LihatDataScreenState();
}

class _LihatDataScreenState extends State<LihatDataScreen> {
  List<Map<String, dynamic>> _records = [];
  bool _isLoading = true;
  String? _error;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await Supabase.instance.client
          .from('InputData') // DIPERBAIKI: Menggunakan nama tabel yang benar
          .select()
          .order('id', ascending: true);

      if (!mounted) return;
      setState(() {
        _records = List<Map<String, dynamic>>.from(response as List);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = "Gagal memuat data: ${e.toString()}";
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_error!), backgroundColor: Colors.red));
    }
  }

  Future<void> _deleteRecord(dynamic recordId) async {
    bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Konfirmasi Hapus'),
              content:
                  const Text('Apakah Anda yakin ingin menghapus data ini?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child:
                      const Text('Hapus', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmDelete) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      try {
        await Supabase.instance.client
            .from('InputData') // DIPERBAIKI
            .delete()
            .match({'id': recordId});
        await _fetchData();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Data berhasil dihapus!'),
            backgroundColor: Colors.green));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Gagal menghapus data: ${e.toString()}'),
            backgroundColor: Colors.red));
      } finally {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showEditDialog(Map<String, dynamic> record) async {
    final formKeyDialog = GlobalKey<FormState>();
    final TextEditingController namaControllerDialog =
        TextEditingController(text: record['nama']?.toString() ?? '');
    final TextEditingController npmControllerDialog =
        TextEditingController(text: record['npm']?.toString() ?? '');
    final TextEditingController pesanControllerDialog =
        TextEditingController(text: record['pesan']?.toString() ?? '');
    final dynamic recordId = record['id'];
    final String displayId =
        (record['id'] as int? ?? 0).toString().padLeft(2, '0');

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Data ID: $displayId'),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
          content: SingleChildScrollView(
            child: Form(
              key: formKeyDialog,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: namaControllerDialog,
                    decoration: const InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                    style: GoogleFonts.poppins(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: npmControllerDialog,
                    decoration: const InputDecoration(
                        labelText: 'Npm',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                    style: GoogleFonts.poppins(fontSize: 14),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
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
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: pesanControllerDialog,
                    decoration: const InputDecoration(
                        labelText: 'Pesan',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                    style: GoogleFonts.poppins(fontSize: 14),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pesan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          actions: <Widget>[
            TextButton(
              child: Text('Batal', style: GoogleFonts.poppins()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20)),
              child: Text('Simpan', style: GoogleFonts.poppins()),
              onPressed: () async {
                if (formKeyDialog.currentState!.validate()) {
                  final npmValueDialog = int.tryParse(npmControllerDialog.text);
                  if (npmValueDialog == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('NPM harus berupa angka yang valid.'),
                        backgroundColor: Colors.orange));
                    return;
                  }

                  setState(() => _isLoading = true);
                  Navigator.of(context).pop();

                  try {
                    await Supabase.instance.client
                        .from('InputData') // DIPERBAIKI
                        .update({
                      'nama': namaControllerDialog.text,
                      'npm': npmValueDialog,
                      'pesan': pesanControllerDialog.text,
                    }).match({'id': recordId});
                    await _fetchData();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Data berhasil diperbarui!'),
                          backgroundColor: Colors.green));
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Gagal memperbarui data: ${e.toString()}'),
                          backgroundColor: Colors.red));
                    }
                  } finally {
                    if (mounted) {
                      setState(() => _isLoading = false);
                    }
                  }
                }
              },
            ),
          ],
        );
      },
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
            SvgPicture.asset(
              'assets/svgs/orangduduk.svg',
              height: 100,
              width: 60,
            ),
          ],
        ),
      ),
    );
  }

  void _onBottomNavItemTapped(int index) {
    if (_selectedIndex == index && index == 2) {
      _fetchData();
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InputDataScreen()),
        );
        break;
      case 2:
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

  Widget _buildMobileDataCard(Map<String, dynamic> record) {
    final int recordIdValue = record['id'] as int? ?? 0;
    final String displayFormattedId = recordIdValue.toString().padLeft(2, '0');
    final nama = record['nama']?.toString() ?? '';
    final npm = record['npm']?.toString() ?? '';
    final pesan = record['pesan']?.toString() ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ID: $displayFormattedId",
              style: GoogleFonts.poppins(
                  fontSize: 11.5, color: graytext.withOpacity(0.9)),
            ),
            const SizedBox(height: 8),
            _buildDataRowForMobile("Nama", nama),
            _buildDataRowForMobile("NPM", npm),
            _buildDataRowForMobile("Pesan", pesan, maxLines: 3),
            Divider(height: 24, thickness: 0.7, color: Colors.grey.shade300),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_note_outlined,
                      color: Colors.orange.shade800, size: 24),
                  onPressed: () => _showEditDialog(record),
                  tooltip: 'Edit',
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: Colors.red.shade700, size: 24),
                  onPressed: () => _deleteRecord(recordIdValue),
                  tooltip: 'Hapus',
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDataRowForMobile(String label, String value,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  color: text.withOpacity(0.9)),
            ),
          ),
          Text(" : ",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  color: text.withOpacity(0.9))),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 13.5, color: text),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
// Di dalam kelas _LihatDataScreenState

  // Di dalam kelas _LihatDataScreenState

  Widget _buildDataDisplayArea() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_records.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Tidak ada data untuk ditampilkan.',
            style: GoogleFonts.poppins(fontSize: 16, color: graytext),
          ),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    const breakpoint = 600.0;

    const double pageHorizontalPadding = 24.0 * 2;
    final double availableTableWidth = screenWidth - pageHorizontalPadding;

    if (screenWidth > breakpoint) {
      // Tampilan Desktop/Web (DataTable)
      // Perkiraan lebar untuk kolom yang lebih tetap
      const double idColWidth = 60;
      const double npmColWidth = 110;
      const double aksiColWidth = 90; // Cukup untuk 2 icon button

      // Sisa lebar setelah dikurangi kolom tetap dan spacing
      // Misal ada 5 kolom, berarti ada 4 spasi antar kolom
      const double totalFixedWidth = idColWidth + npmColWidth + aksiColWidth;
      const double totalColumnSpacing = 4 * 16.0; // Asumsi columnSpacing = 16.0
      double remainingWidthForFlexible =
          availableTableWidth - totalFixedWidth - totalColumnSpacing;
      if (remainingWidthForFlexible < 0)
        remainingWidthForFlexible = 0; // Hindari nilai negatif

      // Bagi sisa lebar untuk Nama dan Pesan (misal Nama 40%, Pesan 60%)
      // Beri nilai minimum jika hasil pembagian terlalu kecil
      double namaColWidth = remainingWidthForFlexible * 0.4 > 120
          ? remainingWidthForFlexible * 0.4
          : 120;
      double pesanColWidth = remainingWidthForFlexible * 0.6 > 150
          ? remainingWidthForFlexible * 0.6
          : 150;

      // Jika availableTableWidth sangat kecil, pembagian di atas mungkin tidak ideal,
      // dalam kasus tersebut, Expanded pada DataColumn akan lebih dominan.

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: availableTableWidth > 0 ? availableTableWidth : 0),
            child: DataTable(
              headingRowHeight: 50.0,
              dataRowHeight: 58.0,
              columnSpacing: 16.0,
              horizontalMargin: 10.0,
              showCheckboxColumn: false,
              headingRowColor: WidgetStateColor.resolveWith(
                  (states) => Colors.blueGrey.shade50.withOpacity(0.7)),
              headingTextStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey.shade900,
                  fontSize: 14),
              dataTextStyle:
                  GoogleFonts.poppins(color: Colors.black87, fontSize: 13.5),
              columns: <DataColumn>[
                const DataColumn(
                    label: SizedBox(
                  width: idColWidth,
                  child: Center(child: Text('ID')),
                )),
                DataColumn(
                    // Kolom Nama akan mencoba mengambil ruang
                    label: SizedBox(
                  // Bungkus dengan SizedBox untuk memberi hint lebar
                  width: namaColWidth, // Gunakan lebar yang dihitung
                  child: const Text('Nama', textAlign: TextAlign.center),
                )),
                const DataColumn(
                    label: SizedBox(
                  width: npmColWidth,
                  child: Center(child: Text('NPM')),
                )),
                DataColumn(
                    // Kolom Pesan akan mencoba mengambil ruang
                    label: SizedBox(
                  // Bungkus dengan SizedBox
                  width: pesanColWidth, // Gunakan lebar yang dihitung
                  child: const Text('Pesan', textAlign: TextAlign.center),
                )),
                const DataColumn(
                    label: SizedBox(
                  width: aksiColWidth,
                  child: Center(child: Text('Aksi')),
                )),
              ],
              rows: _records.map((record) {
                final int recordIdValue = record['id'] as int? ?? 0;
                final String displayFormattedId =
                    recordIdValue.toString().padLeft(2, '0');
                final String originalIdForTooltip =
                    record['id']?.toString() ?? 'N/A';

                return DataRow(
                  cells: <DataCell>[
                    DataCell(Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 6.0),
                        child: Tooltip(
                          message: 'ID Database: $originalIdForTooltip',
                          child: Text(displayFormattedId,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center, // Rata tengah teks
                              style: GoogleFonts.poppins(fontSize: 13)),
                        ),
                      ),
                    )),
                    DataCell(Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 8.0),
                        child: Tooltip(
                          message: record['nama']?.toString() ?? '',
                          child: Text(record['nama']?.toString() ?? '',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    )),
                    DataCell(Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 8.0),
                        child: Text(record['npm']?.toString() ?? '',
                            textAlign: TextAlign.center),
                      ),
                    )),
                    DataCell(Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 8.0),
                        child: Tooltip(
                          message: record['pesan']?.toString() ?? '',
                          child: Text(record['pesan']?.toString() ?? '',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2),
                        ),
                      ),
                    )),
                    DataCell(Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit_note_outlined,
                                color: Colors.orange.shade800, size: 22),
                            onPressed: () => _showEditDialog(record),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            constraints: const BoxConstraints(),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline,
                                color: Colors.red.shade700, size: 22),
                            onPressed: () => _deleteRecord(recordIdValue),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            constraints: const BoxConstraints(),
                            tooltip: 'Hapus',
                          ),
                        ],
                      ),
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      );
    } else {
      // Tampilan Mobile (ListView of Cards)
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _records.length,
        itemBuilder: (context, index) {
          final record = _records[index];
          return _buildMobileDataCard(record);
        },
      );
    }
  }

// ... Sisa kode _LihatDataScreenState dan widget build() utama tetap sama ...
// Pastikan Anda menyalin seluruh kelas _LihatDataScreenState jika mengganti.
// Di sini saya hanya menampilkan fungsi _buildDataDisplayArea yang diubah.

// Untuk kelengkapan, ini adalah seluruh widget build jika Anda ingin menggantinya:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
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
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Halaman Lihat Data",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: text,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoCard(),
                const SizedBox(height: 30),
                _buildDataDisplayArea(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
} // Akhir dari _LihatDataScreenState
