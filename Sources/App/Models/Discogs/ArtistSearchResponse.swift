import Foundation

struct ArtistSearchResponse: Decodable {
    struct Pagination: Decodable {
        struct URLs: Decodable {
            let last: URL
            let next: URL
        }

        let perPage: Int
        let pages: Int
        let page: Int
        let urls: URLs
        let items: Int

        enum CodingKeys: String, CodingKey {
            case perPage = "per_page"
            case pages
            case page
            case urls
            case items
        }
    }

    let pagination: Pagination
    let results: [Artist]
}
