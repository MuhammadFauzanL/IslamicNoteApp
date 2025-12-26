const artikelModel = require('../models/artikel.model');

// GET /api/artikel - Get all artikel
const getAll = async (req, res) => {
    try {
        const { search } = req.query;

        let artikels;
        if (search) {
            artikels = await artikelModel.searchArtikel(search);
        } else {
            artikels = await artikelModel.getAllArtikel();
        }

        res.json({
            success: true,
            count: artikels.length,
            data: artikels
        });
    } catch (error) {
        console.error('Error getting artikel:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal mengambil data artikel',
            error: error.message
        });
    }
};

// GET /api/artikel/:id - Get artikel by ID
const getById = async (req, res) => {
    try {
        const { id } = req.params;
        const artikel = await artikelModel.getArtikelById(id);

        if (!artikel) {
            return res.status(404).json({
                success: false,
                message: 'Artikel tidak ditemukan'
            });
        }

        res.json({
            success: true,
            data: artikel
        });
    } catch (error) {
        console.error('Error getting artikel by id:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal mengambil data artikel',
            error: error.message
        });
    }
};

// POST /api/artikel - Create new artikel (admin only)
const create = async (req, res) => {
    try {
        const { judul, ringkasan, konten, gambar_url, kategori, penulis } = req.body;

        // Validation
        if (!judul || !konten) {
            return res.status(400).json({
                success: false,
                message: 'Field judul dan konten wajib diisi'
            });
        }

        const newArtikel = await artikelModel.createArtikel({
            judul, ringkasan, konten, gambar_url, kategori, penulis
        });

        res.status(201).json({
            success: true,
            message: 'Artikel berhasil ditambahkan',
            data: newArtikel
        });
    } catch (error) {
        console.error('Error creating artikel:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal menambahkan artikel',
            error: error.message
        });
    }
};

// PUT /api/artikel/:id - Update artikel (admin only)
const update = async (req, res) => {
    try {
        const { id } = req.params;
        const { judul, ringkasan, konten, gambar_url, kategori, penulis } = req.body;

        // Check if artikel exists
        const existingArtikel = await artikelModel.getArtikelById(id);
        if (!existingArtikel) {
            return res.status(404).json({
                success: false,
                message: 'Artikel tidak ditemukan'
            });
        }

        const updatedArtikel = await artikelModel.updateArtikel(id, {
            judul: judul || existingArtikel.judul,
            ringkasan: ringkasan !== undefined ? ringkasan : existingArtikel.ringkasan,
            konten: konten || existingArtikel.konten,
            gambar_url: gambar_url !== undefined ? gambar_url : existingArtikel.gambar_url,
            kategori: kategori || existingArtikel.kategori,
            penulis: penulis || existingArtikel.penulis
        });

        res.json({
            success: true,
            message: 'Artikel berhasil diperbarui',
            data: updatedArtikel
        });
    } catch (error) {
        console.error('Error updating artikel:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal memperbarui artikel',
            error: error.message
        });
    }
};

// DELETE /api/artikel/:id - Delete artikel (admin only)
const remove = async (req, res) => {
    try {
        const { id } = req.params;

        const deletedArtikel = await artikelModel.deleteArtikel(id);

        if (!deletedArtikel) {
            return res.status(404).json({
                success: false,
                message: 'Artikel tidak ditemukan'
            });
        }

        res.json({
            success: true,
            message: 'Artikel berhasil dihapus',
            data: deletedArtikel
        });
    } catch (error) {
        console.error('Error deleting artikel:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal menghapus artikel',
            error: error.message
        });
    }
};

module.exports = {
    getAll,
    getById,
    create,
    update,
    remove
};
