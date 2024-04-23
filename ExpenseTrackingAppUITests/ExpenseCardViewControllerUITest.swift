//
//  ExpenseCardViewControllerUITest.swift
//  ExpenseTrackingAppUITests
//
//  Created by Ravishka Dulshan on 2024-04-22.
//

import XCTest
@testable import ExpenseTrackingApp

final class ExpenseCardViewControllerUITest: XCTestCase {
	
	var app: XCUIApplication!
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()
	}
	
	override func tearDownWithError() throws {
		app = nil
	}
	
	func testExpenseCardViewUI() throws {
		let expenseTitleLabel = app.staticTexts.element(matching: .any, identifier: "expenseTitle").firstMatch
		XCTAssertTrue(expenseTitleLabel.waitForExistence(timeout: 5))
		
		let expenseAmountLabel = app.staticTexts.element(matching: .any, identifier: "expenseAmount").firstMatch
		XCTAssertTrue(expenseAmountLabel.waitForExistence(timeout: 5))
		
		let expenseCategoryLabel = app.staticTexts.element(matching: .any, identifier: "expenseCategory").firstMatch
		XCTAssertTrue(expenseCategoryLabel.waitForExistence(timeout: 5))
		
		let expenseCreatedAtLabel = app.staticTexts.element(matching: .any, identifier: "expenseCreatedAt").firstMatch
		XCTAssertTrue(expenseCreatedAtLabel.waitForExistence(timeout: 5))
	}
	
	func testExpenseCardTapping() throws {
		let expenseTitleLabel = app.staticTexts.element(matching: .any, identifier: "expenseTitle").firstMatch
		XCTAssertTrue(expenseTitleLabel.waitForExistence(timeout: 5))
		expenseTitleLabel.tap()
		
		let editButton = app.buttons["Edit"]
		XCTAssertTrue(editButton.waitForExistence(timeout: 5))
		
		let deleteButton = app.buttons["Delete"]
		XCTAssertTrue(deleteButton.waitForExistence(timeout: 5))
		
		let cancelButton = app.buttons["Cancel"]
		XCTAssertTrue(cancelButton.waitForExistence(timeout: 5))
		
		cancelButton.tap()
	}
}
