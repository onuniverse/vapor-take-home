import Vapor
import FluentPostgreSQL

/// A list of releases.
final class Playlist: PostgreSQLModel {
    typealias Database = PostgreSQLDatabase
    
    /// The unique identifier for this `Playlist`.
    var id: Int?

    /// The name of the `Playlist`.
    var name: String
    
    /// A description of the`Playlist`.
    var description: String

    /// Creates a new `Playlist`.
    init(id: Int? = nil, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
    }
}

/// Allows `Playlist` to be encoded to and decoded from HTTP messages.
extension Playlist: Content { }

/// Allows `Playlist` to be used as a dynamic parameter in route definitions.
extension Playlist: Parameter { }

/// Allows quick access to `Release`s associated with this `Playlist`.
extension Playlist {
    var releases: Siblings<Playlist, Release, PlaylistRelease> {
        return siblings()
    }
}
