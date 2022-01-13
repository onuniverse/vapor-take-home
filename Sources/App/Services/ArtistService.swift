import Foundation
import Vapor

protocol ArtistService: Service {
    func searchArtist(artist: String, on req: Request) throws -> Future<[Artist]>
    func searchArtistReleases(artistId: Int, release: String, on req: Request) throws -> Future<[Release]>
    /// see notes on `ReleaseService`
    func findRelease(id: Int, on req: Request) throws -> Future<Release>
}
