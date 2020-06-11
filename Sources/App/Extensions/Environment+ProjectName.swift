import FluentPostgreSQL
import Vapor

public extension Environment {
    
    var databaseURL: String {
        switch self {
        case .testing:
            return Environment.databaseTestingURL
        case .development:
            return Environment.databaseURL
        default:
            return Environment.databaseURL
        }
    }
    
    func databaseConfig() throws -> PostgreSQLDatabaseConfig {
        var databaseConfiguration: PostgreSQLDatabaseConfig?
        switch self {
        case .testing:
            databaseConfiguration = PostgreSQLDatabaseConfig(url: databaseURL)
        case .development:
            databaseConfiguration = PostgreSQLDatabaseConfig(url: databaseURL)
        default:
            // `transport: .unverifiedTLS` is what you would commonly use for paid Heroku PostgreSQL plans.
            databaseConfiguration = PostgreSQLDatabaseConfig(url: databaseURL, transport: .unverifiedTLS)
        }
        
        guard let configuration = databaseConfiguration else {
            throw Abort(HTTPResponseStatus.internalServerError, reason: "Unable to generate database configuration.")
        }
        
        return configuration
    }
    
    static var databaseURL: String {
        guard let url = Environment.get("DATABASE_URL") else {
            fatalError("DATABASE_URL is not set.")
        }
        return url
    }
    
    static var databaseTestingURL: String {
        guard let url = Environment.get("DATABASE_TEST_URL") else {
            fatalError("DATABASE_TEST_URL is not set.")
        }
        return url
    }
}
