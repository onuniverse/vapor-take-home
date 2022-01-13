import Vapor

/// Controls basic CRUD operations on `User`s.
final class UserController {
    /// Saves a decoded `User` to the database.
    func create(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
    }

    /// Returns a list of all `User`s.
    func index(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }

    /// Finds a parameterized `User`.
    func find(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self).flatMap { user in
            return req.future(user)
        }
    }

    /// Updates a parameterized `User`.
    func update(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self).flatMap({ user -> EventLoopFuture<User> in
            return try req.content.decode(User.self).flatMap { updatedUser -> EventLoopFuture<User> in
                user.name = updatedUser.name
                return user.update(on: req)
            }
        })
    }

    /// Deletes a parameterized `User`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap { user in
            return user.delete(on: req)
        }.transform(to: .noContent)
    }
}
