import 'package:app/l10n/app_localizations.dart';

/// Maps a community category key to its localized label.
String communityCategoryLabel(AppLocalizations? l, String key) {
  switch (key) {
    case 'all':
      return l?.communityAll ?? 'All';
    case 'question':
      return l?.communityQuestion ?? 'Question';
    case 'recommend':
      return l?.communityRecommend ?? 'Tips';
    case 'free':
      return l?.communityFree ?? 'Free';
    case 'lostfound':
      return l?.communityLostFound ?? 'Lost & Found';
    case 'alert':
      return l?.communityAlert ?? 'Alert';
    default:
      return l?.communityGeneral ?? 'General';
  }
}
