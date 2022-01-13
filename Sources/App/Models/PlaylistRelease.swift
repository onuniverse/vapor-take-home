import Vapor
import FluentPostgreSQL

/// A single entry of a release list
final class PlaylistRelease: PostgreSQLPivot & ModifiablePivot {
    typealias Database = PostgreSQLDatabase
    typealias Left = Playlist
    typealias Right = Release
    
    static var leftIDKey: LeftIDKey = \.playlistID
    static var rightIDKey: RightIDKey = \.releaseID
    
    var id: Int?
    var playlistID: Int
    var releaseID: Int
    
    init(playlistId: Int, releaseId: Int) {
        self.playlistID = playlistId
        self.releaseID = releaseId
    }
    
    init(_ playlist: Playlist, _ release: Release) throws {
        playlistID = try playlist.requireID()
        releaseID = try release.requireID()
    }
}

/// Allows `PlaylistRelease` to be encoded to and decoded from HTTP messages.
extension PlaylistRelease: Content { }
