import 'package:in_app_review/in_app_review.dart';

class ReviewService {
  static Future<void> requestReview() async {
    final review = InAppReview.instance;

    if (await review.isAvailable()) {
      await review.requestReview();
    } else {
      await review.openStoreListing(appStoreId: 'YOUR_APP_STORE_ID');
    }
  }
}
