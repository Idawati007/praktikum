import 'dart:core';

/// Enum FaseProyek untuk memastikan konsistensi dalam penamaan fase proyek.
enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

/// Kelas ProdukDigital untuk menyimpan data produk digital
class ProdukDigital {
  String namaProduk;
  double harga;
  String kategori;

  ProdukDigital(this.namaProduk, this.harga, this.kategori);

  /// Metode untuk menerapkan diskon 15% khusus untuk produk NetworkAutomation
  void terapkanDiskon(int jumlahTerjual) {
    if (kategori == "NetworkAutomation" && jumlahTerjual > 50) {
      double hargaDiskon = harga * 0.85;
      harga = (hargaDiskon < 200000) ? 200000 : hargaDiskon;
      print("Harga setelah diskon: $harga");
    } else {
      print("Tidak ada diskon untuk produk ini.");
    }
  }
}

/// Kelas abstrak Karyawan yang mengatur template dasar karyawan
abstract class Karyawan {
  String nama;
  int umur;
  String peran;

  Karyawan(this.nama, {required this.umur, required this.peran});

  /// Metode abstrak bekerja yang harus diimplementasikan oleh subclass
  void bekerja();
}

/// Mixin Kinerja untuk mengatur produktivitas karyawan
mixin Kinerja {
  int produktivitas = 50;
  DateTime lastUpdated = DateTime.now().subtract(Duration(days: 30));

  /// Metode untuk meningkatkan produktivitas setiap 30 hari
  void updateProduktivitas() {
    final currentTime = DateTime.now();
    if (currentTime.difference(lastUpdated).inDays >= 30) {
      produktivitas += 5;
      if (produktivitas > 100) produktivitas = 100; // Maksimal produktivitas 100
      lastUpdated = currentTime;
      print("Produktivitas diperbarui menjadi: $produktivitas");
    } else {
      print("Belum 30 hari sejak update terakhir.");
    }
  }
}

/// Subclass KaryawanTetap yang mengimplementasikan metode bekerja
class KaryawanTetap extends Karyawan with Kinerja {
  KaryawanTetap(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    print("$nama (Karyawan Tetap) bekerja dengan peran $peran.");
  }
}

/// Subclass KaryawanKontrak yang mengimplementasikan metode bekerja
class KaryawanKontrak extends Karyawan with Kinerja {
  KaryawanKontrak(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    print("$nama (Karyawan Kontrak) bekerja dengan peran $peran.");
  }
}

/// Kelas Perusahaan untuk mengatur daftar karyawan aktif dan non-aktif
class Perusahaan {
  List<Karyawan> karyawanAktif = [];
  List<Karyawan> karyawanNonAktif = [];
  int maxKaryawanAktif = 20;

  /// Menambahkan karyawan ke daftar aktif jika belum mencapai batas maksimal
  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length < maxKaryawanAktif) {
      karyawanAktif.add(karyawan);
      print("${karyawan.nama} ditambahkan sebagai karyawan aktif.");
    } else {
      print("Tidak bisa menambahkan karyawan. Maksimal 20 karyawan aktif.");
    }
  }

  /// Mengubah status karyawan menjadi non-aktif
  void resignKaryawan(Karyawan karyawan) {
    if (karyawanAktif.contains(karyawan)) {
      karyawanAktif.remove(karyawan);
      karyawanNonAktif.add(karyawan);
      print("${karyawan.nama} telah resign dan dipindahkan ke daftar non-aktif.");
    } else {
      print("${karyawan.nama} tidak ditemukan di daftar karyawan aktif.");
    }
  }
}

/// Class Proyek untuk mengelola fase proyek dan aturan transisinya
class Proyek {
  FaseProyek faseSaatIni = FaseProyek.Perencanaan;
  List<Karyawan> timProyek = [];
  DateTime lastFaseUpdate = DateTime.now();

  /// Menambah karyawan ke proyek
  void tambahKaryawan(Karyawan karyawan) {
    timProyek.add(karyawan);
    print("Karyawan ${karyawan.nama} ditambahkan ke tim proyek.");
  }

  /// Memindahkan proyek ke fase berikutnya jika memenuhi syarat
  void nextFase() {
    if (faseSaatIni == FaseProyek.Perencanaan && timProyek.length >= 5) {
      faseSaatIni = FaseProyek.Pengembangan;
      lastFaseUpdate = DateTime.now();
      print("Proyek beralih ke fase Pengembangan.");
    } else if (faseSaatIni == FaseProyek.Pengembangan &&
        DateTime.now().difference(lastFaseUpdate).inDays > 45) {
      faseSaatIni = FaseProyek.Evaluasi;
      print("Proyek beralih ke fase Evaluasi.");
    } else {
      print("Syarat untuk beralih fase belum terpenuhi.");
    }
  }
}

void main() {
  // Implementasi ProdukDigital dan Diskon
  var produk = ProdukDigital("Sistem Otomasi Jaringan", 250000, "NetworkAutomation");
  produk.terapkanDiskon(60);

  // Implementasi Karyawan dengan positional dan named arguments
  var karyawanTetap = KaryawanTetap("John Doe", umur: 30, peran: "Developer");
  var karyawanKontrak = KaryawanKontrak("Jane Smith", umur: 25, peran: "Network Engineer");

  // Contoh penggunaan bekerja
  karyawanTetap.bekerja();
  karyawanKontrak.bekerja();

  // Implementasi Perusahaan dan penambahan karyawan
  var perusahaan = Perusahaan();
  perusahaan.tambahKaryawan(karyawanTetap);
  perusahaan.tambahKaryawan(karyawanKontrak);

  // Mengatur produktivitas karyawan
  karyawanTetap.updateProduktivitas();
  karyawanKontrak.updateProduktivitas();

  // Implementasi Proyek dan transisi fase
  var proyek = Proyek();
  proyek.tambahKaryawan(karyawanTetap);
  proyek.tambahKaryawan(karyawanKontrak);

  // Memindahkan fase proyek jika memenuhi syarat
  proyek.nextFase();
}