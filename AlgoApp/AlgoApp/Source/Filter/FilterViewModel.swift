//
//  FilterViewModel.swift
//  AlgoApp
//
//  Created by Huong Do on 2/20/19.
//  Copyright © 2019 Huong Do. All rights reserved.
//

import Foundation
import RealmSwift
import RxCocoa
import RxSwift
import RxRealm

final class FilterViewModel {
    let allTags = BehaviorRelay<[String]>(value: [])
    let allCompanies = BehaviorRelay<[String]>(value: [])
    
    private var selectedCategories: [String] = []
    private var selectedCompanies: [String] = []
    private var selectedLevels: [String] = []
    private var selectedRemarks: [String] = []
    
    private let disposeBag = DisposeBag()
    private let realm = try! Realm()
    
    init() {
        loadTags()
        loadCompanies()
    }
    
    func updateCategory(_ category: String) {
        if let index = selectedCategories.firstIndex(of: category) {
            selectedCategories.remove(at: index)
        } else {
            selectedCategories.append(category)
        }
    }
    
    func updateCompany(_ company: String) {
        if let index = selectedCategories.firstIndex(of: company) {
            selectedCompanies.remove(at: index)
        } else {
            selectedCompanies.append(company)
        }
    }
    
    func updateLevel(_ level: String) {
        if let index = selectedLevels.firstIndex(of: level) {
            selectedLevels.remove(at: index)
        } else {
            selectedLevels.append(level)
        }
    }
    
    func updateRemark(_ remark: String) {
        if let index = selectedRemarks.firstIndex(of: remark) {
            selectedRemarks.remove(at: index)
        } else {
            selectedRemarks.append(remark)
        }
    }
    
    func buildFilter(shouldClearAll: Bool) -> QuestionFilter {
        return QuestionFilter(tags: [], companies: [], levels: [], topLiked: false, topInterviewed: false)
    }
    
    private func loadTags() {
        Observable.collection(from: realm.objects(Tag.self))
            .map { $0.map { $0.name } }
            .bind(to: allTags)
            .disposed(by: disposeBag)
    }
    
    private func loadCompanies() {
        Observable.collection(from: realm.objects(Company.self))
            .map { $0.map { $0.name } }
            .bind(to: allCompanies)
            .disposed(by: disposeBag)
    }
}
