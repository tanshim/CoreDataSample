//
//  DetailPresenter.swift
//  CoreDataSample
//
//  Created by Sultan on 29.09.2023.
//

import Foundation
import CoreData
import UIKit

class DetailPresenter {

    private let coreDataService = CoreDataService()
    weak private var detailViewDelegate: DetailViewDelegate?

    func setViewDelegate(detailViewDelegate: DetailViewDelegate?) {
        self.detailViewDelegate = detailViewDelegate
    }

    func updatePerson(name: String?, date: String?, gender: String?) {
        guard let managedContext = coreDataService.managedContext else { return }
        detailViewDelegate?.person?.setValue(name, forKeyPath: "name")
        detailViewDelegate?.person?.setValue(gender, forKeyPath: "gender")
        if let validDate = convertStringToDate(strDate: date) {
            detailViewDelegate?.person?.setValue(validDate, forKeyPath: "dateOfBirth")
        } else {
            detailViewDelegate?.person?.setValue(nil, forKeyPath: "dateOfBirth")
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            detailViewDelegate?.showUIAlert(message: "Could not save. \(error), \(error.userInfo)")
        }
    }

    func convertDateToString(date: Date?) -> String? {
        if let date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d.MM.y"
            let stringDate = dateFormatter.string(from: date)
            return stringDate
        }
        return nil
    }

    func convertStringToDate(strDate: String?) -> Date? {
        if let strDate = strDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d.MM.y"
            let date = dateFormatter.date(from: strDate)
            return date
        }
        return nil
    }

}
