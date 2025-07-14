import * as functions from "firebase-functions";
import express from "express";
import cors from "cors";
import axios from "axios";

const GEMINI_API_KEY = functions.config().gemini.key;
const GEMINI_API_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GEMINI_API_KEY}`;

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

app.post("/generate-itinerary", async (req, res) => {
  const { prompt, previousItinerary, chatHistory } = req.body;

  const fullPrompt = `
You are a smart travel planning assistant.

Your job is to generate or update a travel itinerary based on:
1. The user prompt
2. The previous itinerary JSON (if any)
3. Chat history (optional)

Do not add explanations or natural language text.
Only return a JSON object matching this structure (Spec A):

{
  "title": "Kyoto 5-Day Solo Trip",
  "startDate": "2025-04-10",
  "endDate": "2025-04-15",
  "days": [
    {
      "date": "2025-04-10",
      "summary": "Fushimi Inari & Gion",
      "items": [
        { "time": "09:00", "activity": "Climb Fushimi Inari Shrine", "location": "34.9671,135.7727" },
        { "time": "14:00", "activity": "Lunch at Nishiki Market", "location": "35.0047,135.7630" },
        { "time": "18:30", "activity": "Evening walk in Gion", "location": "35.0037,135.7788" }
      ]
    }
  ]
}

---

User Prompt:
${prompt}

Previous Itinerary JSON:
${JSON.stringify(previousItinerary, null, 2)}

Chat History:
${chatHistory.map((msg: any) => `User: ${msg.user}\nBot: ${msg.bot}`).join("\n\n")}
`;


  try {
    const response = await axios.post(GEMINI_API_URL, {
      contents: [
        {
          role: "user",
          parts: [{ text: fullPrompt }],
        },
      ],
    });

    const modelReply = response.data.candidates[0]?.content?.parts[0]?.text || "";

    try {
      const itinerary = JSON.parse(modelReply);
      res.status(200).json(itinerary);
    } catch (err) {
      res.status(400).json({
        error: "Failed to parse Gemini response as JSON",
        raw: modelReply,
      });
    }
  } catch (err) {
    console.error("Gemini API error:", err);
    res.status(500).json({ error: "LLM API call failed" });
  }
});

exports.api = functions.https.onRequest(app);
