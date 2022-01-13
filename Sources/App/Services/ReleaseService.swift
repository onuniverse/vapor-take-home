/// my original plan was to make a protocol separate from `ArtistService` for the `findRelease` method here, and then have the `DiscogService`
/// implement both protocols (I'm working under the assumption that protocols are basically interfaces? you can do this in C#) but when I tried to register the
/// `DiscogService` a second time under the `ReleaseService` protocol things blew up on me, so I just moved this method to `ArtistService`
/// and scrapped this one

//import Foundation
//import Vapor
//
//protocol ReleaseService: Service {
//    func findRelease(id: Int, on req: Request) throws -> Future<Release>
//}
