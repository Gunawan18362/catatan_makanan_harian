import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/db_helper.dart';
import '../models/food_model.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final namaController = TextEditingController();
  final catatanController = TextEditingController();

  String tanggal = DateTime.now().toString().substring(0, 10);
  File? selectedImage;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> saveFood() async {
    if (namaController.text.isEmpty || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama makanan dan foto wajib diisi'),
        ),
      );
      return;
    }

    final food = FoodModel(
      namaMakanan: namaController.text,
      foto: selectedImage!.path,
      tanggal: tanggal,
      catatan: catatanController.text,
    );

    await DBHelper.insertFood(food);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Makanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            selectedImage == null
                ? Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 80),
                  )
                : Image.file(
                    selectedImage!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Kamera'),
                    onPressed: () => pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.photo),
                    label: const Text('Galeri'),
                    onPressed: () => pickImage(ImageSource.gallery),
                  ),
                ),
              ],
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
                onPressed: saveFood,
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}