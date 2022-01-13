import Vapor

struct DiscogService: ArtistService {
    private let searchURL = "https://api.discogs.com/database/search"
    private let artistURL = "https://api.discogs.com/artists/"
    private let releaseURL = "https://api.discogs.com/releases/"

    private let headers: HTTPHeaders = [
        "Authorization": "Discogs token=\(Environment.apiToken)"
    ]

    func searchArtist(artist: String, on req: Request) throws -> Future<[Artist]> {
        var components = URLComponents(string: searchURL)
        components?.queryItems = [URLQueryItem(name: "q", value: artist)]

        guard let url = components?.url else {
            fatalError("Couldn't create search URL")
        }

        return try req.client().get(url, headers: headers).flatMap({ response in
            return try response.content.decode(ArtistSearchResponse.self).flatMap({ artistSearch in
                return req.future(artistSearch.results)
            })
        })
    }
    
    func searchArtistReleases(artistId: Int, release: String, on req: Request) throws -> Future<[Release]> {
        let url = artistURL + String(artistId) + "/releases"
        
        return try req.client().get(url, headers: headers).flatMap({ response in
            return try response.content.decode(ArtistReleasesResponse.self).flatMap({ artistReleases in
                return req.future(artistReleases.releases.filter { artistRelease in
                    return artistRelease.title.lowercased().contains(release.lowercased())
                })
            })
        })
    }
    
    func findRelease(id: Int, on req: Request) throws -> Future<Release> {
        let url = releaseURL + String(id)
        
        return try req.client().get(url, headers: headers).flatMap({response in
            let result = try response.content.decode(Release.self)
            return result
        })
    }
}
