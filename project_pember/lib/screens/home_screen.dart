import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/app_drawer.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'location_screen.dart';
import 'product_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ImagePicker _picker = ImagePicker();

  // Untuk menampilkan gambar & lokasi terbaru yang diambil
  File? _lastImageFile;
  double? _lastLatitude;
  double? _lastLongitude;

  final List<Widget> _screens = [
    const SizedBox(), // Untuk Home
    const LocationScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Toko Doang',
    'Store Locations',
    'Notifications',
    'My Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _deleteProduct(String id) async {
    await FirebaseFirestore.instance.collection('products').doc(id).delete();
  }

  Future<bool> _checkPermissions() async {
    final locStatus = await Permission.location.request();
    final storageStatus = await Permission.storage.request();

    return locStatus.isGranted && storageStatus.isGranted;
  }

  Future<void> _pickImage(String source) async {
    bool permissionsGranted = await _checkPermissions();
    if (!permissionsGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin lokasi dan penyimpanan dibutuhkan')),
      );
      return;
    }

    final pickedFile = await _picker.pickImage(
      source: source == 'Kamera' ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 80,
    );

    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada gambar dipilih')),
      );
      return;
    }

    // Dapatkan lokasi terkini
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mendapatkan lokasi')),
      );
      return;
    }

    // Simpan gambar ke direktori aplikasi
    final directory = await getApplicationDocumentsDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
    final savedImage = await File(pickedFile.path).copy('${directory.path}/$fileName');

    // Simpan data ke Firestore di collection 'images' (misal)
    await FirebaseFirestore.instance.collection('images').add({
      'imagePath': savedImage.path,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': Timestamp.now(),
    });

    setState(() {
      _lastImageFile = savedImage;
      _lastLatitude = position.latitude;
      _lastLongitude = position.longitude;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$source berhasil disimpan dengan lokasi')),
    );
  }

  Widget _buildProductList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('products')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data!.docs;

        if (products.isEmpty) {
          return const Center(child: Text('Belum ada produk.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: products.length,
          itemBuilder: (ctx, i) {
            final product = products[i];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                leading: const Icon(Icons.shopping_bag, size: 32),
                title: Text(
                  product['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  'Rp ${product['price']}',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductFormScreen(product: product),
                        ),
                      );
                    } else if (value == 'delete') {
                      _deleteProduct(product.id);
                    }
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHomeTab = _selectedIndex == 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 2,
        actions: [
          if (isHomeTab)
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed('/cart');
              },
            ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          if (isHomeTab)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Kamera"),
                    onPressed: () => _pickImage("Kamera"),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo),
                    label: const Text("Galeri"),
                    onPressed: () => _pickImage("Galeri"),
                  ),
                ],
              ),
            ),
          if (isHomeTab && _lastImageFile != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.file(
                    _lastImageFile!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lokasi:\nLat: ${_lastLatitude?.toStringAsFixed(5)}, Lon: ${_lastLongitude?.toStringAsFixed(5)}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          Expanded(
            child: isHomeTab ? _buildProductList() : _screens[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Locations'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: isHomeTab
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProductFormScreen(),
                  ),
                );
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
