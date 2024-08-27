//
//  Credit.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/25/24.
//

import Foundation

struct Credit {
    let id: Int
    let casts: [Cast]
    let crews: [Crew]
}

struct Cast: Credits {
    var id: Int
    var adult: Bool
    var gender: Int
    var name: String
    var popularity: Double
    var profilePath: String?
    var knownForDepartment: String
    var creditId: String
    var castId: Int
    var character: String
}

struct Crew: Credits {
    var id: Int
    var adult: Bool
    var gender: Int
    var name: String
    var popularity: Double
    var profilePath: String?
    var knownForDepartment: String
    var creditId: String
    var department: String
    var job: String
}

protocol Credits {
    var id: Int { get }
    var adult: Bool { get }
    var gender: Int { get }
    var name: String { get }
    var popularity: Double { get }
    var profilePath: String? { get }
    var knownForDepartment: String { get }
    var creditId: String { get }
}
