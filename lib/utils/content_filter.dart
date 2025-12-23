/// Content filtering utility for detecting objectionable content.
/// 
/// This class provides basic keyword-based filtering to help prevent
/// objectionable content from being posted. For production, consider
/// integrating with a more sophisticated content moderation service.
class ContentFilter {
  // List of objectionable keywords (basic implementation)
  // In production, this should be more comprehensive and possibly
  // loaded from a server or use a professional content moderation API
  static const List<String> _prohibitedKeywords = [
    // Add your prohibited keywords here
    // This is a basic implementation - consider using a professional service
  ];

  /// Checks if content contains objectionable keywords.
  /// 
  /// Returns true if content is clean, false if it contains prohibited content.
  static bool isContentClean(String content) {
    if (content.isEmpty) return true;
    
    final lowerContent = content.toLowerCase();
    
    // Check against prohibited keywords
    for (final keyword in _prohibitedKeywords) {
      if (lowerContent.contains(keyword.toLowerCase())) {
        return false;
      }
    }
    
    return true;
  }

  /// Filters content and returns a sanitized version.
  /// 
  /// Replaces prohibited keywords with asterisks.
  static String filterContent(String content) {
    if (content.isEmpty) return content;
    
    String filtered = content;
    final lowerContent = content.toLowerCase();
    
    for (final keyword in _prohibitedKeywords) {
      if (lowerContent.contains(keyword.toLowerCase())) {
        final regex = RegExp(keyword, caseSensitive: false);
        filtered = filtered.replaceAll(regex, '*' * keyword.length);
      }
    }
    
    return filtered;
  }

  /// Validates title and description for objectionable content.
  /// 
  /// Returns null if content is clean, otherwise returns an error message.
  static String? validateContent({
    required String? title,
    required String? description,
  }) {
    if (title != null && !isContentClean(title)) {
      return 'Title contains prohibited content. Please revise your title.';
    }
    
    if (description != null && !isContentClean(description)) {
      return 'Description contains prohibited content. Please revise your description.';
    }
    
    return null;
  }
}

