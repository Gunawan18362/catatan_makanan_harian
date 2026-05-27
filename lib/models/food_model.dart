class FoodModel {
  int? id;
  String namaMakanan;
  String foto;
  String tanggal;
  String catatan;

  FoodModel({
    this.id,
    required this.namaMakanan,
    required this.foto,
    required this.tanggal,
    required this.catatan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_makanan': namaMakanan,
      'foto': foto,
      'tanggal': tanggal,
      'catatan': catatan,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      id: map['id'],
      namaMakanan: map['nama_makanan'],
      foto: map['foto'],
      tanggal: map['tanggal'],
      catatan: map['catatan'],
    );
  }
}