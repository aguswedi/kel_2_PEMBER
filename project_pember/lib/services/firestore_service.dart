import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  // 🔹 CREATE: Tambah produk baru
  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      await productsCollection.add(productData);
      print("✅ Produk berhasil ditambahkan.");
    } catch (e) {
      print("❌ Gagal menambahkan produk: $e");
    }
  }

  // 🔹 READ: Ambil semua produk (real-time stream)
  Stream<QuerySnapshot> getProductsStream() {
    return productsCollection.snapshots();
  }

  // 🔹 READ: Ambil satu produk berdasarkan ID
  Future<DocumentSnapshot> getProductById(String id) async {
    return await productsCollection.doc(id).get();
  }

  // 🔹 UPDATE: Update produk berdasarkan ID
  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      await productsCollection.doc(id).update(data);
      print("✅ Produk berhasil diperbarui.");
    } catch (e) {
      print("❌ Gagal memperbarui produk: $e");
    }
  }

  // 🔹 DELETE: Hapus produk berdasarkan ID
  Future<void> deleteProduct(String id) async {
    try {
      await productsCollection.doc(id).delete();
      print("✅ Produk berhasil dihapus.");
    } catch (e) {
      print("❌ Gagal menghapus produk: $e");
    }
  }
}
