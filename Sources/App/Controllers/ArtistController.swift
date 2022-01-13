import Vapor

final class ArtistController {
    
    /// Searches for artists
    func searchArtist(_ req: Request) throws -> Future<[Artist]> {
        let artistString = try req.query.get(String.self, at: "q")
        let service = try req.make(ArtistService.self)
        return try service.searchArtist(artist: artistString, on: req)
    }
    
    /// Searches for releases by a given artist
    func searchArtistReleases(_ req: Request) throws -> Future<[Release]> {
        let id = try req.parameters.next(Int.self)
        let releaseString = try req.query.get(String.self, at: "q")
        let service = try req.make(ArtistService.self)
        return try service.searchArtistReleases(artistId: id, release: releaseString, on: req)
    }
    
    /// Retrieves a release given the main release id (I added this for testing purposes, before attempting to integrate it into the playlist controller)
    func findRelease(_ req: Request) throws -> Future<Release> {
        let id = try req.parameters.next(Int.self)
        let service = try req.make(ArtistService.self)
        let release = try service.findRelease(id: id, on: req)
        return release
    }
}
