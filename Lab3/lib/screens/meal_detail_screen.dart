import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({
    Key? key,
    required this.mealId,
  }) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late Future<MealDetail> _mealDetail;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _mealDetail = ApiService.fetchMealDetail(widget.mealId);
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final isFav = await FavoritesService.isFavorite(widget.mealId);
    setState(() {
      _isFavorite = isFav;
    });
  }

  Future<void> _toggleFavorite(String mealName) async {
    try {
      if (_isFavorite) {
        await FavoritesService.removeFavorite(widget.mealId);
      } else {
        await FavoritesService.addFavorite(widget.mealId, mealName);
      }
      setState(() {
        _isFavorite = !_isFavorite;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite ? '❤️ Added to favorites' : 'Removed from favorites',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _launchYoutube(String url) async {
    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          _showUrlDialog(url);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching URL: $e')),
        );
      }
    }
  }

  void _showUrlDialog(String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open YouTube'),
        content: const Text('Would you like to copy the YouTube link?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('URL copied to clipboard!')),
              );
            },
            child: const Text('Copy Link'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        elevation: 0,
      ),
      body: FutureBuilder<MealDetail>(
        future: _mealDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _mealDetail =
                            ApiService.fetchMealDetail(widget.mealId);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final meal = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Stack(
                  children: [
                    Image.network(
                      meal.strMealThumb,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 300,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 300,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 64),
                        );
                      },
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                            size: 24,
                          ),
                          onPressed: () => _toggleFavorite(meal.strMeal),
                        ),
                      ),
                    ),
                  ],
                ),


                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        meal.strMeal,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),


                      Row(
                        children: [
                          Chip(
                            label: Text(meal.strCategory),
                            backgroundColor: Colors.deepOrange[100],
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(meal.strArea),
                            backgroundColor: Colors.blue[100],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),


                      if (meal.strYoutube != null &&
                          meal.strYoutube!.isNotEmpty)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.play_circle_fill),
                          label: const Text('Watch on YouTube'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () =>
                              _launchYoutube(meal.strYoutube ?? ''),
                        ),

                      const SizedBox(height: 20),


                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              labelColor: Colors.deepOrange,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.deepOrange,
                              tabs: const [
                                Tab(text: 'Ingredients'),
                                Tab(text: 'Instructions'),
                              ],
                            ),
                            SizedBox(
                              height: 400,
                              child: TabBarView(
                                children: [

                                  ListView.builder(
                                    itemCount: meal.ingredients.length,
                                    itemBuilder: (context, index) {
                                      final ingredient =
                                      meal.ingredients[index];
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor:
                                          Colors.deepOrange[100],
                                          child: Text('${index + 1}'),
                                        ),
                                        title: Text(ingredient.name),
                                        subtitle: Text(ingredient.measure),
                                      );
                                    },
                                  ),


                                  SingleChildScrollView(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      meal.strInstructions,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
