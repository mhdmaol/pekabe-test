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
- Konversi mata uang via API Frankfurter, panjang, massa, suhu, volume, waktu dan kecepatan.
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
    currency_rates.dart
  data/currency_rate_source.dart
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
      currency_rate_status/currency_rate_status.dart
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

Mata uang memakai [Frankfurter v2](https://frankfurter.dev/) tanpa API key:

```text
GET https://api.frankfurter.dev/v2/rates?base=USD&quotes=IDR,EUR,JPY
```

Kurs diambil ketika halaman mata uang dibuka, aplikasi kembali aktif, atau pengguna menekan **Perbarui kurs**. Tidak ada polling di latar belakang. API menyediakan kurs referensi, bukan harga pasar per detik. UI menampilkan tanggal kurs dari API (rentang jika berbeda antar mata uang) serta waktu pemeriksaan dalam waktu lokal perangkat. Konversi antar mata uang memakai satu snapshot berbasis USD: `amount / rateFrom * rateTo`.

Permintaan dibatasi 12 detik dan client ditutup setelah selesai. HTTP error, JSON rusak, tanggal tidak valid, kurs nol/negatif, dan mata uang yang hilang ditolak. Tanpa data berhasil, hasil ditampilkan sebagai `—`; tidak ada fallback ke kurs demo. Jika refresh gagal, snapshot terakhir pada halaman yang sama dipertahankan dengan pesan yang jelas. Snapshot hanya disimpan di memori halaman, bukan disk; membuka kembali halaman memerlukan koneksi. Keypad, dropdown, dan swap tidak membuat permintaan tambahan. Android release memiliki izin Internet; akses API web/CORS telah diperiksa.

Satuan selain mata uang tetap offline. Galon memakai galon AS; lbs/oz memakai avoirdupois. Hasil ditampilkan sampai enam angka desimal atau notasi ilmiah untuk nilai sangat kecil/besar. Masukan dibatasi 12 digit.

## Validasi

```sh
flutter analyze
flutter test
flutter test --dart-define=CAPTURE_PREVIEWS=true
flutter build web --release
flutter build apk --debug
```

Pemeriksaan kode bersih. Empat belas tes lolos dengan pratinjau diaktifkan: perhitungan satuan, format angka, input, UI dan layout pada tiga ukuran layar, parsing respons API, cross currency dan arah balik, penolakan respons tidak valid, timeout, retry, penyimpanan snapshot terakhir, pemuatan saat resume, serta keluar halaman selama permintaan berlangsung.

Tes memakai `CurrencyRateSource` yang diinjeksi dan respons tiruan sehingga tidak bergantung jaringan. Pratinjau `currency_mobile.png` juga memakai fixture deterministik (bukan bukti kurs terkini). Pemeriksaan jaringan sungguhan dapat diulang dengan:

```sh
dart run tool/check_currency_api.dart
```

Build web release berhasil. Status Android dicatat di `VALIDATION.md`; belum diuji di perangkat fisik. Implementasi visual didasarkan pada PNG, bukan layer/token Figma asli.

## Revisi warna fitur

Hasil konversi, tombol tukar, dan aksi reset/ubah tanda memakai warna kategori dari `ConversionCatalog`: mata uang biru, panjang hijau, massa ungu, suhu oranye, volume cyan, dan waktu/kecepatan pink. Tema warna dibatasi pada halaman konversi; judul, masukan, dan keypad tetap netral sesuai referensi. Pratinjau panjang dan massa tersedia di `previews/length_mobile.png` dan `previews/mass_mobile.png`.
