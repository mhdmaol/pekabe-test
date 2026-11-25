# Hasil validasi

- Acuan: tujuh PNG pengguna di `design_reference/`; layer Figma asli belum terakses.
- Flutter 3.47.7 / Dart 3.13.5, Windows.
- `flutter analyze`: No issues found.
- `flutter test --dart-define=CAPTURE_PREVIEWS=true`: 9 tes lolos.
- Layout kategori dan konversi diuji pada 320×568, 390×844 dan 1024×768.
- Pratinjau kategori mobile, desktop dan konversi mata uang dirender; mata uang dan desktop diperiksa visual.
- `flutter build web --release --no-wasm-dry-run`: berhasil; hasil di `build/web/` pada workspace. Build mengeluarkan peringatan font Cupertino dari bawaan framework; UI aplikasi menggunakan Material Icons dan ikon pada pratinjau tampil dengan benar.
- `flutter build apk --debug`: gagal pada konfigurasi toolchain, karena Android sdkmanager gagal memasang NDK 28.2.13676358. Tidak ada APK yang dihasilkan. Pasang NDK tersebut dari Android Studio SDK Manager, lalu ulangi build. Belum diuji di perangkat Android fisik/emulator.
- Kurs mata uang masih data demo statis. Semua kategori lain dihitung offline.

PNG pratinjau berasal dari render Flutter test, bukan screenshot browser/perangkat. Paket ZIP source mengecualikan cache, hasil build, file properti SDK lokal, dan konfigurasi editor. Setelah ekstraksi, jalankan `flutter pub get` sebelum menjalankan aplikasi.

Revisi warna: pemeriksaan kode bersih, 9 tes lolos, build web release berhasil. Render panjang (2 km = 200.000 cm) dan massa (5 kg = 5.000 gram) diperiksa secara visual.
