//
//  CreditResponseDTO.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/25/24.
//

import Foundation

struct CreditResponse: Decodable {
    let id: Int
    let cast: [CastResponse]
    let crew: [CrewResponse]
    
    enum CodingKeys: CodingKey {
        case id, cast, crew
    }
}

struct CastResponse: Decodable {
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
    
    enum CodingKeys: String, CodingKey {
        case id, adult, gender, name, popularity, character
        case profilePath = "profile_path"
        case knownForDepartment = "known_for_department"
        case creditId = "credit_id"
        case castId = "cast_id"
    }
}

struct CrewResponse: Decodable {
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
    
    enum CodingKeys: String, CodingKey {
        case id, adult, gender, name, popularity, department, job
        case profilePath = "profile_path"
        case knownForDepartment = "known_for_department"
        case creditId = "credit_id"
    }
}

extension CreditResponse {
    func toCredit() -> Credit {
        return Credit(
            id: self.id,
            casts: self.toCasts(),
            crews: self.toCrews()
        )
    }
    
    func toCasts() -> [Cast] {
        return self.cast.compactMap { $0.toCast() }
    }
    
    func toCrews() -> [Crew] {
        return self.crew.compactMap { $0.toCrew() }
    }
}

extension CastResponse {
    func toCast() -> Cast {
        return Cast(
            id: self.id,
            adult: self.adult,
            gender: self.gender,
            name: self.name,
            popularity: self.popularity,
            profilePath: self.profilePath,
            knownForDepartment: self.knownForDepartment,
            creditId: self.creditId,
            castId: self.castId,
            character: self.character
        )
    }
}

extension CrewResponse {
    func toCrew() -> Crew {
        return Crew(
            id: self.id,
            adult: self.adult,
            gender: self.gender,
            name: self.name,
            popularity: self.popularity,
            profilePath: self.profilePath,
            knownForDepartment: self.knownForDepartment,
            creditId: self.creditId,
            department: self.department,
            job: self.job
        )
    }
}
