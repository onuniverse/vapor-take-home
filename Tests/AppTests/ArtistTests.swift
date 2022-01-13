@testable import App
import FluentPostgreSQL
@testable import Vapor
import XCTest

class ArtistTests: XCTestCase {

    var app: Application!
    var connection: PostgreSQLConnection!
    var request: Request!
    var mockArtistService: MockArtistService!

    override func setUp() {
        do {
            try Application.reset()
            app = try Application.testable()
            connection = try self.app.newConnection(to: .psql).wait()
        }
        catch {
            fatalError(error.localizedDescription)
        }

        request = Request(using: self.app)
        mockArtistService = try! request.make(MockArtistService.self)
        mockArtistService.reset()
    }

    override func tearDown() {
        connection?.close()
        try? app.syncShutdownGracefully()
    }

    func testGetArtists() throws {
        let mockArtists = [
            Artist(id: 1, title: "Artist1", thumb: nil, coverImage: nil),
            Artist(id: 2, title: "Artist2", thumb: nil, coverImage: nil)
        ]

        mockArtistService.artistsToReturn = mockArtists

        let search = "rickastley"

        let returnedArtists = try self.app.getResponse(to: "/artists/search?q=\(search)", method: .GET, decodeTo: [Artist].self)

        XCTAssertEqual(mockArtists.count, returnedArtists.count)
        XCTAssertEqual(mockArtists[0].id, returnedArtists[0].id)
        XCTAssertEqual(mockArtists[0].title, returnedArtists[0].title)
        XCTAssertEqual(mockArtists[1].id, returnedArtists[1].id)
        XCTAssertEqual(mockArtists[1].title, returnedArtists[1].title)
    }
}
