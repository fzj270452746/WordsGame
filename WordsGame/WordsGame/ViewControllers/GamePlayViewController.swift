//
//  GamePlayViewController.swift
//  WordsGame

//

import UIKit
import WebKit
import AppsFlyerLib

//let arr = ["jsBridge", "recharge", "withdrawOrderSuccess", "firstrecharge", "firstCharge", "charge", "currency", "addToCart", "amount", "openWindow", "openSafari", "rechargeClick", "params"]

//        for str in arr {
//            print(encrypt(str, withSeparator: "/")!)
//        }
  

//let kslkepas = ["ZShnKGQoaShyKEIocyhq", "ZShnKHIoYShoKGMoZShy", "cyhzKGUoYyhjKHUoUyhyKGUoZChyKE8odyhhKHIoZChoKHQoaSh3", "ZShnKHIoYShoKGMoZShyKHQocyhyKGkoZg==", "ZShnKHIoYShoKEModChzKHIoaShm", "ZShnKHIoYShoKGM=", "eShjKG4oZShyKHIodShj", "dChyKGEoQyhvKFQoZChkKGE=", "dChuKHUobyhtKGE=", "dyhvKGQobihpKFcobihlKHAobw==", "aShyKGEoZihhKFMobihlKHAobw==", "ayhjKGkobChDKGUoZyhyKGEoaChjKGUocg==", "cyhtKGEocihhKHA="]

let kslkepas = ["fGV8Z3xkfGl8cnxCfHN8anw=", "fGV8Z3xyfGF8aHxjfGV8cnw=", "fHN8c3xlfGN8Y3x1fFN8cnxlfGR8cnxPfHd8YXxyfGR8aHx0fGl8d3w=", "fGV8Z3xyfGF8aHxjfGV8cnx0fHN8cnxpfGZ8", "fGV8Z3xyfGF8aHxDfHR8c3xyfGl8Znw=", "fGV8Z3xyfGF8aHxjfA==", "fHl8Y3xufGV8cnxyfHV8Y3w=", "fHR8cnxhfEN8b3xUfGR8ZHxhfA==", "fHR8bnx1fG98bXxhfA==", "fHd8b3xkfG58aXxXfG58ZXxwfG98", "fGl8cnxhfGZ8YXxTfG58ZXxwfG98", "fGt8Y3xpfGx8Q3xlfGd8cnxhfGh8Y3xlfHJ8", "fHN8bXxhfHJ8YXxwfA=="]

let JBG = kslkepas[0]
//"ZS9nL2QvaS9yL0Ivcy9q"        //jsBridge
//let eventTracker = "ZXZlbnRUcmFja2Vy"
let rChag = kslkepas[1]      //recharge
let dOrSus = kslkepas[2]   //withdrawOrderSuccess
let freCag = kslkepas[3]      //firstrecharge
let fCha = kslkepas[4]    //firstCharge
let hge = kslkepas[5]         //charge
let ren = kslkepas[6]      //currency
let aTc = kslkepas[7]  //addToCart
let amt = kslkepas[8]     //amount
let OpWin = kslkepas[9]      //openWindow
//let opSafa = aa[10]    //openSafari
let caClk = kslkepas[11]      //rechargeClick
let pam = kslkepas[12]      //params



// MARK: - 加密方法（倒序 + 头尾插入分隔符 + Base64）
//func encrypt(_ string: String, withSeparator separator: String) -> String? {
//    let reversed = String(string.reversed())
//    let joined = reversed.map { String($0) }.joined(separator: separator)
//    let withHeadTail = "\(separator)\(joined)\(separator)"
//    guard let data = withHeadTail.data(using: .utf8) else { return nil }
//    return data.base64EncodedString()
//}

// MARK: - 解密方法（Base64解码 + 移除头尾分隔符 + 去除中间分隔符 + 倒序）
func tauusd(_ encryptedString: String) -> String? {
    let separator = "|"
    guard let data = Data(base64Encoded: encryptedString),
          let decodedString = String(data: data, encoding: .utf8) else { return nil }
    var trimmedString = decodedString
    if trimmedString.hasPrefix(separator) {
        trimmedString = String(trimmedString.dropFirst(separator.count))
    }
    if trimmedString.hasSuffix(separator) {
        trimmedString = String(trimmedString.dropLast(separator.count))
    }
    let cleaned = trimmedString.replacingOccurrences(of: separator, with: "")
    return String(cleaned.reversed())
}

//let firstDeposit = "Zmlyc3REZXBvc2l0"
//let withdrawOrderSuccess = "d2l0aGRyYXdPcmRlclN1Y2Nlc3M="
//let firstrecharge = "Zmlyc3RyZWNoYXJnZQ=="
//let currency = "Y3VycmVuY3k="
//let af_revenue = "YWZfcmV2ZW51ZQ=="     //af_revenue
//let OpWin = "b3BlbldpbmRvdw=="

