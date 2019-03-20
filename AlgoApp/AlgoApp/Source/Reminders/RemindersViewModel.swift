//
//  RemindersViewModel.swift
//  AlgoApp
//
//  Created by Huong Do on 3/10/19.
//  Copyright © 2019 Huong Do. All rights reserved.
//

import Foundation
import RealmSwift
import RxCocoa
import RxRealm
import RxSwift

final class RemindersViewModel {
    let reminders = BehaviorRelay<[ReminderDetail]>(value: [])
    
    private let disposeBag = DisposeBag()
    private lazy var realm = try! Realm()
    
    func loadReminders() {
        Observable.collection(from: realm.objects(Reminder.self))
            .map { Array($0).map { ReminderDetail(with: $0) } }
            .bind(to: reminders)
            .disposed(by: disposeBag)
    }
    
    func toggleReminder(id: String) {
        let realm = try! Realm()
        guard let reminder = realm.object(ofType: Reminder.self, forPrimaryKey: id) else { return }
        try! realm.write {
            reminder.enabled = !reminder.enabled
            NotificationHelper.shared.updateScheduledNotifications(for: ReminderDetail(with: reminder))
        }
    }
}
