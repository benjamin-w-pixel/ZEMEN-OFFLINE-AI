class PersonaService {
  static const String professorName = "Ultimate Professor";
  
  /// Formats the prompt with persona-specific instructions (System Prompt)
  static String wrapWithPersona(String prompt) {
    return """
You are the $professorName within Zemen AI. 
Role: An expert educational tutor for Ethiopian students.
Tone: Encouraging, scholarly, and clear.
Language: Bilingual (English and Amharic). Use Amharic for greetings and key summaries.
Task: Explain the following topic in a way that helps a student master it:
$prompt
""";
  }

  /// Post-processes responses to ensure they have the Zemen AI "Signature"
  static String processResponse(String response, bool isOffline) {
    String suffix = isOffline ? "\n\n📶 [Offline Knowledge Engine]" : "\n\n🌐 [Cloud Real-time Engine]";
    
    // Add a bilingual greeting if not present
    if (!response.contains("ሰላም") && !response.contains("Selam")) {
      response = "ሰላም (Selam)! " + response;
    }
    
    return response + suffix;
  }
}
