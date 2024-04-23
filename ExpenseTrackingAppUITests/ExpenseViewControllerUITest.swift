//
//  ExpenseViewControllerUITest.swift
//  ExpenseTrackingAppUITests
//
//  Created by Ravishka Dulshan on 2024-04-22.
//
import XCTest
@testable import ExpenseTrackingApp

final class ExpenseViewControllerUITest: XCTestCase {
	
	var app: XCUIApplication!
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()
	}
	
	override func tearDownWithError() throws {
		app = nil
	}
	
	func testExpenseViewControllerUI() throws {
		let totalExpensesLabel = app.staticTexts.element(matching: .any, identifier: "totalExpensesLabel")
		XCTAssertTrue(totalExpensesLabel.waitForExistence(timeout: 5))
		
		XCTAssertTrue(app.scrollViews.element.waitForExistence(timeout: 5))
	}
	
	func testExpenseRefresh() throws {
		let totalExpensesLabel = app.staticTexts.element(matching: .any, identifier: "totalExpensesLabel")
		XCTAssertTrue(totalExpensesLabel.waitForExistence(timeout: 5))
		
		let scrollView = app.scrollViews.element
		scrollView.swipeDown()
		
		XCTAssertTrue(totalExpensesLabel.waitForExistence(timeout: 5))
	}
	
}
