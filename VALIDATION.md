# Hasil validasi

## Integrasi kurs API

- Flutter 3.47.7 / Dart 3.13.5, Windows.
- Provider: https://frankfurter.dev/ (v2), tanpa API key.
- `dart run tool/check_currency_api.dart`: berhasil memanggil kode integrasi ke API sungguhan untuk USD/IDR, USD/EUR, USD/JPY.
- Respons saat pemeriksaan bertanggal 25 November 2026. Nilainya dapat berubah; angka tes tidak dianggap sebagai kurs terbaru.
- API diuji dengan header Origin lokal; respons menyediakan `Access-Control-Allow-Origin: *`.
- `flutter analyze`: bersih setelah perbaikan lint.
- `flutter test --dart-define=CAPTURE_PREVIEWS=true`: 14 tes lolos.
- Tes mencakup loading, gagal lalu retry, kurs terakhir setelah refresh gagal, timeout, data tidak lengkap/rusak, kurs nol/negatif, tanggal invalid, cross currency, reverse, resume dan keluar halaman saat fetch masih berlangsung.
- Tes UI dan PNG menggunakan fixture yang diinjeksi; tidak menggunakan jaringan sungguhan. Layout diuji pada 320×568, 390×844 dan 1024×768.
- Snapshot hanya di memori halaman, tanpa cache disk. Tidak ada fallback angka demo.
- Izin Internet ditambahkan ke manifest utama Android agar berlaku pada release.

## Build dan visual

- Build web release diverifikasi ulang setelah integrasi API.
- Pratinjau memakai font Roboto dan Material Icons yang dimuat dalam Flutter test, bukan screenshot perangkat.
- Build web masih mengeluarkan peringatan font Cupertino bawaan framework; UI menggunakan Material Icons dan ikon dirender dengan benar.
- Percobaan build Android sebelumnya gagal karena sdkmanager tidak berhasil memasang NDK 28.2.13676358. Belum ada APK atau tes perangkat Android. Pasang NDK tersebut lalu jalankan `flutter build apk --debug`.
- Tampilan mengacu pada tujuh PNG pengguna di `design_reference/`; layer Figma asli belum terverifikasi.
