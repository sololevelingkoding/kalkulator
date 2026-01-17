import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white, // Judul putih
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 6,
        iconTheme: const IconThemeData(
          color: Colors.white, // Back button putih
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF42A5F5), Color(0xFF26C6DA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Kami di Kalkulator SIPLAH sangat menghargai privasi Anda dan berkomitmen untuk menjaga keamanan data. Halaman ini menjelaskan bagaimana kebijakan terkait iklan yang mungkin tampil.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 16),
                Text(
                  'Poin Penting:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '• Web ini digunakan untuk menghitung estimasi harga.\n'
                  '• Tidak ada informasi yang dikirim ke server manapun.\n'
                  '• Banner iklan (AdMob) dapat menampilkan iklan dari pihak ketiga, dan kontennya diatur oleh Google.\n'
                  '• Dengan menggunakan aplikasi ini, Anda lebih mudah untuk menghitung estimasi anggaran.\n'
                  '• Kami berusaha menjaga pengalaman Anda tetap aman dan nyaman, tanpa memungut biaya tambahan.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 16),
                Text(
                  'Jika Anda memiliki pertanyaan lebih lanjut mengenai privasi atau penggunaan aplikasi ini, silakan hubungi pengembang.',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
