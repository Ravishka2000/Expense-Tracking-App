//
//  ExpenseTrackingAppTests.swift
//  ExpenseTrackingAppTests
//
//  Created by Ravishka Dulshan on 2024-04-06.
//

import XCTest
@testable import ExpenseTrackingApp
import CoreData

final class ExpenseTrackingAppTests: XCTestCase {
	
	var expenseViewController: ExpenseViewController!
	var expenseCardView: ExpenseCardView!
	var addViewController: AddViewController!
	
	override func setUpWithError() throws {
		expenseViewController = ExpenseViewController()
		expenseViewController.loadViewIfNeeded()
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let managedObjectContext = appDelegate.persistentContainer.viewContext
		
		let mockExpense = Expense(context: managedObjectContext)
		mockExpense.title = "Mock Expense"
		mockExpense.amount = 100.0
		mockExpense.category = "Mock Category"
		mockExpense.createdAt = Date()
		
		expenseCardView = ExpenseCardView(expense: mockExpense, parentViewController: UIViewController())
		expenseCardView.layoutIfNeeded()
		
		addViewController = AddViewController()
		addViewController.loadViewIfNeeded()
	}
	
	override func tearDownWithError() throws {
		expenseViewController = nil
		expenseCardView = nil
		addViewController = nil
	}
	
	func testExpenseViewController_WhenLoaded_SummaryLabelIsDisplayed() throws {
		XCTAssertNotNil(expenseViewController.summaryLabel)
	}
	
	func testExpenseViewController_WhenLoaded_StackViewIsDisplayed() throws {
		XCTAssertNotNil(expenseViewController.stackView)
	}
	
	func testExpenseViewController_WhenLoaded_ScrollViewIsDisplayed() throws {
		XCTAssertNotNil(expenseViewController.scrollView)
	}
	
	
	func testExpenseCardView_WhenLoaded_TitleLabelIsDisplayed() throws {
		XCTAssertNotNil(expenseCardView.titleLabel)
	}
	
	func testExpenseCardView_WhenLoaded_AmountLabelIsDisplayed() throws {
		XCTAssertNotNil(expenseCardView.amountLabel)
	}
	
	func testExpenseCardView_WhenLoaded_CategoryLabelIsDisplayed() throws {
		XCTAssertNotNil(expenseCardView.categoryLabel)
	}
	
	
	func testAddViewController_WhenLoaded_TitleLabelIsDisplayed() throws {
		XCTAssertNotNil(addViewController.titleLabel)
	}
	
	func testAddViewController_WhenLoaded_TitleTextFieldIsDisplayed() throws {
		XCTAssertNotNil(addViewController.titleTextField)
	}
	

}
