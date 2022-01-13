import Vapor
import FluentPostgreSQL

/// Allows `User` to be used as a dynamic migration.
extension User: Migration { }
