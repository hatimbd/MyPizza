//
//  RecipeData.swift
//  myPizza
//
//  Created by Hatim Bahand on 20/01/2025.
//

import Foundation

struct RecipeData : Codable, Hashable, Identifiable{
    var id :Int
    var name : String
    var ingredients : String
}
