import Vapor
import FluentPostgreSQL

/// Allows `Release` to be used as a dynamic migration.
extension Release: Migration { }
