const doaModel = require('../models/doa.model');

// GET /api/doa - Get all doa
const getAll = async (req, res) => {
    try {
        const { search } = req.query;

        let doas;
        if (search) {
            doas = await doaModel.searchDoa(search);
        } else {
            doas = await doaModel.getAllDoa();
        }

        res.json({
            success: true,
            count: doas.length,
            data: doas
        });
    } catch (error) {
        console.error('Error getting doa:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal mengambil data doa',
            error: error.message
        });
    }
};

// GET /api/doa/:id - Get doa by ID
const getById = async (req, res) => {
    try {
        const { id } = req.params;
        const doa = await doaModel.getDoaById(id);

        if (!doa) {
            return res.status(404).json({
                success: false,
                message: 'Doa tidak ditemukan'
            });
        }

        res.json({
            success: true,
            data: doa
        });
    } catch (error) {
        console.error('Error getting doa by id:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal mengambil data doa',
            error: error.message
        });
    }
};

// POST /api/doa - Create new doa (admin only)
const create = async (req, res) => {
    try {
        const { label, judul, arab, latin, arti, keywords } = req.body;

        // Validation
        if (!label || !judul || !arab || !latin || !arti) {
            return res.status(400).json({
                success: false,
                message: 'Field label, judul, arab, latin, dan arti wajib diisi'
            });
        }

        const newDoa = await doaModel.createDoa({
            label, judul, arab, latin, arti, keywords
        });

        res.status(201).json({
            success: true,
            message: 'Doa berhasil ditambahkan',
            data: newDoa
        });
    } catch (error) {
        console.error('Error creating doa:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal menambahkan doa',
            error: error.message
        });
    }
};

// PUT /api/doa/:id - Update doa (admin only)
const update = async (req, res) => {
    try {
        const { id } = req.params;
        const { label, judul, arab, latin, arti, keywords } = req.body;

        // Check if doa exists
        const existingDoa = await doaModel.getDoaById(id);
        if (!existingDoa) {
            return res.status(404).json({
                success: false,
                message: 'Doa tidak ditemukan'
            });
        }

        const updatedDoa = await doaModel.updateDoa(id, {
            label: label || existingDoa.label,
            judul: judul || existingDoa.judul,
            arab: arab || existingDoa.arab,
            latin: latin || existingDoa.latin,
            arti: arti || existingDoa.arti,
            keywords: keywords || existingDoa.keywords
        });

        res.json({
            success: true,
            message: 'Doa berhasil diperbarui',
            data: updatedDoa
        });
    } catch (error) {
        console.error('Error updating doa:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal memperbarui doa',
            error: error.message
        });
    }
};

// DELETE /api/doa/:id - Delete doa (admin only)
const remove = async (req, res) => {
    try {
        const { id } = req.params;

        const deletedDoa = await doaModel.deleteDoa(id);

        if (!deletedDoa) {
            return res.status(404).json({
                success: false,
                message: 'Doa tidak ditemukan'
            });
        }

        res.json({
            success: true,
            message: 'Doa berhasil dihapus',
            data: deletedDoa
        });
    } catch (error) {
        console.error('Error deleting doa:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal menghapus doa',
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
