//
//  CodeViewModel.swift
//  AlgoApp
//
//  Created by Huong Do on 2/24/19.
//  Copyright © 2019 Huong Do. All rights reserved.
//

import Foundation
import Highlightr
import RxCocoa
import RxSwift

enum Language: String, CaseIterable {
    case c = "C"
    case cSharp = "C#"
    case cPP = "C++"
    case go = "Go"
    case java = "Java"
    case javascript = "Javascript"
    case markdown = "Markdown"
    case objc = "Objective-C"
    case php = "PHP"
    case python = "Python"
    case ruby = "Ruby"
    case swift = "Swift"
    
    var rawLanguageName: String {
        switch self {
        case .objc:
            return "objectivec"
        case .cSharp:
            return "cs"
        default:
            return self.rawValue.lowercased()
        }
    }
}

final class CodeViewModel {
    
    var attributedContent: NSAttributedString? {
        return highlighter?.highlight(content, as: language.value.rawLanguageName, fastRender: true)
    }
    
    var languageList: [Language] {
        return Language.allCases
    }
    
    let layoutManager = BehaviorRelay<NSLayoutManager?>(value: nil)
    
    let language = BehaviorRelay<Language>(value: .markdown)
    let readOnly: Bool
    
    var content: String
    private let highlighter: Highlightr?
    private let disposeBag = DisposeBag()
    
    init(content: String, language: Language, readOnly: Bool) {
        self.content = content
        self.readOnly = readOnly
        
        self.language.accept(language)
        
        highlighter = Highlightr()
        highlighter?.setTheme(to: "tomorrow")
        
        self.language
            .map { [weak self] language -> NSLayoutManager? in
                guard let highlighter = self?.highlighter else { return nil }
                
                let textStorage = CodeAttributedString(highlightr: highlighter)
                textStorage.language = language.rawLanguageName
                let layoutManager = NSLayoutManager()
                textStorage.addLayoutManager(layoutManager)
                
                return layoutManager
            }
            .bind(to: layoutManager)
            .disposed(by: disposeBag)
    }
}
