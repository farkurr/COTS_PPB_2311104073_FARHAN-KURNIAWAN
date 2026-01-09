import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../models/recipe.dart';
import '../../controllers/recipe_controller.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Sarapan';
  final _titleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

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
                  Text('Tambah Resep', style: AppTypography.h2),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
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
                        Text('Judul Resep', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'Judul Resep',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.all(AppSpacing.md),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Judul resep wajib diisi';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 4),
                        Text('Judul resep wajib diisi', style: AppTypography.caption),
                        SizedBox(height: AppSpacing.lg),
                        Text('Kategori', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: AppSpacing.sm),
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.all(AppSpacing.md),
                          ),
                          items: ['Sarapan', 'Makan Siang', 'Makan Malam', 'Dessert']
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                        SizedBox(height: AppSpacing.lg),
                        Text('Bahan-bahan', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _ingredientsController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Masukkan bahan, pisahkan dengan koma',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.all(AppSpacing.md),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bahan-bahan wajib diisi';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppSpacing.lg),
                        Text('Langkah-langkah', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _stepsController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Masukkan langkah, pisahkan dengan koma',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.all(AppSpacing.md),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Langkah-langkah wajib diisi';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppSpacing.lg),
                        Text('Catatan', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _notesController,
                          decoration: InputDecoration(
                            hintText: 'Catatan tambahan (opsional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.all(AppSpacing.md),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppColors.border),
                      ),
                      child: Text(
                        'Batal',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitRecipe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                              ),
                            )
                          : Text(
                              'Simpan',
                              style: AppTypography.bodyLarge.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitRecipe() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final recipe = Recipe(
        title: _titleController.text,
        category: _selectedCategory,
        ingredients: _ingredientsController.text,
        steps: _stepsController.text,
        note: _notesController.text.isEmpty ? null : _notesController.text,
      );

      final success = await context.read<RecipeController>().addRecipe(recipe);

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Resep berhasil ditambahkan!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan resep. Coba lagi.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}