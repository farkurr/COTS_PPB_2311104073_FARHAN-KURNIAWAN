import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../controllers/recipe_controller.dart';
import '../widgets/stat_card.dart';
import '../widgets/recipe_card.dart';
import 'recipe_list_screen.dart';
import 'recipe_detail_screen.dart';
import 'add_recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RecipeController>().loadRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<RecipeController>(
          builder: (context, controller, child) {
            if (controller.isLoading && controller.recipes.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.error != null && controller.recipes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${controller.error}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.loadRecipes(),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final counts = controller.counts;
            final recipes = controller.recipes;

            return RefreshIndicator(
              onRefresh: () => controller.loadRecipes(),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Resep Masakan', style: AppTypography.h1),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeListScreen(),
                              ),
                            );
                          },
                          child: Text('Daftar Resep', style: TextStyle(color: AppColors.primary)),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.lg),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 1.5,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        StatCard(label: 'Total Resep', count: counts['total'] ?? 0),
                        StatCard(label: 'Sarapan', count: counts['Sarapan'] ?? 0),
                        StatCard(label: 'Makan Siang & Malam', count: (counts['Makan Siang'] ?? 0) + (counts['Makan Malam'] ?? 0)),
                        StatCard(label: 'Dessert', count: counts['Dessert'] ?? 0),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xl),
                    Text('Resep Terbaru', style: AppTypography.h3),
                    SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: ListView.builder(
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          return RecipeCard(
                            recipe: recipes[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeDetailScreen(recipe: recipes[index]),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddRecipeScreen(),
                            ),
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
                          'Tambah Resep Baru',
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
            );
          },
        ),
      ),
    );
  }
}