#!/bin/bash

ManipulasiHakAkses() {
    echo "=== Ubah Hak Akses File ==="
    read -p "Masukkan nama file: " file

    if [ ! -e "$file" ]; then
        echo "File tidak ditemukan!"
        return
    fi

    echo "Panduan Menentukan Hak Akses:"
    echo "---------------------------------------------"
    echo "1. Hak Akses dalam Mode Numerik:"
    echo "   - 0: Tidak ada izin."
    echo "   - 1: Hanya Execute (x)."
    echo "   - 2: Hanya Write (w)."
    echo "   - 3: Write (w) + Execute (x)."
    echo "   - 4: Hanya Read (r)."
    echo "   - 5: Read (r) + Execute (x)."
    echo "   - 6: Read (r) + Write (w)."
    echo "   - 7: Read (r) + Write (w) + Execute (x)."
    echo "   Contoh: 755 (User=rwx, Group=rx, Others=rx)"
    echo ""
    echo "2. Hak Akses dalam Mode Simbolik:"
    echo "   - Format: [kategori][operator][izin]"
    echo "     Kategori: u (user), g (group), o (others), a (all)"
    echo "     Operator: + (tambahkan), - (hapus), = (tetapkan)"
    echo "     Izin: r (read), w (write), x (execute)"
    echo "   Contoh:"
    echo "     - u+rwx: Tambahkan semua izin untuk user."
    echo "     - g+rw: Tambahkan izin read dan write untuk group."
    echo "     - o+r: Tambhkan izin read untuk others."
    echo "     - o-r: Hapus izin read dari others."
    echo "     - u=rwx,g=rw,o=r: Tetapkan izin lengkap."
    echo "---------------------------------------------"
    echo ""

    echo "Pilih mode pengubahan hak akses:"
    echo "1. Mode Numerik (contoh: 755)"
    echo "2. Mode Simbolik (contoh: u=rwx, g=rw, o=r atau u+rwx, g+rw, o+r atau u-rwx, g-rw, o-r)"
    read -p "Pilih (1/2): " mode

    # Opsi mode numerik
    if [ "$mode" == "1" ]; then
        read -p "Masukkan nilai numerik (contoh: 755): " numerik
        # Validasi input hanya angka
        if [[ "$numerik" =~ ^[0-7]{3}$ ]]; then
            chmod "$numerik" "$file"
            echo "Hak akses file '$file' berhasil diubah ke mode numerik: $numerik."
        else
            echo "Input tidak valid! Pastikan hanya angka 0-7 dengan 3 digit."
        fi

    # Opsi mode simbolik
    elif [ "$mode" == "2" ]; then
        read -p "Masukkan nilai simbolik (contoh: u+rwx,g+rw): " simbolik
        # Validasi input simbolik
        if [[ "$simbolik" =~ ^[ugo]+[+=-][rwx,]*$ ]]; then
            chmod "$simbolik" "$file"
            echo "Hak akses file '$file' berhasil diubah ke mode simbolik: $simbolik."
        else
            echo "Input tidak valid! Pastikan format simbolik benar (contoh: u=rwx)."
        fi

    # Jika pilihan tidak valid
    else
        echo "Pilihan tidak valid! Silakan coba lagi."
    fi
}


# Direktori tempat file aplikasi desktop disimpan
app_dirs=("/usr/share/applications" "$HOME/.local/share/applications")

