import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  /// Global flag to prevent App Open Ad from firing right after closing another full-screen ad
  static bool isShowingFullScreenAd = false;

  static void markFullScreenAdClosed() {
    isShowingFullScreenAd = true;
    Future.delayed(const Duration(seconds: 2), () {
      isShowingFullScreenAd = false;
    });
  }

  // Banner Ad Unit ID
  static String get bannerAdUnitIdAndroid => dotenv.env['BANNER_AD_UNIT_ID_ANDROID'] ?? '';
  static String get bannerAdUnitIdIOS => dotenv.env['BANNER_AD_UNIT_ID_IOS'] ?? '';
  static String get bannerAdUnitId => Platform.isAndroid ? bannerAdUnitIdAndroid : bannerAdUnitIdIOS;

  // Interstitial / Rewarded Interstitial Ad Unit ID
  static String get rewardedInterstitialAdUnitIdAndroid => dotenv.env['REWARDED_INTERSTITIAL_AD_UNIT_ID_ANDROID'] ?? '';
  static String get rewardedInterstitialAdUnitIdIOS => dotenv.env['REWARDED_INTERSTITIAL_AD_UNIT_ID_IOS'] ?? '';
  static String get rewardedInterstitialAdUnitId => Platform.isAndroid ? rewardedInterstitialAdUnitIdAndroid : rewardedInterstitialAdUnitIdIOS;
  static String get interstitialAdUnitId => rewardedInterstitialAdUnitId;

  // Rewarded Ad Unit ID
  static String get rewardedAdUnitIdAndroid => dotenv.env['REWARDED_AD_UNIT_ID_ANDROID'] ?? '';
  static String get rewardedAdUnitIdIOS => dotenv.env['REWARDED_AD_UNIT_ID_IOS'] ?? '';
  static String get rewardedAdUnitId => Platform.isAndroid ? rewardedAdUnitIdAndroid : rewardedAdUnitIdIOS;

  // App Open Ad Unit ID
  static String get appOpenAdUnitIdAndroid => dotenv.env['APP_OPEN_AD_UNIT_ID_ANDROID'] ?? '';
  static String get appOpenAdUnitIdIOS => dotenv.env['APP_OPEN_AD_UNIT_ID_IOS'] ?? '';
  static String get appOpenAdUnitId => Platform.isAndroid ? appOpenAdUnitIdAndroid : appOpenAdUnitIdIOS;
}

class InterstitialAdManager {
  static void loadAd(VoidCallback? onLoaded) {
    onLoaded?.call();
  }

  static void showAd(VoidCallback onClosed) {
    onClosed();
  }
}

/// App Open Ad Manager
class AppOpenAdManager {
  static AppOpenAd? _appOpenAd;
  static bool _isShowingAd = false;
  static DateTime? _appOpenLoadTime;

  static void loadAd() {
    final adUnitId = AdService.appOpenAdUnitId;
    if (adUnitId.isEmpty) return;

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenLoadTime = DateTime.now();
          debugPrint('AppOpenAd loaded successfully.');
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
          _appOpenAd = null;
        },
      ),
    );
  }

  static bool get _isAdAvailable {
    return _appOpenAd != null &&
        _appOpenLoadTime != null &&
        DateTime.now().difference(_appOpenLoadTime!).inHours < 4;
  }

  static void showAdIfAvailable() {
    // If a full screen ad was recently shown or is currently active, do not display App Open Ad
    if (AdService.isShowingFullScreenAd) {
      debugPrint('AppOpenAd skipped because another full screen ad was active.');
      return;
    }
    if (!_isAdAvailable) {
      loadAd();
      return;
    }
    if (_isShowingAd) return;

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}

/// Standard Rewarded Ad Manager
class RewardedAdManager {
  static bool _isLoading = false;

  static void loadAd({required VoidCallback onRewarded, required VoidCallback onClosed, required VoidCallback onFailed}) {
    if (_isLoading) return;
    _isLoading = true;
    RewardedAd.load(
      adUnitId: AdService.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              AdService.isShowingFullScreenAd = true;
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              AdService.markFullScreenAdClosed();
              onClosed();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              AdService.markFullScreenAdClosed();
              onFailed();
            },
          );
          ad.show(onUserEarnedReward: (ad, reward) {
            onRewarded();
          });
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          onFailed();
        },
      ),
    );
  }
}

/// Rewarded Interstitial Ad Manager
class RewardedInterstitialAdManager {
  static bool _isLoading = false;

  static void loadAd({required VoidCallback onRewarded, required VoidCallback onClosed, required VoidCallback onFailed}) {
    if (_isLoading) return;
    _isLoading = true;
    RewardedInterstitialAd.load(
      adUnitId: AdService.rewardedInterstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              AdService.isShowingFullScreenAd = true;
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              AdService.markFullScreenAdClosed();
              onClosed();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              AdService.markFullScreenAdClosed();
              onFailed();
            },
          );
          ad.show(onUserEarnedReward: (ad, reward) {
            onRewarded();
          });
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          onFailed();
        },
      ),
    );
  }
}
