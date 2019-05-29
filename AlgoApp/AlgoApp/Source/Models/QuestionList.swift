//
//  QuestionList.swift
//  AlgoApp
//
//  Created by Huong Do on 2/4/19.
//  Copyright © 2019 Huong Do. All rights reserved.
//

import Foundation
import RealmSwift
import IceCream

final class QuestionList: Object, IdentifiableObject, CKRecordRecoverable, CKRecordConvertible {
    
    static let savedListId = "saved-list-id"
    static let solvedListId = "solved-list-id"
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var isCustom = false
    @objc dynamic var isDeleted = false
    @objc dynamic var questionIds = ""
    
    var questions = List<Question>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var savedList: QuestionList {
        let realmManager = RealmManager.shared
        let object = realmManager.object(QuestionList.self, id: QuestionList.savedListId)
        if let object = object {
            return object
        }
        
        let newSavedList = QuestionList()
        newSavedList.id = QuestionList.savedListId
        newSavedList.name = "Saved Questions"
        newSavedList.isCustom = true
        newSavedList.questions.append(objectsIn: realmManager.objects(Question.self, filter: NSPredicate(format: "saved = true")).toArray())
        
        realmManager.create(objects: [newSavedList], update: true)
        return newSavedList
    }
    
    static var solvedList: QuestionList {
        let realmManager = RealmManager.shared
        let object = realmManager.object(QuestionList.self, id: QuestionList.solvedListId)
        if let object = object {
            return object
        }
        
        let newSolvedList = QuestionList()
        newSolvedList.id = QuestionList.solvedListId
        newSolvedList.name = "Solved Questions"
        newSolvedList.isCustom = true
        newSolvedList.questions.append(objectsIn: realmManager.objects(Question.self, filter: NSPredicate(format: "solved = true")))
        
        realmManager.create(objects: [newSolvedList], update: true)
        return newSolvedList
    }
}
