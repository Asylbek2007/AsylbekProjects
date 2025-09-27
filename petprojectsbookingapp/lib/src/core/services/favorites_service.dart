import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_rooms';
  static FavoritesService? _instance;
  static FavoritesService get instance => _instance ??= FavoritesService._();

  FavoritesService._();

  Future<Set<String>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey);
      if (favoritesJson != null) {
        final List<dynamic> favoritesList = json.decode(favoritesJson);
        return favoritesList.cast<String>().toSet();
      }
    } catch (e) {
      // Error loading favorites
    }
    return <String>{};
  }

  Future<void> saveFavorites(Set<String> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = json.encode(favorites.toList());
      await prefs.setString(_favoritesKey, favoritesJson);
    } catch (e) {
      // Error saving favorites
    }
  }

  Future<void> addFavorite(String roomName) async {
    final favorites = await getFavorites();
    favorites.add(roomName);
    await saveFavorites(favorites);
  }

  Future<void> removeFavorite(String roomName) async {
    final favorites = await getFavorites();
    favorites.remove(roomName);
    await saveFavorites(favorites);
  }

  Future<bool> isFavorite(String roomName) async {
    final favorites = await getFavorites();
    return favorites.contains(roomName);
  }

  Future<void> clearAllFavorites() async {
    await saveFavorites(<String>{});
  }
}
