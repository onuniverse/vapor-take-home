import Foundation
import Vapor
@testable import App

class MockArtistService: ArtistService, Service {
    var artistsToReturn: [Artist] = []
    var searchedArtists: [String] = []
    var releasesToReturn: [Release] = []

    func reset() {
        artistsToReturn = []
        searchedArtists = []
        releasesToReturn = []
    }

    // MARK - ArtistService
    func searchArtist(artist: String, on req: Request) throws -> EventLoopFuture<[Artist]> {
        searchedArtists.append(artist)
        return req.future(artistsToReturn)
    }
    
    func searchArtistReleases(artistId: Int, release: String, on req: Request) throws -> EventLoopFuture<[Release]> {
        return req.future(releasesToReturn)
    }
    
    func findRelease(id: Int, on req: Request) throws -> Future<Release> {
        return req.future(Release(id: nil, mainRelease: nil, title: "", thumb: nil))
    }
}
