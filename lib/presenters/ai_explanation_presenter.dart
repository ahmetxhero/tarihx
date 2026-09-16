import '../services/gemini_service.dart';

abstract class AIExplanationView {
  void onExplanationLoaded(String explanation);
  void onExplanationError(String error);
  void onExplanationLoading();
}

class AIExplanationPresenter {
  final AIExplanationView view;

  AIExplanationPresenter(this.view);

  Future<String> getExplanation(String text, String lang) async {
    view.onExplanationLoading();
    try {
      final explanation = await GeminiService.fetchExplanation(text, lang);
      view.onExplanationLoaded(explanation);
      return explanation;
    } catch (e) {
      view.onExplanationError(e.toString());
      rethrow;
    }
  }
}
