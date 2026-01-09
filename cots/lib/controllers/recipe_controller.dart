import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/supabase_service.dart';

class RecipeController extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  List<Recipe> _recipes = [];
  Map<String, int> _counts = {};
  bool _isLoading = false;
  String? _error;

  List<Recipe> get recipes => _recipes;
  Map<String, int> get counts => _counts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load semua resep
  Future<void> loadRecipes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _recipes = await _supabaseService.getAllRecipes();
      _counts = await _supabaseService.getRecipeCounts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load resep berdasarkan kategori
  Future<void> loadRecipesByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (category == 'Semua') {
        _recipes = await _supabaseService.getAllRecipes();
      } else {
        _recipes = await _supabaseService.getRecipesByCategory(category);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tambah resep baru
  Future<bool> addRecipe(Recipe recipe) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _supabaseService.addRecipe(recipe);
      await loadRecipes(); // Refresh data
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update catatan resep
  Future<bool> updateRecipeNote(int id, String note) async {
    try {
      await _supabaseService.updateRecipeNote(id, note);
      await loadRecipes(); // Refresh data
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Filter resep lokal (untuk search)
  List<Recipe> filterRecipes(String query) {
    if (query.isEmpty) return _recipes;
    
    return _recipes.where((recipe) {
      return recipe.title.toLowerCase().contains(query.toLowerCase()) ||
             recipe.ingredients.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}