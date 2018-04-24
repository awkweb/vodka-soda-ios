import Foundation
import Moya

enum VodkaSodaAPI {
    case convertToken(token: String)
    case me
    case refreshToken
    case updateMe(displayName: String, bio: String)
    case users
    case user(id: String)
}

extension VodkaSodaAPI : TargetType, AuthorizedTargetType {
    
    var baseURL: URL { return URL(string: VodkaSodaSecrets.baseUrl)! }
    
    var path: String {
        switch self {
        case .convertToken:
            return "/auth/convert-token/"
        case .me,
             .updateMe:
            return "/me/"
        case .refreshToken:
            return "/auth/token/"
        case .users:
            return "/users/"
        case .user(let id):
            return "/users/\(id)/"
        }
    }
    
    var needsAuth: Bool {
        switch self {
        case .convertToken,
            .refreshToken:
            return false
        default:
            return true
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .convertToken,
             .refreshToken:
            return .post
        case .updateMe:
            return .put
        default:
            return .get
        }
    }
    
    var task: Task {
        let encoding: ParameterEncoding
        switch self.method {
        case .post:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: encoding)
        }
        return .requestPlain
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var parameters: [String: Any]? {
        switch self {
            
        case .convertToken(let token):
            return [
                "grant_type": "convert_token",
                "client_id": VodkaSodaSecrets.clientID,
                "client_secret": VodkaSodaSecrets.clientSecret,
                "backend": "facebook",
                "token": token as AnyObject
            ]
            
        case .updateMe(let displayName, let bio):
            return [
                "displayName": displayName as AnyObject,
                "bio": bio as AnyObject
            ]
            
        default:
            return nil
        }
    }
    
}
