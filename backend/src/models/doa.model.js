const { query } = require('../config/database');

// Get all doa
const getAllDoa = async () => {
    const result = await query(
        'SELECT * FROM doa ORDER BY id ASC'
    );
    return result.rows;
};

// Get doa by ID
const getDoaById = async (id) => {
    const result = await query(
        'SELECT * FROM doa WHERE id = $1',
        [id]
    );
    return result.rows[0];
};

// Search doa by keyword
const searchDoa = async (keyword) => {
    const result = await query(
        `SELECT * FROM doa 
     WHERE judul ILIKE $1 
     OR arti ILIKE $1 
     OR $2 = ANY(keywords)
     ORDER BY id ASC`,
        [`%${keyword}%`, keyword.toLowerCase()]
    );
    return result.rows;
};

// Create new doa (admin only)
const createDoa = async (doaData) => {
    const { label, judul, arab, latin, arti, keywords } = doaData;
    const result = await query(
        `INSERT INTO doa (label, judul, arab, latin, arti, keywords)
     VALUES ($1, $2, $3, $4, $5, $6)
     RETURNING *`,
        [label, judul, arab, latin, arti, keywords || []]
    );
    return result.rows[0];
};

// Update doa (admin only)
const updateDoa = async (id, doaData) => {
    const { label, judul, arab, latin, arti, keywords } = doaData;
    const result = await query(
        `UPDATE doa 
     SET label = $1, judul = $2, arab = $3, latin = $4, arti = $5, keywords = $6, updated_at = CURRENT_TIMESTAMP
     WHERE id = $7
     RETURNING *`,
        [label, judul, arab, latin, arti, keywords || [], id]
    );
    return result.rows[0];
};

// Delete doa (admin only)
const deleteDoa = async (id) => {
    const result = await query(
        'DELETE FROM doa WHERE id = $1 RETURNING *',
        [id]
    );
    return result.rows[0];
};

module.exports = {
    getAllDoa,
    getDoaById,
    searchDoa,
    createDoa,
    updateDoa,
    deleteDoa
};
