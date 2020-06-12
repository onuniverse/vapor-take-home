import Foundation
import Vapor
@testable import App

class MockArtistService: ArtistService, Service {
    var artistsToReturn: [Artist] = []
    var searchedArtists: [String] = []

    func reset() {
        artistsToReturn = []
        searchedArtists = []
    }

    // MARK - ArtistService
    func searchArtist(artist: String, on req: Request) throws -> EventLoopFuture<[Artist]> {
        searchedArtists.append(artist)
        return req.future(artistsToReturn)
    }
}