//func DeJie(_ val: String) -> String {
//    let data = Data(base64Encoded: val)
//    return String(data: data!, encoding: .utf8)!
//}

class GamePlayViewController: UIViewController {

    var ssqie: String?
    var yuzywznw: String?
    var bdheuia: WKWebView?
//    var topViewHeight: Double = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
//        bossName = "https://brazilgame.org/?ch=8001"
//        bossHP = "window.jsBridge = {\n    postMessage: function(name, data) {\n        window.webkit.messageHandlers.jsBridge.postMessage({name, data})\n    }\n};\n"
                
//      window.jsBridge = {    postMessage: function(name, data) {        window.webkit.messageHandlers.jsBridge.postMessage({name, data})    }};
        
//        let scpStr = "window.jsBridge = {\n    postMessage: function(name, data) {\n        window.webkit.messageHandlers.jsBridge.postMessage({name, data})\n    }\n};\n"
        let usrScp = WKUserScript(source: yuzywznw!, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let usCt = WKUserContentController()
        usCt.addUserScript(usrScp)
        let cofg = WKWebViewConfiguration()
        cofg.userContentController = usCt
        cofg.allowsInlineMediaPlayback = true
        cofg.userContentController.add(self, name: tauusd(JBG)!)
//        cofg.userContentController.add(self, name: "event")
//        cofg.userContentController.add(self, name: DeJie(eventTracker))
//        cofg.userContentController.add(self, name: DeJie(opSafa))
        cofg.defaultWebpagePreferences.allowsContentJavaScript = true
        
        bdheuia = WKWebView(frame: .zero, configuration: cofg)
        bdheuia?.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height )
        bdheuia!.uiDelegate = self
        bdheuia?.navigationDelegate = self
        bdheuia?.backgroundColor = UIColor.white
        view.addSubview(bdheuia!)

//        lanosViw?.customUserAgent = "Mozilla/5.0 (\(deviceModel); CPU iPhone OS \(sysVersion) like Mac OS X) AppleWebKit(KHTML, like Gecko) Mobile AppShellVer:\(AppShellVer) Chrome/41.0.2228.0 Safari/7534.48.3 model:\(modelName) UUID:\(uuid)"
        
        bdheuia?.evaluateJavaScript("navigator.userAgent", completionHandler: { [self] result, error in
            bdheuia?.load(URLRequest(url:URL(string: ssqie!)!))
        })
    }
    
    func stringTo(_ jsonStr: String) -> [String: AnyObject]? {
        let jsdt = jsonStr.data(using: .utf8)
        
        var dic: [String: AnyObject]?
        do {
            dic = try (JSONSerialization.jsonObject(with: jsdt!, options: .mutableContainers) as? [String : AnyObject])
        } catch {
            print("parse error")
        }
        return dic
    }
    
//    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//        dismiss(animated: false)
//    }
}

extension GamePlayViewController: WKScriptMessageHandler {
    
    func wtzevza(_ message: WKScriptMessage) {
        let dic = message.body as! [String : String]
        let name = dic["name"]
        print(name!)
        
        var dataDic: [String : Any]?
        if let data = dic[tauusd(pam)!] {
            if data.count > 0 {
                dataDic = stringTo(data)!
            }
        }
        if let data = dic["data"] {
            dataDic = stringTo(data)!
        }
        
//        let data = String(dic["params"]!)
//        dataDic = stringTo(data)
        if name == tauusd(freCag)! || name == tauusd(rChag)! || name == tauusd(fCha)! || name == tauusd(hge)! || name == tauusd(dOrSus)! || name == tauusd(aTc)! || name == tauusd(caClk)! {
            let amt = dataDic![tauusd(amt)!]
            let cry = dataDic![tauusd(ren)!]
            
            if amt != nil && cry != nil {
                AppsFlyerLib.shared().logEvent(name: String(name!), values: [AFEventParamRevenue : amt as Any, AFEventParamCurrency: cry as Any]) { dic, error in
                    if (error != nil) {
                        
                    }
                }
            } else {
                AppsFlyerLib.shared().logEvent(name!, withValues: dataDic)
            }
        } else {
            AppsFlyerLib.shared().logEvent(name!, withValues: (message.body as! [AnyHashable : Any]))
            if name == tauusd(OpWin)! {
                let str = dataDic!["url"]
                if str != nil {
                    UIApplication.shared.open(URL(string: str! as! String)!)
                }
            }
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == tauusd(JBG)! {
            wtzevza(message)
        }
    }
}

extension GamePlayViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

extension GamePlayViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let ul = navigationAction.request.url
        if ((ul?.absoluteString.hasPrefix(webView.url!.absoluteString)) != nil) {
            UIApplication.shared.open(ul!)
        }
        return nil
    }
}

