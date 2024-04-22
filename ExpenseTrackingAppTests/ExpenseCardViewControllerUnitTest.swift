//
//  ExpenseCardViewControllerUnitTest.swift
//  ExpenseTrackingAppTests
//
//  Created by Ravishka Dulshan on 2024-04-22.
//

import XCTest
@testable import ExpenseTrackingApp
import CoreData

class ExpenseCardViewControllerUnitTest: XCTestCase {
	
	var expense: Expense!
	var parentViewController: UIViewController!
	var cardView: ExpenseCardView!
	var context: NSManagedObjectContext!
	
	override func setUpWithError() throws {
		let container = NSPersistentContainer(name: "ExpenseTrackingApp") 
		container.loadPersistentStores { (_, error) in
			if let error = error {
				fatalError("Failed to load store: \(error)")
			}
		}
		context = container.viewContext
		
		expense = Expense(context: context)
		expense.title = "Test Expense"
		expense.amount = 100.0
		expense.category = "Test Category"
		expense.createdAt = Date()
		
		parentViewController = UIViewController()
		
		cardView = ExpenseCardView(expense: expense, parentViewController: parentViewController)
	}
	
	override func tearDownWithError() throws {
		expense = nil
		parentViewController = nil
		cardView = nil
		context = nil
	}
	
	func testUpdateUI() throws {
		cardView.updateUI()
		XCTAssertEqual(cardView.titleLabel.text, "Test Expense")
		XCTAssertEqual(cardView.amountLabel.text, "$100.00")
		XCTAssertEqual(cardView.categoryLabel.text, "Test Category")
	}
	
	func testUpdateCategoryBadge() throws {
		cardView.updateCategoryBadge("Grocery")
		XCTAssertEqual(cardView.categoryLabel.backgroundColor, UIColor(red: 0.2706, green: 0.098, blue: 0.3216, alpha: 1.0))
		
		cardView.updateCategoryBadge("Electronics")
		XCTAssertEqual(cardView.categoryLabel.backgroundColor, UIColor(red: 0.9529, green: 0.6235, blue: 0.3529, alpha: 1.0))
		
		cardView.updateCategoryBadge("Foods")
		XCTAssertEqual(cardView.categoryLabel.backgroundColor, UIColor(red: 0.6824, green: 0.2667, blue: 0.3529, alpha: 1.0))
		
		cardView.updateCategoryBadge(nil)
		XCTAssertEqual(cardView.categoryLabel.backgroundColor, UIColor(red: 0.3608, green: 0.2745, blue: 0.6118, alpha: 1.0))
	}
	
	func testDeleteExpense() throws {
		cardView.deleteExpense()
		
		let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
		let expenses = try context.fetch(fetchRequest)
		XCTAssertEqual(expenses.count, 3)
	}
}
