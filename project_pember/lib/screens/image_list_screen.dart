import 'package:flutter/material.dart';
import '../services/gallery_service.dart';
import '../services/notification_service.dart';

class ImageListScreen extends StatefulWidget {
  const ImageListScreen({Key? key}) : super(key: key);

  @override
  State<ImageListScreen> createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() {
    _images = GalleryService.getImages();
    setState(() {});
  }

  void _showNotification(int index) {
    NotificationService.showNotification(
      title: 'Image Selected',
      body: 'You selected image ${index + 1}',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification sent for image ${index + 1}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image List'),
      ),
      body: _images.isEmpty
          ? const Center(child: Text('No images found'))
          : ListView.builder(
              itemCount: _images.length,
              itemBuilder: (ctx, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ListTile(
                    leading: Image.network(
                      _images[index],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text('Image ${index + 1}'),
                    onTap: () => _showNotification(index),
                  ),
                );
              },
            ),
    );
  }
}
