import Vapor

final class ArtistController {
    
    /// Searches Discogs for artist
    func searchArtist(_ req: Request) throws -> Future<[Artist]> {
        let artistString = try req.query.get(String.self, at: "q")
        let service = try req.make(DiscogService.self)
        return try service.searchArtist(artist: artistString, on: req)
    }
}
