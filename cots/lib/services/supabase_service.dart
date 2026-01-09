import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/supabase_config.dart';
import '../models/recipe.dart';

class SupabaseService {
  final String baseUrl = SupabaseConfig.baseUrl;
  final String anonKey = SupabaseConfig.anonKey;

  Map<String, String> get headers => {
    'apikey': anonKey,
    'Authorization': 'Bearer $anonKey',
    'Content-Type': 'application/json',
  };

  // GET: Ambil semua resep
  Future<List<Recipe>> getAllRecipes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rest/v1/recipes?select=*'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET: Ambil resep berdasarkan kategori
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rest/v1/recipes?select=*&category=eq.$category'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST: Tambah resep baru
  Future<Recipe> addRecipe(Recipe recipe) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/rest/v1/recipes'),
        headers: {
          ...headers,
          'Prefer': 'return=representation',
        },
        body: json.encode(recipe.toJson()),
      );

      if (response.statusCode == 201) {
        List<dynamic> data = json.decode(response.body);
        return Recipe.fromJson(data[0]);
      } else {
        throw Exception('Failed to add recipe: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // PATCH: Update catatan resep
  Future<Recipe> updateRecipeNote(int id, String note) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/rest/v1/recipes?id=eq.$id'),
        headers: {
          ...headers,
          'Prefer': 'return=representation',
        },
        body: json.encode({'note': note}),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return Recipe.fromJson(data[0]);
      } else {
        throw Exception('Failed to update recipe');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET: Count resep per kategori
  Future<Map<String, int>> getRecipeCounts() async {
    try {
      final allRecipes = await getAllRecipes();
      
      return {
        'total': allRecipes.length,
        'Sarapan': allRecipes.where((r) => r.category == 'Sarapan').length,
        'Makan Siang': allRecipes.where((r) => r.category == 'Makan Siang').length,
        'Makan Malam': allRecipes.where((r) => r.category == 'Makan Malam').length,
        'Dessert': allRecipes.where((r) => r.category == 'Dessert').length,
      };
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}