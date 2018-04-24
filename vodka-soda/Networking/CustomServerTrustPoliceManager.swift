import Alamofire

class CustomServerTrustPoliceManager : ServerTrustPolicyManager { // from https://github.com/Moya/Moya/issues/992
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return .disableEvaluation
    }
    public init() {
        super.init(policies: [:])
    }
}
