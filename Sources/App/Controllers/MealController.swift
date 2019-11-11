//
//  MealController.swift
//  App
//
//  Created by Siarhei Suliukou on 11/10/19.
//

import Foundation
import Vapor

final class MealController {
    func index(_ req: Request) throws -> Future<[Meal]> {
        return Meal.query(on: req).all()
    }
    
    func create(_ req: Request) throws -> Future<Meal> {
        return try req.content.decode(Meal.self).flatMap({ meal in
            return meal.save(on: req)
        })
    }
}
