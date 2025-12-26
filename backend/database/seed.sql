-- Seed data for doa table
-- 18 doa dari data hardcoded Flutter app

INSERT INTO doa (label, judul, arab, latin, arti, keywords) VALUES
(
    'DOA_TURUN_HUJAN',
    'Doa Saat Turun Hujan',
    'اللَّهُمَّ صَيِّبًا نَافِعًا',
    'Allâhummâ shayyiban nâfi''an',
    'Ya Allah, turunkanlah pada kami hujan yang bermanfaat.',
    ARRAY['hujan', 'rintik', 'deras', 'turun hujan']
),
(
    'DOA_MASUK_RUMAH',
    'Doa Masuk Rumah',
    'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلَجِ وَخَيْرَ الْمَخْرَجِ بِاسْمِ اللهِ وَلَجْنَا، وَبِاسْمِ اللهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا',
    'Allâhumma innî as''aluka khairal maulaji wa khairal makhraji, bismillâhi walajna wa bismillâhi kharajna wa ''ala-Llâhi rabbinâ tawakkalnâ',
    'Ya Allah, aku memohon kepada-Mu sebaik-baik tempat masuk dan sebaik-baik tempat keluar. Atas nama-Mu kami masuk dan atas nama-Mu kami keluar.',
    ARRAY['masuk rumah', 'rumah', 'pulang', 'masuk']
),
(
    'DOA_ORANG_TUA',
    'Doa untuk Kedua Orang Tua',
    'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
    'Rabbighfir lî wa li wâlidayya warḥamhumâ kamâ rabbayânî shaghîrâ.',
    'Tuhanku, ampunilah diriku dan kedua orang tuaku, sayangilah mereka sebagaimana mereka menyayangiku di waktu aku kecil.',
    ARRAY['orang tua', 'ibu', 'ayah', 'ampunilah orang tua']
),
(
    'DOA_KELUAR_KAMAR_MANDI',
    'Doa Keluar Kamar Mandi',
    'غفْرَانَكَ الْحَمْدُ لِلَّهِ الَّذِي أَذْهَبَ عَنِّي الْأَذَى وَعَافَانِي',
    'Ghufrânaka alḥamdulillâhil-ladzî adzhaba ''annil adzâ wa ''âfânî',
    'Dengan mengharap ampunan-Mu, segala puji bagi Allah yang telah menghilangkan penyakit dari tubuhku dan menyehatkan aku.',
    ARRAY['keluar kamar mandi', 'mandi', 'kamar mandi', 'sehat']
),
(
    'DOA_SHOLAT_DHUHA',
    'Doa Sholat Dhuha',
    'اَللّهُمَّ إِنِّى أَسْأَلُكَ فَضْلَ الْـدُّحَى',
    'Allahumma inni as''aluka fadlal dhuha',
    'Ya Allah, aku memohon kepada-Mu keutamaan waktu dhuha.',
    ARRAY['sholat dhuha', 'dhuha', 'doa dhuha', 'shalat dhuha']
),
(
    'DOA_MAKAN',
    'Doa Sebelum dan Sesudah Makan',
    'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
    'Bismillahi wa ''ala barakatillah',
    'Dengan nama Allah dan atas berkah Allah.',
    ARRAY['makan', 'doa makan', 'sebelum makan', 'sesudah makan']
),
(
    'DOA_MASUK_MASJID',
    'Doa Masuk Masjid',
    'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
    'Allahumma iftah li abwaba rahmatika',
    'Ya Allah, bukakanlah untukku pintu-pintu rahmat-Mu.',
    ARRAY['masuk masjid', 'masjid', 'berjalan ke masjid']
),
(
    'DOA_KELUAR_MASJID',
    'Doa Keluar Masjid',
    'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
    'Allahumma inni as''aluka min fadlika',
    'Ya Allah, aku memohon kepada-Mu karunia-Mu.',
    ARRAY['keluar masjid', 'masjid', 'keluar']
),
(
    'DOA_MENJELANG_TIDUR',
    'Doa Sebelum Tidur',
    'بِاسْمِكَ اللَّهُمَّ أَحْيَا وَأَمُوتُ',
    'Bismika Allahumma ahya wa amut',
    'Dengan nama-Mu, ya Allah, aku hidup dan mati.',
    ARRAY['tidur', 'sebelum tidur', 'doa tidur']
),
(
    'DOA_BANGUN_TIDUR',
    'Doa Bangun Tidur',
    'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَمَا أَمَاتَنَا',
    'Alhamdulillahil-ladhi ahyana ba''dama amatana',
    'Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami.',
    ARRAY['bangun tidur', 'doa bangun tidur']
),
(
    'DOA_MINTA_KESEHATAN',
    'Doa Memohon Kesehatan',
    'اللَّهُمَّ عَافِنِي فِي بَدَنِي',
    'Allahumma ''afini fi badani',
    'Ya Allah, berikanlah aku kesehatan pada badanku.',
    ARRAY['sehat', 'kesehatan', 'doa sehat']
),
(
    'DOA_MEMOHON_KEBERKAHAN',
    'Doa Memohon Keberkahan',
    'بَارَكَ اللهُ لَنَا فِيْمَا رَزَقَنَا',
    'Barakallahu lana fima razaqna',
    'Semoga Allah memberkahi apa yang telah Dia rezekikan kepada kami.',
    ARRAY['berkah', 'keberkahan', 'rezeki']
),
(
    'DOA_MEMOHON_MAAF',
    'Doa Memohon Maaf',
    'أَسْتَغْفِرُ اللَّهَ رَبِّي',
    'Astaghfirullah rabbi',
    'Aku memohon ampun kepada Allah, Tuhanku.',
    ARRAY['maaf', 'mohon maaf', 'istighfar']
),
(
    'DOA_MEMOHON_PETUNJUK',
    'Doa Memohon Petunjuk',
    'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
    'Ihdinas siratal mustaqim',
    'Tunjukilah kami jalan yang lurus.',
    ARRAY['petunjuk', 'doa petunjuk', 'jalan lurus']
),
(
    'DOA_MEMOHON_KUAT',
    'Doa Memohon Kekuatan',
    'رَبِّ اشْرَحْ لِي صَدْرِي',
    'Rabbishrah li sadri',
    'Ya Tuhanku, lapangkanlah dadaku.',
    ARRAY['kuat', 'doa kuat', 'semangat']
),
(
    'DOA_MEMOHON_KESELAMATAN',
    'Doa Memohon Keselamatan',
    'اللَّهُمَّ أَنْتَ السَّلاَمُ وَمِنْكَ السَّلاَمُ',
    'Allahumma anta as-salam wa minka as-salam',
    'Ya Allah, Engkaulah keselamatan dan dari-Mu keselamatan.',
    ARRAY['selamat', 'keselamatan', 'aman']
),
(
    'DOA_SAAT_MENJELANG_MATI',
    'Doa Saat Menjelang Mati',
    'اللَّهُمَّ اجْعَلْ خَيْرَ مَا أَسْمَعُ',
    'Allahumma aj''al khaira ma asma''u',
    'Ya Allah, jadikanlah yang terbaik yang aku dengar (menjelang ajal).',
    ARRAY['mati', 'menjelang mati', 'doa akhir']
),
(
    'DOA_MINTA_KEKUATAN',
    'Doa Meminta Kekuatan dan Kesabaran',
    'رَبِّ أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ',
    'Rabb a''udzubika minal hammi wal hazan',
    'Ya Tuhanku, aku berlindung kepada-Mu dari kesedihan dan kesusahan.',
    ARRAY['kekuatan', 'kesabaran', 'doa kuat', 'doa sabar']
);

-- Verify inserted data
SELECT COUNT(*) as total_doa FROM doa;
