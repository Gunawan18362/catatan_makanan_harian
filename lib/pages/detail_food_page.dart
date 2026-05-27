import 'dart:io';
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/food_model.dart';

class DetailFoodPage extends StatefulWidget {
  final FoodModel food;

  const DetailFoodPage({
    super.key,
    required this.food,
  });

  @override
  State<DetailFoodPage> createState() => _DetailFoodPageState();
}

class _DetailFoodPageState extends State<DetailFoodPage> {
  late TextEditingController namaController;
  late TextEditingController catatanController;
  late String tanggal;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.food.namaMakanan);
    catatanController = TextEditingController(text: widget.food.catatan);
    tanggal = widget.food.tanggal;
  }

  Future<void> updateFood() async {
    final updatedFood = FoodModel(
      id: widget.food.id,
      namaMakanan: namaController.text,
      foto: widget.food.foto,
      tanggal: tanggal,
      catatan: catatanController.text,
    );

    await DBHelper.updateFood(updatedFood);
    Navigator.pop(context);
  }

  Future<void> pilihTanggal() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(tanggal),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        tanggal = date.toString().substring(0, 10);
      });
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageFile = File(widget.food.foto);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Makanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.file(
              imageFile,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 20),

            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Makanan',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            InkWell(
              onTap: pilihTanggal,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  border: OutlineInputBorder(),
                ),
                child: Text(tanggal),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: catatanController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Catatan',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateFood,
                child: const Text('Update Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}