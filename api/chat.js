// api/chat.js
// Vercel Serverless Function — chạy trên SERVER, không phải trình duyệt.
// Vì vậy API key (process.env.GEMINI_API_KEY) không bao giờ lộ ra cho người dùng.
//
// Cách hoạt động:
// 1. Trình duyệt (index.html) gửi POST tới /api/chat với { prompt: "..." }
// 2. Hàm này nhận prompt, gọi tới Google Gemini API bằng key bí mật lưu trong
//    biến môi trường GEMINI_API_KEY (cấu hình trên Vercel, xem README.md).
// 3. Trả về { reply: "..." } cho trình duyệt.

module.exports = async function handler(req, res) {
  // Cho phép gọi từ trình duyệt (cùng domain nên thực ra không bắt buộc CORS,
  // nhưng thêm cho an toàn nếu bạn tách domain sau này)
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Chỉ hỗ trợ phương thức POST' });
    return;
  }

  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    res.status(500).json({
      error: 'Chưa cấu hình GEMINI_API_KEY trên Vercel. Xem README.md phần "Bước 3" để thêm biến môi trường này.'
    });
    return;
  }

  let body = req.body;
  if (typeof body === 'string') {
    try { body = JSON.parse(body); } catch (e) { body = {}; }
  }
  const prompt = body && body.prompt;

  if (!prompt || typeof prompt !== 'string') {
    res.status(400).json({ error: 'Thiếu "prompt" trong body request' });
    return;
  }

  try {
    // Model + endpoint hiện tại của Gemini (tháng 7/2026).
    // LƯU Ý: Google đã đổi định dạng API key từ "AIzaSy..." (Standard key) sang
    // "AQ.Ab..." (Auth key) kể từ tháng 6/2026. Auth key mới KHÔNG dùng ổn định
    // qua query param "?key=..." như trước — phải gửi qua header "X-goog-api-key".
    const model = 'gemini-flash-latest';
    const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent`;

    const geminiRes = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-goog-api-key': apiKey
      },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: {
          temperature: 0.8,
          maxOutputTokens: 500,
          // Tắt bước "suy nghĩ" (thinking) của model — với các câu hỏi ngắn gọn
          // như tư vấn thời trang, thinking chỉ làm chậm và đôi khi khiến model
          // trả về văn bản nháp/cấu trúc lạ thay vì câu trả lời trực tiếp.
          thinkingConfig: { thinkingBudget: 0 }
        }
      })
    });

    if (!geminiRes.ok) {
      const errText = await geminiRes.text();
      console.error('Lỗi từ Gemini API:', geminiRes.status, errText);
      res.status(502).json({ error: 'Gemini API trả về lỗi', detail: errText });
      return;
    }

    const data = await geminiRes.json();
    const reply =
      data &&
      data.candidates &&
      data.candidates[0] &&
      data.candidates[0].content &&
      data.candidates[0].content.parts &&
      data.candidates[0].content.parts[0] &&
      data.candidates[0].content.parts[0].text;

    if (!reply) {
      res.status(502).json({ error: 'Gemini không trả về nội dung hợp lệ', raw: data });
      return;
    }

    res.status(200).json({ reply: reply.trim() });
  } catch (err) {
    console.error('Lỗi gọi Gemini API:', err);
    res.status(500).json({ error: 'Lỗi server khi gọi Gemini API', detail: String(err) });
  }
};
