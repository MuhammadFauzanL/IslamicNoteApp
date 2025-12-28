const { query } = require("../config/database");
const bcrypt = require("bcryptjs");

// ===============================
// INIT TABLE
// ===============================
const initUserTable = async () => {
  try {
    await query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        role VARCHAR(20) DEFAULT 'user',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // Default admin
    const result = await query(
      "SELECT * FROM users WHERE email = $1",
      ["admin@islamicnote.com"]
    );

    if (result.rows.length === 0) {
      const hashed = await bcrypt.hash("admin123", 10);
      await query(
        "INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4)",
        ["Administrator", "admin@islamicnote.com", hashed, "admin"]
      );
      console.log("✅ Default admin created");
    }
  } catch (err) {
    console.error("INIT USER TABLE ERROR:", err);
  }
};

// ===============================
// REGISTER
// ===============================
const register = async ({ name, email, password }) => {
  const existing = await query(
    "SELECT id FROM users WHERE email = $1",
    [email]
  );

  if (existing.rows.length > 0) {
    throw new Error("Email sudah terdaftar");
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  const result = await query(
    `INSERT INTO users (name, email, password, role)
     VALUES ($1, $2, $3, $4)
     RETURNING id, name, email, role, created_at`,
    [name, email, hashedPassword, "user"]
  );

  return result.rows[0];
};

// ===============================
// LOGIN
// ===============================
const login = async (email, password) => {
  const result = await query(
    "SELECT * FROM users WHERE email = $1",
    [email]
  );

  const user = result.rows[0];
  if (!user) {
    throw new Error("Email tidak ditemukan");
  }

  const valid = await bcrypt.compare(password, user.password);
  if (!valid) {
    throw new Error("Password salah");
  }

  const { password: _, ...safeUser } = user;
  return safeUser;
};

// ===============================
// FIND USER
// ===============================
const findById = async (id) => {
  const result = await query(
    "SELECT id, name, email, role, created_at FROM users WHERE id = $1",
    [id]
  );
  return result.rows[0];
};

const findByEmail = async (email) => {
  const result = await query(
    "SELECT id, name, email, role, created_at FROM users WHERE email = $1",
    [email]
  );
  return result.rows[0];
};

// ===============================
// UPDATE PROFILE
// ===============================
const updateProfile = async (id, { name, email }) => {
  const result = await query(
    `UPDATE users 
     SET name = $1, email = $2 
     WHERE id = $3 
     RETURNING id, name, email, role`,
    [name, email, id]
  );
  return result.rows[0];
};

// ===============================
// CHANGE PASSWORD
// ===============================
const changePassword = async (id, oldPassword, newPassword) => {
  const result = await query("SELECT * FROM users WHERE id = $1", [id]);
  const user = result.rows[0];

  if (!user) throw new Error("User tidak ditemukan");

  const valid = await bcrypt.compare(oldPassword, user.password);
  if (!valid) throw new Error("Password lama salah");

  const hashed = await bcrypt.hash(newPassword, 10);
  await query("UPDATE users SET password = $1 WHERE id = $2", [
    hashed,
    id,
  ]);

  return true;
};

module.exports = {
  initUserTable,
  register,
  login,
  findById,
  findByEmail,
  updateProfile,
  changePassword,
};
