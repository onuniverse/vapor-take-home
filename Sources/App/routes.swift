import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Basic "Hello Universe" example
    router.get { req in
        return "Hello Universe"
    }

    // Example of configuring a controller
    let userController = UserController()
    router.post("users", use: userController.create)
    router.get("users", User.parameter, use: userController.find)
    router.get("users", use: userController.index)
    router.put("users", User.parameter, use: userController.update)
    router.delete("users", User.parameter, use: userController.delete)

    let artistController = ArtistController()
    router.get("artists/search", use: artistController.searchArtist)
    router.get("artists", Int.parameter, "songs", use: artistController.searchArtistReleases)
    router.get("releases", Int.parameter, use: artistController.findRelease)
    
    let playlistController = PlaylistController()
    router.post("playlists", use: playlistController.create)
    router.get("playlists", use: playlistController.index)
    router.get("playlists", Playlist.parameter, use: playlistController.find)
    router.put("playlists", Playlist.parameter, use: playlistController.update)
    router.delete("playlists", Playlist.parameter, use: playlistController.delete)
    router.post("playlists", Int.parameter, "songs", Int.parameter, use: playlistController.addRelease)
    /// missing the delete song endpoint because I couldn't figure out my syntax issues
}
