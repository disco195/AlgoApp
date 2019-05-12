//
//  QuestionFilter.swift
//  AlgoApp
//
//  Created by Huong Do on 3/10/19.
//  Copyright © 2019 Huong Do. All rights reserved.
//

import Foundation
import RealmSwift

struct QuestionFilter: Codable {
    let tags: [String]
    let companies: [String]
    let levels: [Int]
    let topLiked: Bool
    let topInterviewed: Bool
    let saved: Bool
    
    var allFilters: [String] {
        return levels.map { Question.DifficultyLevel(rawValue: $0) ?? .easy }.map { $0.title } + tags + companies + (topLiked ? ["Top Liked 👍"] : []) + (topInterviewed ? ["Top Interviewed 👩‍💻"] : [])
    }
    
    static var emptyFilter: QuestionFilter {
        return QuestionFilter(tags: [], companies: [], levels: [], topLiked: false, topInterviewed: false, saved: false)
    }
}

final class FilterObject: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var topLiked: Bool = false
    @objc dynamic var topInterviewed: Bool = false
    
    let tags = List<String>()
    let companies = List<String>()
    let levels = List<Int>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(with filter: QuestionFilter) {
        self.init()
        tags.append(objectsIn: filter.tags)
        companies.append(objectsIn: filter.companies)
        levels.append(objectsIn: filter.levels)
        topLiked = filter.topLiked
        topInterviewed = filter.topInterviewed
    }
    
    func toFilterStruct() -> QuestionFilter {
        return QuestionFilter(tags: tags.toArray(),
                              companies: companies.toArray(),
                              levels: levels.toArray(),
                              topLiked: topLiked,
                              topInterviewed: topInterviewed,
                              saved: false)
    }
}
