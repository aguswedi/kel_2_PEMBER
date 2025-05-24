import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final List<Map<String, dynamic>> _stores = [
    {
      'name': 'Toko Doang Central',
      'address': 'Jl. Sudirman No. 123, Jakarta Pusat',
      'phone': '(021) 1234-5678',
      'hours': '09:00 - 21:00',
      'distance': '1.2 km',
    },
    {
      'name': 'Toko Doang Mall Kelapa Gading',
      'address': 'Mall Kelapa Gading, Lt. 2, Jakarta Utara',
      'phone': '(021) 8765-4321',
      'hours': '10:00 - 22:00',
      'distance': '5.7 km',
    },
    {
      'name': 'Toko Doang Pondok Indah',
      'address': 'Pondok Indah Mall, Lt. 1, Jakarta Selatan',
      'phone': '(021) 2468-1357',
      'hours': '10:00 - 22:00',
      'distance': '8.3 km',
    },
    {
      'name': 'Toko Doang Bekasi',
      'address': 'Summarecon Mall Bekasi, Lt. 3, Bekasi',
      'phone': '(021) 1357-2468',
      'hours': '10:00 - 21:00',
      'distance': '15.6 km',
    },
  ];

  String _currentLocation = 'Detecting your location...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _detectLocation();
  }

  Future<void> _detectLocation() async {
    // Simulate location detection
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _currentLocation = 'Jl. MH Thamrin No. 1, Jakarta Pusat';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Locations'),
      ),
      body: Column(
        children: [
          // Current location card
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Current Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _isLoading
                            ? Row(
                                children: [
                                  const Text('Detecting your location...'),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              )
                            : Text(_currentLocation),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Update Location'),
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        _detectLocation();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Map placeholder
          Container(
            height: 200,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Map View',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
          ),

          // Nearby stores
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nearby Stores',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View all stores
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),

          // Store list
          Expanded(
            child: ListView.builder(
              itemCount: _stores.length,
              itemBuilder: (context, index) {
                final store = _stores[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    title: Text(
                      store['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(store['address']),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14),
                            const SizedBox(width: 4),
                            Text(store['hours']),
                            const SizedBox(width: 16),
                            const Icon(Icons.phone, size: 14),
                            const SizedBox(width: 4),
                            Text(store['phone']),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          store['distance'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const Text('away'),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      // Show store details
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}