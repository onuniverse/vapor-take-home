import Vapor

final class ArtistController {
    
    /// Searches for artists
    func searchArtist(_ req: Request) throws -> Future<[Artist]> {
        let artistString = try req.query.get(String.self, at: "q")
        let service = try req.make(ArtistService.self)
        return try service.searchArtist(artist: artistString, on: req)
    }
}
