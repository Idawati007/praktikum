// Enum untuk peran pengguna
enum Role { Admin, Customer }

// Kelas Product untuk model produk
class Product {
  String productName;
  double price;
  bool inStock;

  Product({
    required this.productName,
    required this.price,
    required this.inStock,
  });

  // Menentukan perbandingan berdasarkan productName untuk penggunaan dalam Set
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.productName == productName;
  }

  @override
  int get hashCode => productName.hashCode;
}

// Kelas User sebagai kelas dasar untuk AdminUser dan CustomerUser
class User {
  String name;
  int age;
  late Set<Product> products; // Menggunakan late untuk inisialisasi produk
  Role? role; // Nullable karena bisa kosong atau null

  User({
    required this.name,
    required this.age,
    this.role,
  });

  // Fungsi untuk menampilkan produk
  void showProducts() {
    if (products.isEmpty) {
      print('Tidak ada produk.');
    } else {
      for (var product in products) {
        print('Nama Produk: ${product.productName}, Harga: ${product.price}, Stok: ${product.inStock ? "Tersedia" : "Tidak Tersedia"}');
      }
    }
  }
}

// Subclass AdminUser untuk pengguna dengan peran Admin
class AdminUser extends User {
  AdminUser({
    required String name,
    required int age,
    Role role = Role.Admin,
  }) : super(name: name, age: age, role: role) {
    products = <Product>{};
  }

  // Fungsi untuk menambah produk
  void addProduct(Product product) {
    if (!product.inStock) {
      print('Produk ${product.productName} tidak tersedia di stok.');
    } else {
      if (products.contains(product)) {
        print('Produk ${product.productName} sudah ada.');
      } else {
        products.add(product);
        print('Produk ${product.productName} berhasil ditambahkan.');
      }
    }
  }

  // Fungsi untuk menghapus produk
  void removeProduct(String productName) {
    int initialSize = products.length;
    products.removeWhere((product) => product.productName == productName);
    bool removed = products.length < initialSize;
    
    if (removed) {
      print('Produk $productName berhasil dihapus.');
    } else {
      print('Produk $productName tidak ditemukan.');
    }
  }
}

// Subclass CustomerUser untuk pengguna dengan peran Customer
class CustomerUser extends User {
  CustomerUser({
    required String name,
    required int age,
    Role role = Role.Customer,
  }) : super(name: name, age: age, role: role);

  // Fungsi hanya untuk melihat produk
  @override
  void showProducts() {
    super.showProducts();
  }
}

// Fungsi untuk meniru pengambilan data produk secara async
Future<Product> fetchProductDetails(String productName) async {
  await Future.delayed(Duration(seconds: 2)); // Menunggu selama 2 detik
  print('Mengambil detail produk: $productName');
  return Product(productName: productName, price: 100.0, inStock: true);
}

void main() async {
  // Buat objek Admin dan Customer
  AdminUser admin = AdminUser(name: 'Admin', age: 30);
  CustomerUser customer = CustomerUser(name: 'Customer', age: 25);

  // Admin menambahkan produk
  Product product1 = Product(productName: 'Laptop', price: 1500.0, inStock: true);
  Product product2 = Product(productName: 'Smartphone', price: 700.0, inStock: false);

  admin.addProduct(product1); // Laptop berhasil ditambahkan
  admin.addProduct(product2); // Smartphone gagal karena tidak tersedia

  // Admin mencoba menambah produk yang sudah ada
  admin.addProduct(product1); // Laptop sudah ada

  // Admin menghapus produk
  admin.removeProduct('Laptop'); // Laptop berhasil dihapus

  // Customer melihat produk yang ada
  print("\nDaftar Produk untuk Customer:");
  customer.products = Set.from(admin.products); // Customer bisa melihat produk admin
  customer.showProducts();

  // Menampilkan detail produk dengan async
  Product fetchedProduct = await fetchProductDetails('Laptop');
  print('Detail produk: ${fetchedProduct.productName}, Harga: ${fetchedProduct.price}, Stok: ${fetchedProduct.inStock ? "Tersedia" : "Tidak Tersedia"}');
}
