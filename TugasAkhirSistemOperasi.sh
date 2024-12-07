#!/bin/bash

MembukaAplikasi(){
    echo "Masukan nama aplikasi yang ingin dibuka (contoh App Center) :"
    read aplikasi
    #Mengecek apakah aplikasi ada disistem dan menyembunyikan output dari perintah pengecekan.
    if command -v "aplikasi" > /dev/null 2>&1; then
    #Menjalankan aplikasi di background utama.
    "$aplikasi" &
    echo "Aplikasi $aplikasi sedang dibuka...."
    else
    # Jika aplikasi tidak ditemukan dengan command -v, coba jalankan dengan 'nohup'
    nohup "$aplikasi" >/dev/null 2>&1 &

      # Mengecek apakah perintah terakhir berhasil (exit code 0 berarti sukses)
        if [ $? -eq 0 ]; then

            # Jika berhasil, tampilkan pesan bahwa aplikasi sedang dibuka
            echo "Aplikasi $aplikasi sedang dibuka...."
        else

            # Jika gagal, tampilkan pesan error kepada pengguna
            echo "Error: Aplikasi $aplikasi tidak ditemukan di sistem Anda."
        fi
   fi
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

Looping_Bilangan_Ganjil_Genap(){

tampilkan_bilangan_genap(){
echo "Masukan angka yang anda inginkan"
    read angka
echo "Bilangan positif kelipatan genap dari $angka : "

if ((angka % 2 == 1)); then
   ((angka--))
fi

i=$angka
while [ $i -ge 1 ]
do
        echo $i
        i=$((i-2))
done
}

tampilkan_bilangan_ganjil() {
echo "Masukan angka yang anda inginkan"
    read angka
echo "Bilangan positif kelipatan ganjil dari $angka : "

if ((angka % 2 == 0)); then
   ((angka--))
fi

i=$angka
while [ $i -ge 1 ]
do
        echo $i
        i=$((i-2))
done
}

echo "Pilih opsi yang Anda inginkan:"
echo "1. Menampilkan bilangan genap  mulai dari angka yang dimasukkan"
echo "2. Menampilkan kelipatan ganjil mulai dari angka yang dimasukan"
read -p "Masukkan pilihan (1 atau 2): " pilihan

case $pilihan in
    1)
        tampilkan_bilangan_genap
        ;;
    2)
        tampilkan_bilangan_ganjil
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

# Menu utama
echo "Pilih program yang mau dijalankan:"
echo "1. Manipulasi hak akses"
echo "2. Membuka aplikasi"
echo "3. Kalkulator BMI"
echo "4. Menghitung Bilangan Ganjil Genap dari sebuah angka"
echo "5. Konversi mata uang"

read pilihan

# Menentukan pilihan
if [ "$pilihan" -eq 1 ]; then
    ManipulasiHakAkses
elif [ "$pilihan" -eq 2 ]; then
    MembukaAplikasi
elif [ "$pilihan" -eq 3 ]; then
    Kalkulator_BMI
elif [ "$pilihan" -eq 4 ]; then
    Looping_Bilangan_Ganjil_Genap
elif [ "$pilihan" -eq 5 ]; then
    Konversi_Mata_Uang
else
    echo "Pilihan tidak valid."
fi
