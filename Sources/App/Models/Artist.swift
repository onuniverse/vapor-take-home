import Vapor

struct Artist: Codable {
    let id: Int
    let title: String
    let thumb: URL?
    let coverImage: URL?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        thumb = try? container.decode(URL.self, forKey: .thumb)
        coverImage = try container.decode(URL.self, forKey: .coverImage)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumb
        case coverImage = "cover_image"
    }
}

/// Allows `Artist` to be encoded to and decoded from HTTP messages.
extension Artist: Content { }
