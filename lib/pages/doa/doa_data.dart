// doa_data.dart
class Doa {
  final String label;
  final String judul;
  final String arab;
  final String latin;
  final String arti;
  final List<String> keywords;

  Doa({
    required this.label,
    required this.judul,
    required this.arab,
    required this.latin,
    required this.arti,
    required this.keywords,
  });
}

final List<Doa> doaList = [
  Doa(
    label: 'DOA_TURUN_HUJAN',
    judul: 'Doa Saat Turun Hujan',
    arab: 'اللَّهُمَّ صَيِّبًا نَافِعًا',
    latin: 'Allâhummâ shayyiban nâfi\'an',
    arti: 'Ya Allah, turunkanlah pada kami hujan yang bermanfaat.',
    keywords: ['hujan', 'rintik', 'deras', 'turun hujan'],
  ),
  Doa(
    label: 'DOA_MASUK_RUMAH',
    judul: 'Doa Masuk Rumah',
    arab:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلَجِ وَخَيْرَ الْمَخْرَجِ بِاسْمِ اللهِ وَلَجْنَا، وَبِاسْمِ اللهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا',
    latin:
        'Allâhumma innî as\'aluka khairal maulaji wa khairal makhraji, bismillâhi walajna wa bismillâhi kharajna wa \'ala-Llâhi rabbinâ tawakkalnâ',
    arti:
        'Ya Allah, aku memohon kepada-Mu sebaik-baik tempat masuk dan sebaik-baik tempat keluar. Atas nama-Mu kami masuk dan atas nama-Mu kami keluar.',
    keywords: ['masuk rumah', 'rumah', 'pulang', 'masuk'],
  ),
  Doa(
    label: 'DOA_ORANG_TUA',
    judul: 'Doa untuk Kedua Orang Tua',
    arab: 'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
    latin: 'Rabbighfir lî wa li wâlidayya warḥamhumâ kamâ rabbayânî shaghîrâ.',
    arti:
        'Tuhanku, ampunilah diriku dan kedua orang tuaku, sayangilah mereka sebagaimana mereka menyayangiku di waktu aku kecil.',
    keywords: ['orang tua', 'ibu', 'ayah', 'ampunilah orang tua'],
  ),
  Doa(
    label: 'DOA_KELUAR_KAMAR_MANDI',
    judul: 'Doa Keluar Kamar Mandi',
    arab: 'غفْرَانَكَ الْحَمْدُ لِلَّهِ الَّذِي أَذْهَبَ عَنِّي الْأَذَى وَعَافَانِي',
    latin:
        'Ghufrânaka alḥamdulillâhil-ladzî adzhaba \'annil adzâ wa \'âfânî',
    arti:
        'Dengan mengharap ampunan-Mu, segala puji bagi Allah yang telah menghilangkan penyakit dari tubuhku dan menyehatkan aku.',
    keywords: ['keluar kamar mandi', 'mandi', 'kamar mandi', 'sehat'],
  ),
  Doa(
    label: 'DOA_SHOLAT_DHUHA',
    judul: 'Doa Sholat Dhuha',
    arab:
        'اَللّهُمَّ إِنِّى أَسْأَلُكَ فَضْلَ الْـدُّحَى',
    latin: 'Allahumma inni as\'aluka fadlal dhuha',
    arti: 'Ya Allah, aku memohon kepada-Mu keutamaan waktu dhuha.',
    keywords: ['sholat dhuha', 'dhuha', 'doa dhuha', 'shalat dhuha'],
  ),
  Doa(
    label: 'DOA_MAKAN',
    judul: 'Doa Sebelum dan Sesudah Makan',
    arab: 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
    latin: 'Bismillahi wa \'ala barakatillah',
    arti: 'Dengan nama Allah dan atas berkah Allah.',
    keywords: ['makan', 'doa makan', 'sebelum makan', 'sesudah makan'],
  ),
  Doa(
    label: 'DOA_MASUK_MASJID',
    judul: 'Doa Masuk Masjid',
    arab: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
    latin: 'Allahumma iftah li abwaba rahmatika',
    arti: 'Ya Allah, bukakanlah untukku pintu-pintu rahmat-Mu.',
    keywords: ['masuk masjid', 'masjid', 'berjalan ke masjid'],
  ),
  Doa(
    label: 'DOA_KELUAR_MASJID',
    judul: 'Doa Keluar Masjid',
    arab: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
    latin: 'Allahumma inni as\'aluka min fadlika',
    arti: 'Ya Allah, aku memohon kepada-Mu karunia-Mu.',
    keywords: ['keluar masjid', 'masjid', 'keluar'],
  ),
  Doa(
    label: 'DOA_MENJELANG_TIDUR',
    judul: 'Doa Sebelum Tidur',
    arab:
        'بِاسْمِكَ اللَّهُمَّ أَحْيَا وَأَمُوتُ',
    latin: 'Bismika Allahumma ahya wa amut',
    arti: 'Dengan nama-Mu, ya Allah, aku hidup dan mati.',
    keywords: ['tidur', 'sebelum tidur', 'doa tidur'],
  ),
  Doa(
    label: 'DOA_BANGUN_TIDUR',
    judul: 'Doa Bangun Tidur',
    arab:
        'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَمَا أَمَاتَنَا',
    latin:
        'Alhamdulillahil-ladhi ahyana ba\'dama amatana',
    arti:
        'Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami.',
    keywords: ['bangun tidur', 'doa bangun tidur'],
  ),
  Doa(
    label: 'DOA_MINTA_KESEHATAN',
    judul: 'Doa Memohon Kesehatan',
    arab:
        'اللَّهُمَّ عَافِنِي فِي بَدَنِي',
    latin: 'Allahumma \'afini fi badani',
    arti: 'Ya Allah, berikanlah aku kesehatan pada badanku.',
    keywords: ['sehat', 'kesehatan', 'doa sehat'],
  ),
  Doa(
    label: 'DOA_MEMOHON_KEBERKAHAN',
    judul: 'Doa Memohon Keberkahan',
    arab:
        'بَارَكَ اللهُ لَنَا فِيْمَا رَزَقَنَا',
    latin: 'Barakallahu lana fima razaqna',
    arti: 'Semoga Allah memberkahi apa yang telah Dia rezekikan kepada kami.',
    keywords: ['berkah', 'keberkahan', 'rezeki'],
  ),
  Doa(
    label: 'DOA_MEMOHON_MAAF',
    judul: 'Doa Memohon Maaf',
    arab:
        'أَسْتَغْفِرُ اللَّهَ رَبِّي',
    latin: 'Astaghfirullah rabbi',
    arti: 'Aku memohon ampun kepada Allah, Tuhanku.',
    keywords: ['maaf', 'mohon maaf', 'istighfar'],
  ),
  Doa(
    label: 'DOA_MEMOHON_PETUNJUK',
    judul: 'Doa Memohon Petunjuk',
    arab:
        'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
    latin: 'Ihdinas siratal mustaqim',
    arti: 'Tunjukilah kami jalan yang lurus.',
    keywords: ['petunjuk', 'doa petunjuk', 'jalan lurus'],
  ),
  Doa(
    label: 'DOA_MEMOHON_KUAT',
    judul: 'Doa Memohon Kekuatan',
    arab:
        'رَبِّ اشْرَحْ لِي صَدْرِي',
    latin: 'Rabbishrah li sadri',
    arti: 'Ya Tuhanku, lapangkanlah dadaku.',
    keywords: ['kuat', 'doa kuat', 'semangat'],
  ),
  Doa(
    label: 'DOA_MEMOHON_KESELAMATAN',
    judul: 'Doa Memohon Keselamatan',
    arab:
        'اللَّهُمَّ أَنْتَ السَّلاَمُ وَمِنْكَ السَّلاَمُ',
    latin: 'Allahumma anta as-salam wa minka as-salam',
    arti: 'Ya Allah, Engkaulah keselamatan dan dari-Mu keselamatan.',
    keywords: ['selamat', 'keselamatan', 'aman'],
  ),
  Doa(
    label: 'DOA_SAAT_MENJELANG_MATI',
    judul: 'Doa Saat Menjelang Mati',
    arab:
        'اللَّهُمَّ اجْعَلْ خَيْرَ مَا أَسْمَعُ',
    latin: 'Allahumma aj\'al khaira ma asma\'u',
    arti:
        'Ya Allah, jadikanlah yang terbaik yang aku dengar (menjelang ajal).',
    keywords: ['mati', 'menjelang mati', 'doa akhir'],
  ),
  Doa(
    label: 'DOA_MINTA_KEKUATAN',
    judul: 'Doa Meminta Kekuatan dan Kesabaran',
    arab:
        'رَبِّ أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ',
    latin: 'Rabb a\'udzubika minal hammi wal hazan',
    arti:
        'Ya Tuhanku, aku berlindung kepada-Mu dari kesedihan dan kesusahan.',
    keywords: ['kekuatan', 'kesabaran', 'doa kuat', 'doa sabar'],
  ),
];
