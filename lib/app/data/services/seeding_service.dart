import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SeedingService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedData() async {
    // 1. Seed Categories
    final categoriesRef = _firestore.collection('categories');
    final snapshot = await categoriesRef.limit(1).get();

    if (snapshot.docs.isEmpty) {
      print("🌱 Seeding Categories...");
      final categories = [
        {'id': 'breakfast', 'name': 'Breakfast', 'icon': '🍳'},
        {'id': 'lunch', 'name': 'Lunch', 'icon': '🍱'},
        {'id': 'dinner', 'name': 'Dinner', 'icon': '🍽️'},
        {'id': 'snacks', 'name': 'Snacks', 'icon': '🍿'},
        {'id': 'desserts', 'name': 'Desserts', 'icon': '🍰'},
        {'id': 'drinks', 'name': 'Drinks', 'icon': '🥤'},
      ];

      for (var cat in categories) {
        await categoriesRef.doc(cat['id']).set(cat);
      }
      print("✅ Categories seeded.");
    } else {
      print("ℹ️ Categories already exist.");
    }
  }
}
