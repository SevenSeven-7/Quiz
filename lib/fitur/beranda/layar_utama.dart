import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../progres/penyedia_progres.dart';
import 'layar_beranda.dart';

// Provider reaktif untuk menyimpan dan memperbarui nama pemain secara waktu-nyata
final playerNameProvider = StateProvider<String>((ref) => 'Pemain');

// Layar utama yang menyediakan navigasi tab antara Beranda dan Profil.
class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPlayerName();
  }

  // Memuat nama pemain dari penyimpanan lokal
  Future<void> _loadPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('player_name') ?? 'Pemain';
    ref.read(playerNameProvider.notifier).state = name;
  }

  // Membangun daftar halaman tab
  final List<Widget> _pages = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width > 600;

    Widget bodyContent = IndexedStack(
      index: _currentIndex,
      children: _pages,
    );

    if (isLargeScreen) {
      return Scaffold(
        body: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: NavigationRail(
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                backgroundColor: Colors.black,
                selectedIconTheme: const IconThemeData(color: AppColors.primary),
                unselectedIconTheme: const IconThemeData(color: Colors.grey),
                selectedLabelTextStyle: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelTextStyle: const TextStyle(
                  color: Colors.grey,
                ),
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Beranda'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: Text('Profil'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: bodyContent,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: bodyContent,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.black,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            elevation: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Layar Profil Pemain yang menampilkan statistik tingkat kecerdasan dan opsi edit nama.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // Membuka dialog edit nama yang premium dan terikat validasi
  void _showEditNameDialog(BuildContext context, WidgetRef ref, String currentName) {
    final TextEditingController controller = TextEditingController(text: currentName);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
          ),
          title: Row(
            children: [
              const Icon(Icons.edit, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                'Ubah Nama Pemain',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Masukkan nama baru Anda untuk memperbarui profil Quiz.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  maxLength: 15,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                    filled: true,
                    fillColor: Colors.black,
                    hintText: 'Nama baru...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    counterStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tidak boleh kosong!';
                    }
                    if (value.trim().length < 3) {
                      return 'Nama terlalu pendek! (Min. 3 karakter)';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                
                final newName = controller.text.trim();
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('player_name', newName);
                
                ref.read(playerNameProvider.notifier).state = newName;
                
                // Menyinkronkan data progres lokal dengan awan Firestore berdasarkan nama pemain baru
                await ref.read(progressProvider.notifier).syncWithFirebase(newName);
                
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.success,
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          Text('Nama berhasil diubah menjadi "$newName"!', style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerName = ref.watch(playerNameProvider);
    final progress = ref.watch(progressProvider);
    
    final totalStars = progress.totalStars;
    final gelar = progress.gelarKecerdasan;
    final warnaGelar = progress.warnaGelar;
    
    final bindoSolved = progress.indonesianSolved;
    final mathSolved = progress.mathSolved;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              
              // Kartu Avatar & Info Utama Profil
              Center(
                child: Column(
                  children: [
                    // Avatar Dinamis dengan Warna Gelar
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: warnaGelar, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: warnaGelar.withOpacity(0.3),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black,
                        child: Text(
                          playerName.isNotEmpty ? playerName[0].toUpperCase() : 'P',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: warnaGelar,
                          ),
                        ),
                      ),
                    ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 16),
                    
                    // Nama Pemain
                    Text(
                      playerName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 8),
                    
                    // Badge Gelar Kecerdasan yang Dinamis
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: warnaGelar.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: warnaGelar.withOpacity(0.4), width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.military_tech, color: warnaGelar, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            gelar,
                            style: TextStyle(
                              color: warnaGelar,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Kartu Ringkasan Prestasi
              Text(
                'Statistik Kecerdasan',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ).animate().fadeIn(delay: 450.ms),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    // Total Bintang
                    _buildStatRow(
                      context,
                      icon: Icons.stars,
                      iconColor: Colors.amber,
                      label: 'Total Bintang',
                      value: '$totalStars ⭐',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: Colors.white10, height: 1),
                    ),
                    
                    // Bahasa Indonesia Solved
                    _buildStatRow(
                      context,
                      icon: Icons.language,
                      iconColor: AppColors.primary,
                      label: 'Bahasa Indonesia',
                      value: '$bindoSolved / 100 Level',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: Colors.white10, height: 1),
                    ),
                    
                    // Matematika Solved
                    _buildStatRow(
                      context,
                      icon: Icons.calculate,
                      iconColor: AppColors.success,
                      label: 'Matematika',
                      value: '$mathSolved / 100 Level',
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.1, end: 0),
              
              const SizedBox(height: 32),
              
              // Tombol Aksi (Ubah Nama)
              ElevatedButton.icon(
                onPressed: () => _showEditNameDialog(context, ref, playerName),
                icon: const Icon(Icons.edit_note, color: Colors.white),
                label: const Text(
                  'UBAH NAMA PEMAIN',
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                  ),
                ),
              ).animate().fadeIn(delay: 650.ms),
            ],
          ),
        ),
      ),
    );
  }

  // Baris helper untuk widget statistik
  Widget _buildStatRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ],
    );
  }
}
