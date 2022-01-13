import Vapor

extension HTTPHeaders {
    static var authorizationHeaders: HTTPHeaders {
        return HTTPHeaders([("Authorization", "Bearer \(Environment.apiToken)")])
    }
}
