import '../../model/model.dart';
import 'layanan_api.dart';

/// DataService - Wrapper untuk ApiService
/// Menyediakan interface yang sama seperti sebelumnya
class DataService {
  final ApiService _api = ApiService();

  Future<List<PartModel>> getParts() async {
    return await _api.getParts();
  }

  Future<List<LevelModel>> getLevels(String partId) async {
    return await _api.getLevels(partId);
  }
}
