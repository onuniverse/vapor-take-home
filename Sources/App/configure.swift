import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    // This extension registers any environment variables in .env with the application
    Environment.dotenv()
    
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    services.register(DiscogService(), as: ArtistService.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure a PostgreSQL database
    let postgresql = PostgreSQLDatabase(config: try env.databaseConfig())

    /// Register the configured PostgreSQL database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: postgresql, as: .psql)
    services.register(databases)

    let poolConfig = DatabaseConnectionPoolConfig(maxConnections: 2)
    services.register(poolConfig)

    // Register the configured SQLite database to the database config.

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Playlist.self, database: .psql)
    migrations.add(model: Release.self, database: .psql)
    migrations.add(model: PlaylistRelease.self, database: .psql)
    services.register(migrations)
    
    // Currently this is needed for `revert`ing environment in unit tests
    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
}
