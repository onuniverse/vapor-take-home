import Vapor

struct Artist: Codable {
    let id: Int
    let title: String
    let thumb: String?
    let coverImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumb
        case coverImage = "cover_image"
    }
}

/// Allows `Artist` to be encoded to and decoded from HTTP messages.
extension Artist: Content { }
