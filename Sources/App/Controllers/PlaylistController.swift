import Vapor

/// Controls basic CRUD operations on `Playlist`s.
final class PlaylistController {
    /// Saves a decoded `Playlist` to the database.
    func create(_ req: Request) throws -> Future<PlaylistResponse> {
        return try req.content.decode(Playlist.self).flatMap { playlist in
            return playlist.save(on: req).flatMap { savedPlaylist in
                return try self.mapPlaylistResponse(playlist: savedPlaylist, req)
            }
        }
    }

    /// Returns a list of all `Playlist`s.
    func index(_ req: Request) throws -> Future<[PlaylistResponse]> {
        return Playlist.query(on: req).all().flatMap { playlists in
            let playlistResponses = try playlists.map { playlist in
                try self.mapPlaylistResponse(playlist: playlist, req)
            }
            
            return playlistResponses.flatten(on: req)
        }
    }

    /// Finds a parameterized `Playlist`.
    func find(_ req: Request) throws -> Future<PlaylistResponse> {
        return try req.parameters.next(Playlist.self).flatMap { playlist in
            return try self.mapPlaylistResponse(playlist: playlist, req)
        }
    }

    /// Updates a parameterized `Playlist`.
    func update(_ req: Request) throws -> Future<PlaylistResponse> {
        return try req.parameters.next(Playlist.self).flatMap({ playlist -> EventLoopFuture<PlaylistResponse> in
            return try req.content.decode(Playlist.self).flatMap { updatedPlaylist -> EventLoopFuture<PlaylistResponse> in
                playlist.name = updatedPlaylist.name
                playlist.description = updatedPlaylist.description
                return playlist.update(on: req).flatMap { savedPlaylist in
                    return try self.mapPlaylistResponse(playlist: savedPlaylist, req)
                }
            }
        })
    }

    /// Deletes a parameterized `Playlist`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Playlist.self).flatMap { playlist in
            /// not sure if Fluent/Vapor/etc will automatically delete pivot entries when one side is deleted; if I had more time I'd do a little research and adjust accordingly
            return playlist.delete(on: req)
        }.transform(to: .noContent)
    }
    
    /// Associates a `Release` with a `Playlist`
    func addRelease(_ req: Request) throws -> Future<PlaylistResponse> {
        let playlistId = try req.parameters.next(Int.self)
        let songId = try req.parameters.next(Int.self)
        let service = try req.make(ArtistService.self)

        /// really we should check the db for the release first, which would allow us to skip the discogs call in the event that we find an existing release, and also prevent us
        /// from storing duplicate releases. but I'm tired of trying to figure out how to get the value from an EventLoopFuture and I'm out of time anyway
        return try service.findRelease(id: songId, on: req).flatMap { discogsRelease in
            let newRelease = Release(mainRelease: discogsRelease.id, title: discogsRelease.title, thumb: discogsRelease.thumb)
            return newRelease.save(on: req).flatMap { savedRelease in
                let playlistRelease = PlaylistRelease(playlistId: playlistId, releaseId: savedRelease.id!)
                return playlistRelease.save(on: req).flatMap { savedPlaylistRelease in
                    return Playlist.find(playlistId, on: req).unwrap(or: fatalError("uh oh")).flatMap { playlist in
                        return try self.mapPlaylistResponse(playlist: playlist, req)
                    }
                }
            }
        }
    }
    
    /// Unassociates a `Release` from a `Playlist`
    /// wasn't able to figure out how to resolve the syntax errors on this, but this is as close as I got. this is kind of crude - I'd rather do something like check if the
    /// `Release` being removed from the `Playlist` is associated with any other playlists, and then if it's not, I'd remove the actual `Release` itself as
    /// well, instead of just the `PlaylistRelease`, but that's on me for deciding to store the Releases in the db
    /// it's also probably more complicated than it should be because of the whole id/main release id situation with the `Release` model - see my comments on
    /// the `Release` class for a more in-depth explanation on that
//    func removeReleaseFromPlaylist(_ req: Request) throws -> Future<HTTPStatus> {
//        let playlistId = try req.parameters.next(Int.self)
//        let songId = try req.parameters.next(Int.self)
//        return Release.query(on: req).filter(\.mainRelease, .equal, songId).first().flatMap { release in
//            let releaseId = release.unsafelyUnwrapped.id
//            return PlaylistRelease.query(on: req)
//                .filter(\.playlistID, .equal, playlistId)
//                .filter(\.releaseID, .equal, releaseId!)
//                .first()
//                .flatMap { playlistRelease in
//                    return playlistRelease.unsafelyUnwrapped.delete(on: req)
//                }
//        }.transform(to: .noContent)
//    }
    
    private func mapPlaylistResponse(playlist: Playlist, _ req: Request) throws -> Future<PlaylistResponse> {
        return try playlist.releases.query(on: req).all().map { releases in
            return PlaylistResponse(playlist: playlist, releases: releases)
        }
    }
}
