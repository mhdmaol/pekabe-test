# Pekabe / LillUziVert Converter

Implementasi Flutter dari tujuh gambar referensi yang disediakan pengguna. Proyek awal tidak ditemukan di workspace, jadi proyek Android dan web dibuat baru.

## Menjalankan

Dibuat dan diuji dengan Flutter 3.47.7 / Dart 3.13.5.

```sh
flutter pub get
flutter run -d chrome
# Atau dengan emulator/perangkat Android yang terhubung:
flutter run
```

## Fitur

- Enam kartu kategori dengan layout satu kolom di ponsel, dua kolom di tablet kecil, tiga kolom di desktop.
- Konversi mata uang demo, panjang, massa, suhu, volume, waktu dan kecepatan.
- Dropdown satuan, keypad, desimal, hapus digit, reset, ubah tanda dan tukar arah.
- Tombol tukar mempertahankan angka masukan dan menukar pasangan satuannya.
- Keyboard angka, titik, Backspace dan Delete juga didukung.
- Tema terang/gelap, area aman perangkat, halaman yang dapat digulir, label aksesibilitas.
- Format hasil Indonesia: 18.000 dan 1.234,56. Titik pada keypad adalah pemisah desimal; masukan ditampilkan dengan koma.

## Atomic design dan folder komponen

```text
lib/
  app.dart
  main.dart
  core/theme/app_theme.dart
  domain/
    conversion_category.dart
    conversion_engine.dart
  state/converter_controller.dart
  components/
    atoms/
      unit_badge/unit_badge.dart
      value_input/value_input.dart
      keypad_key/keypad_key.dart
      swap_button/swap_button.dart
    molecules/
      category_card/category_card.dart
      conversion_field/conversion_field.dart
    organisms/
      category_grid/category_grid.dart
      converter_panel/converter_panel.dart
      numeric_keypad/numeric_keypad.dart
    templates/
      converter_layout/converter_layout.dart
  pages/
    category_page/category_page.dart
    converter_page/converter_page.dart
```

Widget menggunakan constructor parameter dan callback. `CategoryCard` menerima data kategori dan `onTap`; `ConversionField` menerima daftar satuan, nilai, dan `onChanged`; `NumericKeypad` menerima `onKey`. Controller terpisah dari UI dan dimiliki/dibuang oleh halaman. Perhitungan ada di `ConversionEngine`; penambahan satuan dilakukan di `ConversionCatalog`.

## Acuan visual dan aset

Tujuh PNG asli disimpan di `design_reference/`. UI digambar dengan widget Flutter agar teks, ukuran, dan interaksi tetap responsif. Tidak ada screenshot yang dipakai sebagai latar UI. Font Roboto dan lisensinya dibundel di `assets/fonts/`, ikon memakai Material Icons bawaan Flutter. Font asli Figma tidak tersedia, sehingga Roboto dipilih sebagai padanan. Tidak ada aset foto/logo tambahan dalam gambar referensi.

Halaman kategori mengikuti gambar mobile; badge kecil dari kartu kompak ditampilkan pada layout beberapa kolom. Waktu dan kecepatan dipisahkan dalam pilihan mode karena keduanya tidak bisa dikonversi satu sama lain. Teks volume yang salah pada gambar mobile dibetulkan mengikuti referensi kartu volume. Status bar palsu dan bingkai perangkat tidak dibuat; sistem operasi menyediakan status bar sebenarnya. Halaman bisa digulir sehingga kartu terakhir tidak terpotong.

## Batasan data

Kurs **statis untuk demo**, bukan kurs pasar: USD = 1; IDR = 1/18.000 USD; EUR = 1,08 USD; JPY = 0,0067 USD. Tidak ada API, autentikasi, backend atau penyimpanan. Nilai USD–IDR mengikuti contoh gambar. Ganti sumber data sebelum pemakaian transaksi. Galon memakai galon AS, lbs/oz memakai avoirdupois. Hasil ditampilkan sampai enam angka desimal atau notasi ilmiah untuk nilai sangat kecil/besar. Masukan dibatasi 12 digit.

## Validasi

```sh
flutter analyze
flutter test
flutter test --dart-define=CAPTURE_PREVIEWS=true
flutter build web --release
flutter build apk --debug
```

Pemeriksaan kode bersih. Sembilan tes lolos saat pratinjau diaktifkan: nilai konversi acuan, konversi balik seluruh pasangan satuan, format Indonesia, editing masukan, navigasi/dropdown/keypad/tema, layout 320×568, 390×844 dan 1024×768, serta render pratinjau. Tes pratinjau membuat PNG di `previews/` dan dilewati pada tes biasa. Pratinjau adalah hasil render Flutter test dengan font dimuat; bukan tangkapan layar perangkat Android fisik.

Build web release berhasil. Status build Android dicatat di `VALIDATION.md`. Figma tidak dapat dibaca langsung melalui sesi browser; implementasi didasarkan pada PNG yang disediakan, sehingga kesamaan dengan layer dan token Figma asli belum diverifikasi.

## Revisi warna fitur

Hasil konversi, tombol tukar, dan aksi reset/ubah tanda memakai warna kategori dari `ConversionCatalog`: mata uang biru, panjang hijau, massa ungu, suhu oranye, volume cyan, dan waktu/kecepatan pink. Tema warna dibatasi pada halaman konversi; judul, masukan, dan keypad tetap netral sesuai referensi. Pratinjau panjang dan massa tersedia di `previews/length_mobile.png` dan `previews/mass_mobile.png`.
