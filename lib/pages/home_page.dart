import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/food_model.dart';
import '../widgets/food_cart.dart';
import 'add_food_page.dart';
import 'detail_food_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FoodModel> foods = [];

  @override
  void initState() {
    super.initState();
    loadFoods();
  }

  Future<void> loadFoods() async {
    final data = await DBHelper.getFoods();
    setState(() {
      foods = data;
    });
  }

  Future<void> deleteFood(int id) async {
    await DBHelper.deleteFood(id);
    loadFoods();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data makanan berhasil dihapus'),
      ),
    );
  }

  Future<void> confirmDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Data'),
          content: const Text('Apakah kamu yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      deleteFood(id);
    }
  }

  Future<void> goToAddPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddFoodPage(),
      ),
    );

    loadFoods();
  }

  Future<void> goToDetailPage(FoodModel food) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailFoodPage(food: food),
      ),
    );

    loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Journal'),
        centerTitle: true,
      ),
      body: foods.isEmpty
          ? const Center(
              child: Text(
                'Belum ada makanan yang dicatat',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];

                return FoodCard(
                  food: food,
                  onTap: () {
                    goToDetailPage(food);
                  },
                  onDelete: () {
                    confirmDelete(food.id!);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToAddPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}