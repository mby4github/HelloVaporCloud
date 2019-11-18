import FluentPostgreSQL
import Vapor

public struct PostgresDefaults {
    public static let hostname = "localhost"
    public static let username = "siarheisuliukou"
    public static let database = "foodtracker"
    public static let port = 5432
}

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    //let config = PostgreSQLDatabaseConfig(hostname: "localhost", port: 5432, username: "siarheisuliukou", database: "foodtracker", password: nil, transport: .cleartext)
    //let config = PostgreSQLDatabaseConfig(hostname: "ec2-54-75-245-196.eu-west-1.compute.amazonaws.com", port: 5432, username: "edamsbhmjmcwrq", database: "dbcc2mk522jklo", password: "9d70e78324a22dbc32a4d370110c4d6135124d25a277373068b7495ba5ca7fc9", transport: .cleartext)
    let postgreSQLConfig : PostgreSQLDatabaseConfig
    
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? PostgresDefaults.hostname
    let username = Environment.get("DATABASE_USERNAME") ?? PostgresDefaults.username
    let database = Environment.get("DATABASE_DATABASE") ?? PostgresDefaults.database
    let password = Environment.get("DATABASE_PASSWORD")
    
    let port : Int
    
    if let portString = Environment.get("DATABASE_PORT") {
        port = Int(portString) ?? PostgresDefaults.port
    } else {
        port = PostgresDefaults.port
    }
    
    postgreSQLConfig = PostgreSQLDatabaseConfig(hostname: hostname, port: port, username: username, database: database, password: password, transport: .cleartext)
    
    let postgres = PostgreSQLDatabase(config: postgreSQLConfig)
    
    var databases = DatabasesConfig()
    databases.add(database: postgres, as: .psql)
    services.register(databases)
    
    var migrations = MigrationConfig()
    migrations.add(model: Meal.self, database: .psql)
    services.register(migrations)
}
