import Foundation
import Moya

class TokenSource {
    var token: String?
    init() { }
}

protocol AuthorizedTargetType : TargetType {
    var needsAuth: Bool { get }
}

struct AuthPlugin : PluginType {
    let tokenClosure: () -> String?
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        print("preparing...")
        guard
            let token = tokenClosure(),
            let target = target as? AuthorizedTargetType,
            target.needsAuth
        else {
            print("merp :(")
            return request
        }
        
        var request = request
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("meeeep :)")
        return request
    }
}
