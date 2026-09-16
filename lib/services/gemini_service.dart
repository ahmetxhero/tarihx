import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static Future<String> fetchExplanation(String text, String lang) async {
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent');

    String prompt;
    switch (lang) {
      case 'tr':
        prompt = 'Aşağıdaki tarihi olay hakkında kısa, anlaşılır ve eğitici bir açıklama yaz.\n\nOlay: $text';
        break;
      case 'en':
        prompt = 'Write a short, clear, and educational explanation about the following historical event.\n\nEvent: $text';
        break;
      case 'de':
        prompt = 'Schreiben Sie eine kurze, klare und lehrreiche Erklärung zu folgendem historischen Ereignis.\n\nEreignis: $text';
        break;
      case 'fr':
        prompt = 'Rédigez une explication courte, claire et éducative sur l\'événement historique suivant.\n\nÉvénement : $text';
        break;
      case 'es':
        prompt = 'Escribe una explicación corta, clara y educativa sobre el siguiente acontecimiento histórico.\n\nAcontecimiento: $text';
        break;
      case 'it':
        prompt = 'Scrivi una breve, chiara ed educativa spiegazione del seguente evento storico.\n\nEvento: $text';
        break;
      case 'ru':
        prompt = 'Напишите краткое, понятное и познавательное объяснение следующего исторического события.\n\nСобытие: $text';
        break;
      case 'uk':
        prompt = 'Напишіть коротке, зрозуміле та повчальне пояснення наступної історичної події.\n\nПодія: $text';
        break;
      case 'zh':
        prompt = '请对以下历史事件写一段简短、清晰且有教育意义的说明。\n\n事件：$text';
        break;
      default:
        prompt = 'Write a short, clear, and educational explanation about the following historical event.\n\nEvent: $text';
    }

    final body = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "X-goog-api-key": _apiKey,
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final candidates = data['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final parts = candidates[0]['content']['parts'] as List?;
        if (parts != null && parts.isNotEmpty) {
          return parts[0]['text'] ?? '';
        }
      }
      return tr('ai_explanation_not_found');
    } else {
      return tr('ai_explanation_api_error', args: [response.statusCode.toString(), response.body.toString()]);
    }
  }
}
