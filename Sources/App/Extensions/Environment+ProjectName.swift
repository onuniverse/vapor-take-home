import FluentPostgreSQL
import Vapor

public extension Environment {
    
    func databaseConfig() throws -> PostgreSQLDatabaseConfig {
        var databaseConfiguration: PostgreSQLDatabaseConfig?
        switch self {
        case .testing:
            databaseConfiguration = PostgreSQLDatabaseConfig(url: Environment.databaseURL)
        case .development:
            databaseConfiguration = PostgreSQLDatabaseConfig(url: Environment.databaseURL)
        default:
            // `transport: .unverifiedTLS` is what you would commonly use for paid Heroku PostgreSQL plans.
            databaseConfiguration = PostgreSQLDatabaseConfig(url: Environment.databaseURL, transport: .unverifiedTLS)
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

    static var apiToken: String {
        guard let url = Environment.get("API_TOKEN") else {
            fatalError("API_TOKEN is not set.")
        }
        return url
    }
}
