import 'dart:core';

/// Enum FaseProyek untuk menghindari kesalahan penamaan fase proyek
enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

/// Mixin Kinerja untuk mengelola produktivitas karyawan
mixin Kinerja {
  int produktivitas = 0;
  DateTime lastUpdated = DateTime.now().subtract(Duration(days: 30));

  /// Fungsi untuk memperbarui produktivitas jika sudah lebih dari 30 hari
  void updateProduktivitas(int newValue) {
    final currentTime = DateTime.now();
    if (currentTime.difference(lastUpdated).inDays >= 30 &&
        newValue >= 0 &&
        newValue <= 100) {
      produktivitas = newValue;
      lastUpdated = currentTime;
      print("Produktivitas diperbarui menjadi $produktivitas");
    } else {
      print("Produktivitas hanya bisa diupdate setiap 30 hari dan dalam rentang 0-100");
    }
  }
}

/// Class dasar Produk untuk menyimpan informasi produk
class Produk {
  String namaProduk;
  double harga;
  String kategori;

  Produk(this.namaProduk, this.harga, this.kategori);
}

/// Class untuk produk NetworkAutomation dengan harga minimal 200.000
class NetworkAutomation extends Produk {
  int jumlahTerjual;

  NetworkAutomation(
      String namaProduk, double harga, this.jumlahTerjual)
      : super(namaProduk, harga, 'NetworkAutomation') {
    if (harga < 200000) throw Exception("Harga minimal untuk NetworkAutomation adalah 200.000");
  }

  /// Fungsi untuk mengatur diskon 15% untuk penjualan > 50 unit, namun harga tidak boleh < 200.000
  void terapkanDiskon() {
    if (jumlahTerjual > 50) {
      var hargaSetelahDiskon = harga * 0.85;
      if (hargaSetelahDiskon < 200000) {
        harga = 200000;
      } else {
        harga = hargaSetelahDiskon;
      }
    }
  }
}

/// Class untuk produk DataManagement dengan harga maksimal 200.000
class DataManagement extends Produk {
  DataManagement(String namaProduk, double harga)
      : super(namaProduk, harga, 'DataManagement') {
    if (harga >= 200000) throw Exception("Harga maksimal untuk DataManagement adalah 200.000");
  }
}

/// Class Karyawan untuk menyimpan informasi karyawan
abstract class Karyawan with Kinerja {
  String nama;
  int umur;
  String peran;
  bool aktif = true;

  Karyawan(this.nama, {required this.umur, required this.peran});
}

class KaryawanTetap extends Karyawan {
  KaryawanTetap(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);
}

class KaryawanKontrak extends Karyawan {
  KaryawanKontrak(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);
}

/// Class Proyek untuk mengelola fase proyek dan tim
class Proyek {
  FaseProyek faseSaatIni = FaseProyek.Perencanaan;
  List<Karyawan> timProyek = [];
  DateTime lastFaseUpdate = DateTime.now();

  /// Fungsi untuk menambah karyawan ke dalam proyek
  void tambahKaryawan(Karyawan karyawan) {
    if (timProyek.where((k) => k.aktif).length < 20) {
      timProyek.add(karyawan);
      print("${karyawan.nama} ditambahkan ke proyek");
    } else {
      print("Jumlah karyawan aktif maksimal adalah 20");
    }
  }

  /// Fungsi untuk beralih ke fase berikutnya
  void nextFase() {
    if (faseSaatIni == FaseProyek.Perencanaan &&
        timProyek.where((k) => k.aktif).length >= 5) {
      faseSaatIni = FaseProyek.Pengembangan;
      lastFaseUpdate = DateTime.now();
      print("Proyek beralih ke fase Pengembangan");
    } else if (faseSaatIni == FaseProyek.Pengembangan &&
        DateTime.now().difference(lastFaseUpdate).inDays > 45) {
      faseSaatIni = FaseProyek.Evaluasi;
      print("Proyek beralih ke fase Evaluasi");
    } else {
      print("Syarat untuk beralih fase belum terpenuhi");
    }
  }
}

void main() {
  // Buat objek produk NetworkAutomation
  var produk1 = NetworkAutomation("Sistem Otomasi Jaringan", 250000, 60);
  produk1.terapkanDiskon();
  print("Harga setelah diskon: ${produk1.harga}");

  // Buat objek produk DataManagement
  var produk2 = DataManagement("Sistem Manajemen Data", 150000);
  print("Produk: ${produk2.namaProduk}, Harga: ${produk2.harga}");

  // Buat objek karyawan
  var karyawan1 = KaryawanTetap("John Doe", umur: 30, peran: "Developer");
  var karyawan2 = KaryawanKontrak("Jane Doe", umur: 28, peran: "NetworkEngineer");

  // Buat objek proyek dan tambahkan karyawan
  var proyek = Proyek();
  proyek.tambahKaryawan(karyawan1);
  proyek.tambahKaryawan(karyawan2);

  // Update produktivitas dan beralih ke fase proyek
  karyawan1.updateProduktivitas(90);
  proyek.nextFase();
}