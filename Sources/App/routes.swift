import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Basic "Hello Universe" example
    router.get { req in
        return "Hello Universe"
    }

    // Example of configuring a controller
    let userController = UserController()
    router.post("users", use: userController.create)
    router.get("users", User.parameter, use: userController.find)
    router.get("users", use: userController.index)
    router.put("users", User.parameter, use: userController.update)
    router.delete("users", User.parameter, use: userController.delete)
}
