


import Foundation
//import Firebase
//import FirebaseRemoteConfig
enum ValueKey: String {
    case chatEnable = "i_chat_enabled"
    case historyEnable = "i_is_hist_odds"
    case liveRateEnable = "i_is_live_odds"
    case isOtherCountry = "isOtherCountry"
    case isPollEnable = "isPoll"
    case isShowIntAdss = "show_int_ad"
    case isShowSplashAdss = "splash_ad_enabled"
    case splashHoldTime = "splash_ad_hold"
    case splashTimeOut = "splash_time_out"
    case bannerAdsRefreshRate = "refresh_time"
    case bannerAdsId = "ad_id"
    case bannerAdsRefreshObject = "banner_ad_refresh_object"
    
}

class RemoteConfigValue {
//    static let sharedInstance = RemoteConfigValue()
//    private var remoteConfig: RemoteConfig!
//    var loadingDoneCallback: (() -> Void)?
//    var fetchComplete = false
//
//    private init() {
//        remoteConfig = RemoteConfig.remoteConfig()
//        activateDebugMode()
//        loadDefaultValues()
//        fetchCloudValues()
//    }
//
//    func activateDebugMode() {
//      #if NON_PROD
//        let settings = RemoteConfigSettings()
//        // WARNING: Don't actually do this in production!
//        settings.minimumFetchInterval = 0
//        RemoteConfig.remoteConfig().configSettings = settings
//     #else
//        // debug only code
//     #endif
//    }
//
//    func loadDefaultValues() {
//        remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
//    }
//
//    func fetchCloudValues() {
//        remoteConfig?.fetch { [weak self] _, error in
//            if let error = error {
//                CLGLog.debug("Uh-oh. Got an error fetching remote values \(error)")
//                // In a real app, you would probably want to call the loading done callback anyway,
//                // and just proceed with the default values. I won't do that here, so we can call attention
//                // to the fact that Remote Config isn't loading.
//                return
//            }
//            self?.remoteConfig?.activate { [weak self] _, error in
//                guard error == nil else { return }
//                self?.fetchComplete = true
//                DispatchQueue.main.async {
//                    self?.loadingDoneCallback?()
//                }
//            }
//        }
//    }
//
//    func addListenrForUpdate() {
////        remoteConfig?.addOnConfigUpdateListener { configUpdate, error in
////          guard let configUpdate, error == nil else {
////              CLGLog.debug("Error listening for config updates: \(error)")
////          }
////
////            CLGLog.debug("Updated keys: \(configUpdate.updatedKeys)")
////
////          self.remoteConfig.activate { [weak self] _, error in
////              guard error == nil else { return }
////              self?.fetchComplete = true
////              DispatchQueue.main.async {
////                  self?.loadingDoneCallback?()
////              }
////          }
////        }
//    }
//
//    func bool(forKey key: ValueKey) -> Bool {
//        RemoteConfig.remoteConfig()[key.rawValue].boolValue
//    }
//
//    func string(forKey key: ValueKey) -> String {
//        RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
//    }
//
//    func double(forKey key: ValueKey) -> Double {
//        RemoteConfig.remoteConfig()[key.rawValue].numberValue.doubleValue
//    }
//    func BannerJsonDataString(forKey key: ValueKey) -> String {
//        var data = ""
//        if let dict = RemoteConfig.remoteConfig()["banner_ad_refresh_object"].jsonValue as? [String : Any] {
//            data = dict[key.rawValue] as? String ?? ""
//        }
//        return data
//    }
//    func BannerJsonDataDouble(forKey key: ValueKey) -> Double {
//        var data = 0.0
//        if let dict = RemoteConfig.remoteConfig()["banner_ad_refresh_object"].jsonValue as? [String : Any] {
//            data = dict[key.rawValue] as? Double ?? 0.0
//        }
//        return data
//    }
}
