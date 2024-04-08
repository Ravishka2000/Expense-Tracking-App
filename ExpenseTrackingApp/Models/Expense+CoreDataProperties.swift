//
//  Expense+CoreDataProperties.swift
//  ExpenseTrackingApp
//
//  Created by Ravishka Dulshan on 2024-04-08.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?

}

extension Expense : Identifiable {

}
