@testable import App
import FluentPostgreSQL
@testable import Vapor
import XCTest

class UserTests: XCTestCase {

    var app: Application!
    var connection: PostgreSQLConnection!
    var request: Request!

    override func setUp() {
        do {
            try Application.reset()
            self.app = try Application.testable()
            self.connection = try self.app.newConnection(to: .psql).wait()
        }
        catch {
            fatalError(error.localizedDescription)
        }

        self.request = Request(using: self.app)
    }

    override func tearDown() {
        self.connection?.close()
        try? app.syncShutdownGracefully()
    }

    func testCreateUser() throws {
        let newUser = User(name: "Tony")
        let user = try self.app.getResponse(to: "/users", method: .POST, data: newUser, decodeTo: User.self)

        XCTAssertTrue(user.id != nil)
        XCTAssertEqual(user.name, "Tony")
    }

    func testGetUser() throws {
        let newUser = User(name: "Bruce")
        let user = try self.app.getResponse(to: "/users", method: .POST, data: newUser, decodeTo: User.self)

        let userID = try user.requireID()
        let updatedUser = try self.app.getResponse(to: "/users/\(userID)", decodeTo: User.self)

        XCTAssertEqual(updatedUser.id, userID)
        XCTAssertEqual(updatedUser.name, "Bruce")
    }

    func testUpdateUser() throws {
        let newUser = User(name: "Peter")
        let user = try self.app.getResponse(to: "/users", method: .POST, data: newUser, decodeTo: User.self)

        XCTAssertTrue(user.id != nil)
        XCTAssertEqual(user.name, "Peter")

        user.name = "Carol"

        let userID = try user.requireID()
        let updatedUser = try self.app.getResponse(to: "/users/\(userID)", method: .PUT, data: user, decodeTo: User.self)

        XCTAssertEqual(updatedUser.id, userID)
        XCTAssertEqual(updatedUser.name, "Carol")
    }

    func testDeleteUser() throws {
        let newUser = User(name: "Thor")
        let user = try self.app.getResponse(to: "/users", method: .POST, data: newUser, decodeTo: User.self)

        let userID = try user.requireID()
        let retrievedUser = try self.app.getResponse(to: "/users/\(userID)", decodeTo: User.self)

        XCTAssertEqual(retrievedUser.id, userID)

        let deleteResponse = try self.app.sendRequest(to: "/users/\(userID)", method: .DELETE)
        XCTAssertEqual(deleteResponse.http.status, .noContent)

        let notFoundResponse = try self.app.sendRequest(to: "/users/\(userID)", method: .GET)
        XCTAssertEqual(notFoundResponse.http.status, .notFound)
    }
}
