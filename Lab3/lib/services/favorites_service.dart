import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _favoritesCollection = 'favorites';


  static Future<void> addFavorite(String mealId, String mealName) async {
    try {
 
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Set<String> favorites =
      (prefs.getStringList('favorites') ?? <String>[]).toSet();
      favorites.add(mealId);
      await prefs.setStringList('favorites', favorites.toList());


      await _firestore.collection(_favoritesCollection).doc(mealId).set({
        'mealId': mealId,
        'mealName': mealName,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding favorite: $e');
      throw Exception('Failed to add favorite');
    }
  }


  static Future<void> removeFavorite(String mealId) async {
    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      Set<String> favorites =
      (prefs.getStringList('favorites') ?? <String>[]).toSet();
      favorites.remove(mealId);
      await prefs.setStringList('favorites', favorites.toList());


      await _firestore
          .collection(_favoritesCollection)
          .doc(mealId)
          .delete();
    } catch (e) {
      print('Error removing favorite: $e');
      throw Exception('Failed to remove favorite');
    }
  }


  static Future<bool> isFavorite(String mealId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Set<String> favorites =
      (prefs.getStringList('favorites') ?? <String>[]).toSet();
      return favorites.contains(mealId);
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }


  static Stream<QuerySnapshot> getFavoritesStream() {
    return _firestore
        .collection(_favoritesCollection)
        .orderBy('addedAt', descending: true)
        .snapshots();
  }


  static Future<Set<String>> getLocalFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites')?.toSet() ?? <String>{};
  }
}
