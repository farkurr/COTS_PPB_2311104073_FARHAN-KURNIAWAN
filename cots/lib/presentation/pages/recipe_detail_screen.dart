import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../models/recipe.dart';
import '../../controllers/recipe_controller.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.white,
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text('Detail Resep', style: AppTypography.h2),
                  ),
                  TextButton(
                    onPressed: () => _showEditNoteDialog(context),
                    child: Text('Edit', style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(recipe.getEmoji(), style: TextStyle(fontSize: 64)),
                          SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(recipe.title, style: AppTypography.h2),
                                SizedBox(height: 4),
                                Text('Kategori: ${recipe.category}', style: AppTypography.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xl),
                      Text('Bahan-bahan', style: AppTypography.h3),
                      SizedBox(height: AppSpacing.sm),
                      ...recipe.ingredients.split(',').map((ingredient) => Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text('• ${ingredient.trim()}', style: AppTypography.bodyMedium),
                      )),
                      SizedBox(height: AppSpacing.lg),
                      Text('Langkah-langkah', style: AppTypography.h3),
                      SizedBox(height: AppSpacing.sm),
                      ...recipe.steps.split(',').asMap().entries.map((entry) => Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text('${entry.key + 1}. ${entry.value.trim()}', style: AppTypography.bodyMedium),
                      )),
                      if (recipe.note != null && recipe.note!.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.lg),
                        Text('Catatan', style: AppTypography.h3),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          recipe.note!,
                          style: AppTypography.bodyMedium.copyWith(
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Disimpan ke Favorit')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Simpan ke Favorit',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context) {
    final noteController = TextEditingController(text: recipe.note);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Catatan'),
        content: TextField(
          controller: noteController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Masukkan catatan...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (recipe.id != null) {
                final success = await context.read<RecipeController>().updateRecipeNote(
                  recipe.id!,
                  noteController.text,
                );
                
                Navigator.pop(context);
                
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Catatan berhasil diupdate')),
                  );
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                }
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }
}