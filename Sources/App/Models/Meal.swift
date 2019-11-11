//
//  Meal.swift
//  App
//
//  Created by Siarhei Suliukou on 11/6/19.
//

import Foundation
import FluentPostgreSQL
import Vapor

final class Meal: PostgreSQLModel {
    var id: Int?
    var description: String
    
    init(description: String) {
        self.description = description
    }
}

// Allows `Meal` to be used as a dynamic migration.
extension Meal: Migration { }
/// Allows `Meal` to be encoded to and decoded from HTTP messages.
extension Meal: Content { }
/// Allows `Meal` to be used as a dynamic parameter in route definitions.
extension Meal: Parameter { }
