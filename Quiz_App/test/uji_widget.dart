import 'package:flutter_test/flutter_test.dart';
import 'package:quiz/main.dart';

// Berkas uji_widget.dart berfungsi untuk melakukan pengujian unit/widget dasar pada aplikasi kuis.
void main() {
  testWidgets('Pengujian awal pembukaan widget kuis', (WidgetTester tester) async {
    // Membangun aplikasi kuis dan memicu render frame pertama.
    await tester.pumpWidget(const QuizApp());

    // Di sini kita dapat menambahkan langkah-langkah pengujian fungsionalitas UI kuis di masa mendatang.
    // Contohnya: memverifikasi teks pembuka, menekan tombol pilihan ganda, atau menguji alur perpindahan halaman.
  });
}