# Fungsi untuk mencari dan membuka aplikasi berdasarkan input pengguna
MembukaAplikasi() {
    echo "Ketik nama aplikasi yang ingin dibuka (contoh: Calculator, Firefox, App Center):"
    read nama_aplikasi

    # Normalisasi input untuk mengabaikan huruf besar/kecil
    nama_aplikasi_normalized=$(echo "$nama_aplikasi" | tr '[:upper:]' '[:lower:]')

    # Cari aplikasi yang cocok di direktori desktop
    for direktori in "${app_dirs[@]}"; do
        if [ -d "$direktori" ]; then
            for file in "$direktori"/*.desktop; do
                if [ -f "$file" ]; then
                    if grep -i "^Name=.*$nama_aplikasi" "$file" || grep -i "^Name=.*$nama_aplikasi_normalized" "$file"; then
                        echo "Memcoba membuka aplikasi: $nama_aplikasi"
                        gtk-launch $(basename "$file" .desktop) &
                        return
                    fi
                fi
            done
        fi
    done

    # Jika aplikasi tidak ditemukan di file desktop, coba jalankan langsung berdasarkan nama
    echo "Mencoba membuka aplikasi secara langsung: $nama_aplikasi"
    if command -v "$nama_aplikasi_normalized" >/dev/null 2>&1; then
        "$nama_aplikasi_normalized" &
        return
    fi

    echo "Aplikasi '$nama_aplikasi' tidak ditemukan. Pastikan nama yang dimasukkan benar."
}

#fungsi untuk menghitung BMI

Kalkulator_BMI(){
hitung_bmi() {
  local berat=$1 #Menggunakan variabel global yaitu local, agar variabel dapat diakses diluar fungsi.
  local tinggi=$2 #Menggunakan variabel global yaitu local, agar variabel dapat diakses diluar fungsi.
  echo "scale=2; $berat / ($tinggi * $tinggi)" | bc
}

#fungsi untuk memberikan saran olahraga berdasarkan BMI
saran_olahraga() {
  local bmi=$1
  echo -n "Saran Kegiatan Olahraga: "
  if (( $(echo "$bmi < 18" | bc -l) )); then
    echo "Anda dapat melakukan olahraga ringan seperti jogging."
  elif (( $(echo "$bmi >= 18 && $bmi < 25" | bc -l) )); then
    echo "Anda dapat melakukan olahraga seperti berenang, bersepeda."
  elif (( $(echo "$bmi >= 25 && $bmi < 27" | bc -l) )); then
    echo "Anda disarankan untuk melakukan olahraga aerobik, angkat berat."
  else 
    echo "Anda disarankan untuk konsultasi ke dokter atau ahli gizi."
  fi
}

#loop utama
while true; do
  read -p "Masukkan jumlah pengguna yang dihitung BMI-nya: " jumlah_pengguna

  for (( i = 1; i <= jumlah_pengguna; i++ )); do
    echo -e "\npengguna $i:"
    read -p "Masukkan nama Anda: " nama
    read -p "Masukkan jenis kelamin Anda (p atau w): " jenis_kelamin
    read -p "Masukkan berat badan Anda (kg): " berat
    read -p "Masukkan tinggi badan Anda (m): " tinggi

    #validasi tinggi badan 
    if (( $(echo "$tinggi <= 0" | bc -l) )); then
      echo "Tinggi badan tidak valid. Harus lebih besar dari 0."
      ((i--))
      continue 
    fi

    #menghitung BMI
    bmi=$(hitung_bmi "$berat" "$tinggi")
    echo "BMI Anda, $nama, adalah: $bmi"

    #Klasifikasi berdasarkan jenis kelamin
    if [[ "$jenis_kelamin" == "p" || "$jenis_kelamin" == "P" ]]; then
      if (( $(echo "$bmi < 18" | bc -l) )); then
        echo "$nama, Anda berada dalam kategori: Kurus"
      elif (( $(echo "$bmi >= 18 && $bmi < 25" | bc -l) )); then
        echo "$nama, Anda berada dalam kategori: Normal"
      elif (( $(echo "$bmi >= 25 && $bmi < 27" | bc -l) )); then
        echo "$nama, Anda berada dalam kategori: Gemuk"
      elif (( $(echo "$bmi > 27" | bc -l) )); then 
        echo "$nama, Anda berada dalam kategori: Obesitas"
      fi
    elif [[ "$jenis_kelamin" == "w" || "$jenis_kelamin" == "W" ]]; then
      if (( $(echo "$bmi < 17" | bc -l) )); then
        echo "$nama, Anda berada dalam kategori: Kurus"
      elif (( $(echo "$bmi >= 17 && $bmi < 23" | bc -l) )); then
        echo "$nama, Anda berada dalam kategori: Normal"
      elif (( $(echo "$bmi >= 23 && $bmi < 27" | bc -l) )); then
        echo "$nama, Anda berada dalam kategori: Gemuk"
      elif (( $(echo "$bmi > 27" | bc -l) )); then
        echo "$nama, Anda berada dalam kategori: Obesitas"
      fi
    else
      echo "Jenis kelamin tidak valid."
      ((i--))
      continue
      fi

      #Menampilkan saran olahraga
      saran_olahraga "$bmi"
    done

    #Menanyakan apakah ingin mengulangi
    read -p "Apakah Anda ingin menghitung BMI lagi? (y/n): " pilihan
        if [[ "$pilihan" != "y" && "pilihan" != "Y" ]]; then
        echo "Terima Kasih telah menggunakan kalkulator BMI."
    break
   fi
done
}

Looping_Bilangan_Ganjil_Genap() {

    # Fungsi untuk menampilkan bilangan kelipatan
    tampilkan_bilangan() {
        local angka=$1
        local jenis=$2
        local i

        # Menyesuaikan angka untuk kelipatan yang diminta
        if ((jenis == 1)); then
            # Menampilkan bilangan genap
            if ((angka % 2 == 1)); then
                ((angka--)) # Jika angka ganjil, kurangi satu agar jadi genap
            fi
        elif ((jenis == 2)); then
            # Menampilkan bilangan ganjil
            if ((angka % 2 == 0)); then
                ((angka--)) # Jika angka genap, kurangi satu agar jadi ganjil
            fi
        fi
 
        # Loop untuk menampilkan bilangan
        i=$angka
        while ((i >= 1)); do
            echo $i
            i=$((i - 2))  # Melangkah dua angka sekali (genap/ganjil)
        done
    }

    # Input pilihan dan angka
    echo "Pilih opsi yang Anda inginkan:"
    echo "1. Menampilkan bilangan genap mulai dari angka yang dimasukkan"
    echo "2. Menampilkan kelipatan ganjil mulai dari angka yang dimasukkan"
    read -p "Masukkan pilihan (1 atau 2): " pilihan
    read -p "Masukkan angka yang anda inginkan: " angka
    echo "Bilangan positif kelipatan yang diinginkan mulai dari angka $angka : "


    # Proses berdasarkan pilihan
    case $pilihan in
        1)
            tampilkan_bilangan $angka 1
            ;;
        2)
            tampilkan_bilangan $angka 2
            ;;
        *)
            echo "Pilihan tidak valid. Silakan pilih 1 atau 2."
            ;;
    esac
}

Konversi_Mata_Uang() {

    echo "Pilih mata uang asal:"
    echo "1. IDR (Rupiah)"
    echo "2. USD (Dolar AS)"
    echo "3. EUR (Euro)"
    read -p "Masukkan pilihan (1, 2, atau 3): " mata_uang_asal

    echo "Masukan Jumlah uang yang ingin anda konversikan (desimal diperbolehkan):"
    read jumlah_uang

    echo "Pilih mata uang tujuan:"
    echo "1. IDR (Rupiah)"
    echo "2. USD (Dolar AS)"
    echo "3. EUR (Euro)"
    read -p "Masukkan pilihan (1, 2, atau 3): " mata_uang_tujuan

    case $mata_uang_asal in
        1) # IDR
            case $mata_uang_tujuan in
                1) # IDR -> IDR
                    hasil=$jumlah_uang
                    ;;
                2) # IDR -> USD
                    hasil=$(echo "scale=2; $jumlah_uang / 15000" | bc -l)  # Asumsi 1 USD = 15,000 IDR
                    ;;
                3) # IDR -> EUR
                    hasil=$(echo "scale=2; $jumlah_uang / 16000" | bc -l)  # Asumsi 1 EUR = 16,000 IDR
                    ;;
                *)
                    echo "Pilihan tidak valid."
                    return
                    ;;
            esac
            ;;
        2) # USD
            case $mata_uang_tujuan in
                1) # USD -> IDR
                    hasil=$(echo "scale=2; $jumlah_uang * 15000" | bc -l)  # Asumsi 1 USD = 15,000 IDR
                    ;;
                2) # USD -> USD
                    hasil=$jumlah_uang
                    ;;
                3) # USD -> EUR
                    hasil=$(echo "scale=2; $jumlah_uang * 0.92" | bc -l)  # Asumsi 1 USD = 0.92 EUR
                    ;;
                *)
                    echo "Pilihan tidak valid."
                    return
                    ;;
            esac
            ;;
        3) # EUR
            case $mata_uang_tujuan in
                1) # EUR -> IDR
                    hasil=$(echo "scale=2; $jumlah_uang * 16000" | bc -l)  # Asumsi 1 EUR = 16,000 IDR
                    ;;
                2) # EUR -> USD
                    hasil=$(echo "scale=2; $jumlah_uang * 1.09" | bc -l)  # Asumsi 1 EUR = 1.09 USD
                    ;;
                3) # EUR -> EUR
                    hasil=$jumlah_uang
                    ;;
                *)
                    echo "Pilihan tidak valid."
                    return
                    ;;
            esac
            ;;
        *)
            echo "Pilihan tidak valid."
            return
            ;;
    esac

    echo "Hasil konversi: $hasil"
}

# Fungsi untuk menu utama
tampilkan_menu_utama() {
    echo "===================================="
    echo "         Menu Utama Program         "
    echo "===================================="
    echo "1. Manipulasi Hak Akses"
    echo "2. Membuka Aplikasi"
    echo "3. Kalkulator BMI"
    echo "4. Menghitung Bilangan Ganjil Genap dari sebuah angka"
    echo "5. Konversi mata uang"
    echo "6. Keluar"
    echo "===================================="
    echo -n "Pilih menu yang ingin digunakan: "
}

# Program utama
while true; do
    tampilkan_menu_utama
    read pilihan

    case $pilihan in
        1)
            ManipulasiHakAkses
            ;;
        2)
            MembukaAplikasi
            ;;
        3)
            Kalkulator_BMI
            ;;
        4)
            Looping_Bilangan_Ganjil_Genap
            ;;
        5)
            Konversi_Mata_Uang
            ;;
        6)
            echo "Terima kasih telah menggunakan program ini!"
            break
            ;;
        *)
            echo "Pilihan tidak valid!"
            ;;
    esac
    echo ""
done
