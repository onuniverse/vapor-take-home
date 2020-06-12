import Foundation
import Vapor

protocol ArtistService: Service {
    func searchArtist(artist: String, on req: Request) throws -> Future<[Artist]>
}
