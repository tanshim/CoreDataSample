//
//  CoreDataService.swift
//  CoreDataSample
//
//  Created by Sultan on 28.09.2023.
//

import Foundation
import CoreData
import UIKit

struct CoreDataService {
    var managedContext: NSManagedObjectContext? {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }
}
