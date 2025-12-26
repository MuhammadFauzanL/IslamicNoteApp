const { query } = require('../config/database');

// Initialize artikel table
const initArtikelTable = async () => {
    try {
        await query(`
      CREATE TABLE IF NOT EXISTS artikel (
        id SERIAL PRIMARY KEY,
        judul VARCHAR(255) NOT NULL,
        ringkasan TEXT,
        konten TEXT NOT NULL,
        gambar_url TEXT,
        kategori VARCHAR(100),
        penulis VARCHAR(100) DEFAULT 'Admin',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

        // Check if seed data needed
        const result = await query('SELECT COUNT(*) FROM artikel');
        if (parseInt(result.rows[0].count) === 0) {
            await seedArtikel();
        }
    } catch (error) {
        console.error('Error creating artikel table:', error);
    }
};

// Seed initial artikel data
const seedArtikel = async () => {
    const artikelData = [
        {
            judul: 'Manfaat Sedekah dalam Islam',
            ringkasan: 'Sedekah memiliki banyak keutamaan yang dijanjikan Allah SWT bagi orang-orang yang gemar bersedekah.',
            konten: `Sedekah adalah salah satu amalan yang sangat dianjurkan dalam Islam. Allah SWT berfirman dalam Al-Quran surat Al-Baqarah ayat 261:

"Perumpamaan orang-orang yang menafkahkan hartanya di jalan Allah adalah serupa dengan sebutir benih yang menumbuhkan tujuh bulir, pada tiap-tiap bulir seratus biji. Allah melipat gandakan (ganjaran) bagi siapa yang Dia kehendaki."

**Manfaat Sedekah:**

1. **Membersihkan Harta dan Jiwa**
Sedekah dapat membersihkan harta dari hal-hal yang tidak baik dan membersihkan jiwa dari sifat kikir.

2. **Menolak Bala**
Rasulullah SAW bersabda: "Sedekah dapat menolak bala dan menambah umur."

3. **Melapangkan Rezeki**
Allah menjanjikan akan melipatgandakan rezeki bagi orang yang bersedekah.

4. **Mendapat Naungan di Hari Kiamat**
Orang yang bersedekah dengan ikhlas akan mendapat naungan di hari kiamat.

5. **Menghapus Dosa**
Sedekah dapat menghapus dosa-dosa kecil sebagaimana air memadamkan api.`,
            kategori: 'Ibadah',
            penulis: 'Admin'
        },
        {
            judul: 'Cara Wudhu yang Benar',
            ringkasan: 'Panduan lengkap tata cara berwudhu sesuai dengan sunnah Rasulullah SAW.',
            konten: `Wudhu adalah syarat sahnya sholat. Berikut tata cara wudhu yang benar sesuai sunnah:

**Rukun Wudhu:**

1. **Niat**
Niat di dalam hati untuk berwudhu karena Allah.

2. **Membasuh Wajah**
Basuh seluruh wajah dari tempat tumbuhnya rambut kepala hingga kedua tulang dagu, dan dari telinga kanan ke telinga kiri.

3. **Membasuh Kedua Tangan sampai Siku**
Basuh kedua tangan dari ujung jari hingga siku, dimulai dari tangan kanan.

4. **Mengusap Kepala**
Usap kepala dengan tangan yang basah, dari depan ke belakang lalu kembali ke depan.

5. **Membasuh Kedua Kaki sampai Mata Kaki**
Basuh kedua kaki hingga mata kaki, dimulai dari kaki kanan.

6. **Tertib**
Melakukan rukun wudhu secara berurutan.

**Sunnah Wudhu:**
- Membaca Bismillah
- Membasuh kedua telapak tangan
- Berkumur-kumur
- Istinsyaq (memasukkan air ke hidung)
- Menyela-nyela jari tangan dan kaki
- Membasuh anggota wudhu 3 kali
- Mendahulukan anggota kanan
- Berdoa setelah wudhu`,
            kategori: 'Ibadah',
            penulis: 'Admin'
        },
        {
            judul: 'Keutamaan Sholat Dhuha',
            ringkasan: 'Sholat Dhuha adalah sholat sunnah yang memiliki banyak keutamaan.',
            konten: `Sholat Dhuha adalah sholat sunnah yang dikerjakan pada waktu dhuha, yaitu ketika matahari sudah naik setinggi tombak hingga sebelum masuk waktu dzuhur.

**Waktu Sholat Dhuha:**
Dimulai dari matahari naik setinggi tombak (sekitar 15 menit setelah matahari terbit) hingga sebelum waktu dzuhur. Waktu yang paling utama adalah ketika matahari sudah tinggi dan terik.

**Jumlah Rakaat:**
Minimal 2 rakaat dan maksimal 12 rakaat. Disunnahkan dikerjakan 4 rakaat dengan 2 salam.

**Keutamaan Sholat Dhuha:**

1. **Sedekah untuk Persendian Tubuh**
Rasulullah SAW bersabda: "Pada setiap ruas tulang kalian ada sedekahnya setiap pagi. Maka setiap tasbih adalah sedekah, setiap tahmid adalah sedekah, setiap tahlil adalah sedekah, setiap takbir adalah sedekah. Dan semua itu cukup diganti dengan dua rakaat sholat dhuha."

2. **Termasuk Amalan Orang yang Bertaubat**
Sholat dhuha adalah sholat orang-orang yang bertaubat (awwabin).

3. **Mendapat Jaminan Rezeki**
Allah menjamin rezeki bagi orang yang rajin sholat dhuha.

**Doa Setelah Sholat Dhuha:**
اَللّهُمَّ إِنَّ الضُّحَاءَ ضُحَاءُكَ وَالْبَهَاءَ بَهَاءُكَ وَالْجَمَالَ جَمَالُكَ

"Ya Allah, sesungguhnya waktu dhuha adalah waktu dhuha-Mu, keagungan adalah keagungan-Mu, keindahan adalah keindahan-Mu."`,
            kategori: 'Sholat',
            penulis: 'Admin'
        }
    ];

    for (const artikel of artikelData) {
        await query(
            `INSERT INTO artikel (judul, ringkasan, konten, kategori, penulis) 
       VALUES ($1, $2, $3, $4, $5)`,
            [artikel.judul, artikel.ringkasan, artikel.konten, artikel.kategori, artikel.penulis]
        );
    }
    console.log('✅ Seeded 3 artikel');
};

// Get all artikel
const getAllArtikel = async () => {
    const result = await query(
        'SELECT * FROM artikel ORDER BY created_at DESC'
    );
    return result.rows;
};

// Get artikel by ID
const getArtikelById = async (id) => {
    const result = await query(
        'SELECT * FROM artikel WHERE id = $1',
        [id]
    );
    return result.rows[0];
};

// Search artikel
const searchArtikel = async (keyword) => {
    const result = await query(
        `SELECT * FROM artikel 
     WHERE judul ILIKE $1 
     OR ringkasan ILIKE $1 
     OR konten ILIKE $1
     ORDER BY created_at DESC`,
        [`%${keyword}%`]
    );
    return result.rows;
};

// Create artikel
const createArtikel = async (artikelData) => {
    const { judul, ringkasan, konten, gambar_url, kategori, penulis } = artikelData;
    const result = await query(
        `INSERT INTO artikel (judul, ringkasan, konten, gambar_url, kategori, penulis)
     VALUES ($1, $2, $3, $4, $5, $6)
     RETURNING *`,
        [judul, ringkasan || '', konten, gambar_url || null, kategori || 'Umum', penulis || 'Admin']
    );
    return result.rows[0];
};

// Update artikel
const updateArtikel = async (id, artikelData) => {
    const { judul, ringkasan, konten, gambar_url, kategori, penulis } = artikelData;
    const result = await query(
        `UPDATE artikel 
     SET judul = $1, ringkasan = $2, konten = $3, gambar_url = $4, kategori = $5, penulis = $6, updated_at = CURRENT_TIMESTAMP
     WHERE id = $7
     RETURNING *`,
        [judul, ringkasan, konten, gambar_url, kategori, penulis, id]
    );
    return result.rows[0];
};

// Delete artikel
const deleteArtikel = async (id) => {
    const result = await query(
        'DELETE FROM artikel WHERE id = $1 RETURNING *',
        [id]
    );
    return result.rows[0];
};

module.exports = {
    initArtikelTable,
    getAllArtikel,
    getArtikelById,
    searchArtikel,
    createArtikel,
    updateArtikel,
    deleteArtikel
};
