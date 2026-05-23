import '../../model/model.dart';

class DataService {
  Future<List<PartModel>> getParts() async {
    return [
      PartModel(id: 'p1', title: 'Bagian 1: Agama Islam', description: 'Pelajari rukun iman, shalat, dan nabi.'),
      PartModel(id: 'p2', title: 'Bagian 2: Bahasa Indonesia', description: 'Tata bahasa, EYD, dan kosa kata.'),
      PartModel(id: 'p3', title: 'Bagian 3: Matematika', description: 'Logika berhitung, aljabar, dan angka.'),
      PartModel(id: 'p4', title: 'Bagian 4: Ilmu Pengetahuan Alam', description: 'Fisika, biologi, dan alam semesta.'),
      PartModel(id: 'p5', title: 'Bagian 5: Ilmu Pengetahuan Sosial', description: 'Sejarah pahlawan, dan geografi.'),
      PartModel(id: 'p6', title: 'Bagian 6: PPKn', description: 'Pancasila, UUD 1945, dan negara.'),
      PartModel(id: 'p7', title: 'Bagian 7: Bahasa Inggris', description: 'Vocabulary, grammar, dan dasar.'),
    ];
  }

  Future<List<LevelModel>> getLevels(String partId) async {
    return List.generate(100, (index) {
      final levelNumber = index + 1;
      return LevelModel(
        id: '${partId}_l$levelNumber',
        order: levelNumber,
        partId: partId,
        questions: [], // Diambil dari Firebase saat Level diklik (Online)
      );
    });
  }
}
