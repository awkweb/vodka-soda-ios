import Foundation

enum VodkaSodaSecrets {
    
    static let baseUrl = VodkaSodaSecrets.environmentVariable(named: "VODKA_SODA_BASE_URL") ?? ""
    static let clientID = VodkaSodaSecrets.environmentVariable(named: "VODKA_SODA_CLIENT_ID") ?? ""
    static let clientSecret = VodkaSodaSecrets.environmentVariable(named: "VODKA_SODA_CLIENT_SECRET") ?? ""
    
    static func environmentVariable(named: String) -> String? {
        let processInfo = ProcessInfo.processInfo
        guard let value = processInfo.environment[named] else {
            print("‼️ Missing Environment Variable: '\(named)'")
            return nil
        }
        return value
    }
    
}
