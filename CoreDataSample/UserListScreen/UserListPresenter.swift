//
//  UserListPresenter.swift
//  CoreDataSample
//
//  Created by Sultan on 28.09.2023.
//

import Foundation
import CoreData
import UIKit

class UserListPresenter {

    private let coreDataService = CoreDataService()
    weak private var userListViewDelegate: UserListViewDelegate?

    func setViewDelegate(userListViewDelegate: UserListViewDelegate?) {
        self.userListViewDelegate = userListViewDelegate
    }

    func fetchPersons() {
        guard let managedContext = coreDataService.managedContext else { return }
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            userListViewDelegate?.people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            userListViewDelegate?.showUIAlert(message: "Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func savePerson(name: String) {
        guard let managedContext = coreDataService.managedContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: "Person",
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        do {
            try managedContext.save()
            userListViewDelegate?.people.append(person)
        } catch let error as NSError {
            userListViewDelegate?.showUIAlert(message: "Could not save. \(error), \(error.userInfo)")
        }
    }

    func deletePerson(person: NSManagedObject) {
        guard let managedContext = coreDataService.managedContext else { return }
        managedContext.delete(person)
        do {
            try managedContext.save()
        } catch let error as NSError {
            userListViewDelegate?.showUIAlert(message: "Delete error. \(error), \(error.userInfo)")
        }
    }
    
}
