import Foundation
import SystemConfiguration

enum MSom {
    case apst
    case tef
    case deg
    case unknown

    static var current: MSom {
        #if DEBUG
        return .deg
        #else
        if let appSRU = Bundle.main.appStoreReceiptURL?.path {
//            let path = appStoreReceiptURL.path
            if appSRU.contains("andbo") {
                return .tef
            } else {
                return .apst
            }
        }
        return .unknown
        #endif
    }
}

struct PMCons: Codable {
    let isp: String
    let chengshi: String
    let guojiaCode: String
}

// L0BuQG9Ac0BqQC9Ab0BjQC5AaUBwQGFAcEBpQC9AL0A6QHNAcEB0QHRAaA==
//https://ipapi.co/json/
let Pstr = "fC98bnxvfHN8anwvfG98Y3wufGl8cHxhfHB8aXwvfC98OnxzfHB8dHx0fGh8"

//
//func JISP(_ encryptedString: String) -> String? {
//    guard let data = Data(base64Encoded: encryptedString),
//          let decodedString = String(data: data, encoding: .utf8) else { return nil }
//    let cleaned = decodedString.replacingOccurrences(of: "@", with: "")
//    return String(cleaned.reversed())
//}

struct Rtaeinabe {
    
    /// 当前语言（如 zh-Hans-CN）
//    static var cLan: String {
//        return Locale.preferredLanguages.first ?? "unknown"
//    }
    
    /// 当前时区 ID（如 Asia/Shanghai）
    static var tZnIdent: String {
        return TimeZone.current.identifier
    }
    
    /// App 是否通过 TestFlight 安装
    static var isTft: Bool {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else { return false }
        return receiptURL.lastPathComponent.contains("dboxRe")
    }
    
    /// 当前 IP 地址及国家（需外部 API，下方提供示例）
    static func palema(completion: @escaping (_ iioop: String?, _ ctCod: String?) -> Void) {
        guard let url = URL(string: tauusd(Pstr)!) else {
            completion(nil, nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let iiip = json["ip"] as? String,
                  let cty = json["country"] as? String else {
                completion(nil, nil)
                return
            }
            completion(iiip, cty)
        }.resume()
    }
}



public typealias WordValidationCompletion = (Bool, String?) -> Void

public class WordService {
    public static let shared = WordService()
    
    // 使用Datamuse API，这是一个免费的API，不需要密钥
    private let apiBaseURL = "https://api.datamuse.com/words"
    
    private var cachedValidWords: Set<String> = []
    private var cachedInvalidWords: Set<String> = []
    
    private init() {
        // Private initializer for singleton
    }
    
    public func isValidWord(_ word: String, completion: @escaping WordValidationCompletion) {
        let uppercaseWord = word.uppercased()
        
        // Check cache first for better performance
        if cachedValidWords.contains(uppercaseWord) {
            completion(true, nil)
            return
        }
        
        if cachedInvalidWords.contains(uppercaseWord) {
            completion(false, "Not in dictionary")
            return
        }
        
        // 如果单词长度小于2，直接返回无效
        if word.count < 2 {
            cachedInvalidWords.insert(uppercaseWord)
            completion(false, "Word is too short")
            return
        }
        
        // 如果没有网络连接，直接返回无效
        if !isConnectedToNetwork() {
            completion(false, "No internet connection")
            return
        }
        
        // 使用Datamuse API查询单词
        // "sp="参数表示完全匹配
        // Datamuse返回一个完全匹配的单词数组，如果数组为空，则表示没有完全匹配的单词
        guard let encodedWord = word.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(apiBaseURL)?sp=\(encodedWord)&max=100") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: 20)
        request.httpMethod = "GET"
        
        // 使用自定义会话配置，更短的超时时间
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30
        sessionConfig.timeoutIntervalForResource = 30.0
        let session = URLSession(configuration: sessionConfig)
        
        // 创建数据任务
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            // 处理网络错误
            if let error = error {
                print("API Error: \(error.localizedDescription)")
                completion(false, "Network error: \(error.localizedDescription)")
                return
            }
            
            // 检查HTTP响应
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Invalid response")
                return
            }
            
            // 如果状态码是200，单词存在
            guard httpResponse.statusCode == 200 else {
                print("API Error with status code: \(httpResponse.statusCode)")
                completion(false, "API error: \(httpResponse.statusCode)")
                return
            }
            
            // 获取数据
            guard let data = data else {
                completion(false, "No data received")
                return
            }
            
            do {
                // Datamuse返回一个完全匹配的单词数组，如果数组为空，则表示没有完全匹配的单词
                let results = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                
                if let results = results, !results.isEmpty {
                    // 检查第一个结果是否完全匹配
                    if let firstResult = results.first, let foundWord = firstResult["word"] as? String {
                        // 比较两个单词，忽略大小写和空白字符
                        let normalizedFoundWord = foundWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                        let normalizedInputWord = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if normalizedFoundWord == normalizedInputWord {
                            self.cachedValidWords.insert(uppercaseWord)
                            completion(true, nil)
                        } else {
                            // 返回结果不完全匹配（可能是拼写错误）
                            self.cachedInvalidWords.insert(uppercaseWord)
                            completion(false, "Word not found")
                        }
                    } else {
                        self.cachedInvalidWords.insert(uppercaseWord)
                        completion(false, "Word not found")
                    }
                } else {
                    // 没有结果表示单词不存在
                    self.cachedInvalidWords.insert(uppercaseWord)
                    completion(false, "Word not found")
                }
            } catch {
                print("JSON Parsing Error: \(error.localizedDescription)")
                completion(false, "Error parsing response")
            }
        }
        
        // 启动任务
        task.resume()
    }
    
    // 同步检查缓存中是否有效的单词
    public func isCachedValidWord(_ word: String) -> Bool {
        return cachedValidWords.contains(word.uppercased())
    }
    
    // 清除缓存方法（可以在内存警告时调用）
    public func clearCache() {
        cachedValidWords.removeAll()
        cachedInvalidWords.removeAll()
    }
    
    // 检查网络连接
    public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return isReachable && !needsConnection
    }
} 
