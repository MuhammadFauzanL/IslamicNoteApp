const axios = require("axios");

const CHATBOT_URL = process.env.CHATBOT_URL || "http://127.0.0.1:5005/chat";

exports.chat = async (req, res) => {
  try {
    const { query, session_id } = req.body;

    if (!query) {
      return res.status(400).json({
        success: false,
        message: "Query wajib diisi",
      });
    }

    const response = await axios.post(CHATBOT_URL, {
      query,
      session_id,
    });

    res.json({
      success: true,
      source: "chatbot",
      data: response.data,
    });
  } catch (err) {
    console.error("Chatbot error:", err.message);
    res.status(500).json({
      success: false,
      message: "Chatbot service error",
    });
  }
};
