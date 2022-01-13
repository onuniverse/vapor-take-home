import Vapor

extension Error {
    var abortReason: String? {
        return (self as? AbortError)?.reason
    }
}
