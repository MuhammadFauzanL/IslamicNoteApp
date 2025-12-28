const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const userModel = require("../models/user.model");

exports.register = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    // VALIDASI
    if (!name || !email || !password) {
      return res.status(400).json({
        success: false,
        message: "Semua field wajib diisi"
      });
    }

    // CEK EMAIL
    const existingUser = await userModel.findByEmail(email);
    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: "Email sudah terdaftar"
      });
    }

    // HASH PASSWORD
    const hashedPassword = await bcrypt.hash(password, 10);

    // SIMPAN USER
    const newUser = await userModel.createUser({
      name,
      email,
      password: hashedPassword
    });

    // RESPONSE WAJIB
    return res.status(201).json({
      success: true,
      message: "Registrasi berhasil",
      user: {
        id: newUser.id,
        name: newUser.name,
        email: newUser.email
      }
    });

  } catch (error) {
    console.error("REGISTER ERROR:", error);
    return res.status(500).json({
      success: false,
      message: "Terjadi kesalahan server"
    });
  }
};
