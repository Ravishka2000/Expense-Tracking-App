//
//  ExpenseTrackingAppUITests.swift
//  ExpenseTrackingAppUITests
//
//  Created by Ravishka Dulshan on 2024-04-06.
//

import XCTest
@testable import ExpenseTrackingApp

final class ExpenseTrackingAppUITests: XCTestCase {
	
	var app: XCUIApplication!
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()
	}
	
	func testExpenseCardView_EditButtonAction() throws {
		let editButton = app.buttons["Edit"]
		XCTAssertTrue(editButton.exists)
		
		// Tap on the edit button
		editButton.tap()
		
		// Verify that the edit alert is displayed
		XCTAssertTrue(app.alerts["Edit Expense"].exists)
	}
	
	func testExpenseCardView_DeleteButtonAction() throws {
		let deleteButton = app.buttons["Delete"]
		XCTAssertTrue(deleteButton.exists)
		
		// Tap on the delete button
		deleteButton.tap()
		
		// Verify that the delete action removes the expense card view
		XCTAssertFalse(deleteButton.exists)
	}
	
	func testSavingExpense() throws {
		// Navigate to the Add View Controller
		app.buttons["Add"].tap()
		
		// Fill in the expense details
		app.textFields["Title"].tap()
		app.textFields["Title"].typeText("Test Expense")
		
		app.textFields["Amount"].tap()
		app.textFields["Amount"].typeText("100")
		
		app.textFields["Category"].tap()
		app.textFields["Category"].typeText("Test Category")
		
		app.textFields["Created At"].tap()
		app.textFields["Created At"].typeText("April 11, 2024 10:00 AM")
		
		// Save the expense
		app.buttons["Save"].tap()
		
		// Verify that the expense is saved
		XCTAssertTrue(app.staticTexts["Expense saved successfully."].exists)
	}
}
