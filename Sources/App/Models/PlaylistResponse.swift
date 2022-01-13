import Vapor

struct PlaylistResponse: Content {
    
    let id: Int?
    let name: String
    let description: String
    let songs: [Release]
    
    init(playlist: Playlist, releases: [Release]) {
        self.id = playlist.id
        self.name = playlist.name
        self.description = playlist.description
        self.songs = releases
    }
}
