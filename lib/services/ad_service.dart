import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static String get bannerAdUnitIdAndroid => dotenv.env['BANNER_AD_UNIT_ID_ANDROID'] ?? '';
  static String get bannerAdUnitIdIOS => dotenv.env['BANNER_AD_UNIT_ID_IOS'] ?? '';
  static String get bannerAdUnitId => Platform.isAndroid ? bannerAdUnitIdAndroid : bannerAdUnitIdIOS;

  static String get interstitialAdUnitIdAndroid => dotenv.env['INTERSTITIAL_AD_UNIT_ID_ANDROID'] ?? '';
  static String get interstitialAdUnitIdIOS => dotenv.env['INTERSTITIAL_AD_UNIT_ID_IOS'] ?? '';
  static String get interstitialAdUnitId => Platform.isAndroid ? interstitialAdUnitIdAndroid : interstitialAdUnitIdIOS;

  static String get testRewardedInterstitialAdUnitIdAndroid => dotenv.env['REWARDED_INTERSTITIAL_AD_UNIT_ID_ANDROID'] ?? '';
  static String get testRewardedInterstitialAdUnitIdIOS => dotenv.env['REWARDED_INTERSTITIAL_AD_UNIT_ID_IOS'] ?? '';
  static String get rewardedInterstitialAdUnitId => Platform.isAndroid ? testRewardedInterstitialAdUnitIdAndroid : testRewardedInterstitialAdUnitIdIOS;
}

class InterstitialAdManager {
  static InterstitialAd? _ad;
  static bool _isLoading = false;

  static void loadAd(VoidCallback? onLoaded) {
    if (_ad != null || _isLoading) return;
    _isLoading = true;
    InterstitialAd.load(
      adUnitId: AdService.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _isLoading = false;
          onLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          _ad = null;
          _isLoading = false;
          onLoaded?.call();
        },
      ),
    );
  }

  static void showAd(VoidCallback onClosed) {
    if (_ad == null) {
      onClosed();
      return;
    }
    _ad!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        loadAd(null);
        onClosed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _ad = null;
        loadAd(null);
        onClosed();
      },
    );
    _ad!.show();
  }
}

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
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onClosed();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
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
