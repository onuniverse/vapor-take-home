import Vapor
import FluentPostgreSQL

/// A single entry of a User list.
final class User: PostgreSQLModel {
    typealias Database = PostgreSQLDatabase
    
    /// The unique identifier for this `User`.
    var id: Int?

    /// A title describing what this `User` entails.
    var name: String

    /// Creates a new `User`.
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

/// Allows `User` to be used as a dynamic migration.
extension User: Migration { }

/// Allows `User` to be encoded to and decoded from HTTP messages.
extension User: Content { }

/// Allows `User` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }
