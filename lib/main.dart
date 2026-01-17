// ignore_for_file: deprecated_member_use

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kalkulator_siplah_user_fix/privacy_policy_page.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalkulator SIPLAH',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xfff3f5f7),
      ),
      home: const TaxCalculatorForm(),
    );
  }
}

class TaxCalculatorForm extends StatefulWidget {
  const TaxCalculatorForm({super.key});

  @override
  State<TaxCalculatorForm> createState() => _TaxCalculatorFormState();
}

class _TaxCalculatorFormState extends State<TaxCalculatorForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  static const double potonganAplikasi = 10000;

  double dpp = 0, ppn = 0, pph = 0, potongan = 0, total = 0;
  double potApp = 0;

  @override
  void initState() {
    super.initState();
    priceController.addListener(hitung);
  }

  void hitung() {
    double price = _parse(priceController.text);

    potApp = price > 0 ? potonganAplikasi : 0;

    dpp = price > 0 ? price * 100 / 111 : 0;
    ppn = dpp * 0.11;
    pph = dpp * 0.005;

    potongan = price * 0.10;

    total = price - (ppn + pph + potongan + potApp);
    total = total < 0 ? 0 : total;

    setState(() {});
  }

  double _parse(String v) =>
      double.tryParse(v.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

  String rp(double v) => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(v).replaceAll(',', '.');

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _exportPdfWeb() async {
    // Validasi input
    if (nameController.text.isEmpty || _parse(priceController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Nama Barang dan Pagu Anggaran harus diisi terlebih dahulu!',
            style: TextStyle(color: Colors.white), // teks tetap putih
          ),
          backgroundColor: Colors.red, // ini bikin background merah
          duration: const Duration(seconds: 2),
        ),
      );
      return; // hentikan proses export
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Estimasi Harga Barang',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text('Nama Barang: ${nameController.text}'),
                pw.Text('Pagu Anggaran: ${rp(_parse(priceController.text))}'),
                pw.Divider(),
                pw.Text(
                  'Estimasi Harga Pasaran: ${rp(total)}',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final bytes = await pdf.save();

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'estimasi_siplah.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kalkulator SIPLAH',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        elevation: 6,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF42A5F5), Color(0xFF26C6DA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.description_outlined, color: Colors.white),
            tooltip: 'Privacy Policy',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double widthFactor;

          if (constraints.maxWidth < 600) {
            // HP
            widthFactor = 1.0;
          } else if (constraints.maxWidth < 1000) {
            // Tablet
            widthFactor = 0.8;
          } else {
            // Desktop
            widthFactor = 0.5;
          }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 90),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: widthFactor,
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
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Input Data',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.picture_as_pdf),
                                    tooltip: 'Export PDF',
                                    onPressed: _exportPdfWeb,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _textField('Nama Barang', nameController),
                              const SizedBox(height: 12),
                              _currencyField('Pagu Anggaran', priceController),
                              const SizedBox(height: 16),
                              const Divider(height: 32),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Harga Barang',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    rp(total),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '* Nilai yang ditampilkan merupakan estimasi harga dan dapat berbeda dengan harga transaksi sebenarnya.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Banner tetap di bawah
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text(
                      'Banner AdMob Placeholder (Full Width)',
                      style: TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _textField(String label, TextEditingController c) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _currencyField(String label, TextEditingController c) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CurrencyTextInputFormatter(),
      ],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class CurrencyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String value = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final result = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(int.tryParse(value) ?? 0).replaceAll(',', '.');

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
