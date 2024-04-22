//
//  AddViewControllerUITest.swift
//  ExpenseTrackingAppUITests
//
//  Created by Ravishka Dulshan on 2024-04-22.
//

import XCTest
@testable import ExpenseTrackingApp

final class AddViewControllerUITest: XCTestCase {
	
	var app: XCUIApplication!
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()
	}
	
	override func tearDownWithError() throws {
	}
	
	func testNavigateToAddExpense() throws {
		let tabBar = app.tabBars["Tab Bar"]
		tabBar.buttons["Add"].tap()
		
		XCTAssertTrue(app.staticTexts["Title"].exists)
		XCTAssertTrue(app.textFields["TitleTextField"].exists)
		
		XCTAssertTrue(app.staticTexts["Subtitle"].exists)
		XCTAssertTrue(app.textFields["SubtitleTextField"].exists)
		
		XCTAssertTrue(app.staticTexts["Amount"].exists)
		XCTAssertTrue(app.textFields["AmountTextField"].exists)
		
		XCTAssertTrue(app.buttons["IncreaseButton"].exists)
		XCTAssertTrue(app.buttons["DecreaseButton"].exists)
		
		XCTAssertTrue(app.staticTexts["Category"].exists)
		XCTAssertTrue(app.textFields["CategoryTextField"].exists)
		
		XCTAssertTrue(app.staticTexts["Created At"].exists)
		XCTAssertTrue(app.textFields["CreatedAtTextField"].exists)
		
		XCTAssertTrue(app.buttons["SaveButton"].exists)
	}
	
	func testSaveExpense() throws {
		let tabBar = app.tabBars["Tab Bar"]
		tabBar.buttons["Add"].tap()
		
		let titleTextField = app.textFields["TitleTextField"]
		titleTextField.tap()
		titleTextField.typeText("Test Title")
		
		let subtitleTextField = app.textFields["SubtitleTextField"]
		subtitleTextField.tap()
		subtitleTextField.typeText("Test Subtitle")
		
		let amountTextField = app.textFields["AmountTextField"]
		amountTextField.tap()
		amountTextField.typeText("100")
		
		let categoryTextField = app.textFields["CategoryTextField"]
		categoryTextField.tap()
		app.toolbars["Toolbar"].buttons["Done"].tap()
		
		let createdAtTextField = app.textFields["CreatedAtTextField"]
		createdAtTextField.tap()
		app.toolbars["Toolbar"].buttons["Done"].tap()
		
		let saveButton = app.buttons["SaveButton"]
		saveButton.tap()
		
		XCTAssertTrue(app.alerts["Success"].exists)
	}

	
	func testIncreaseDecreaseAmount() throws {
		let tabBar = app.tabBars["Tab Bar"]
		tabBar.buttons["Add"].tap()
		
		let amountTextField = app.textFields["AmountTextField"]
		let increaseButton = app.buttons["IncreaseButton"]
		let decreaseButton = app.buttons["DecreaseButton"]
		
		amountTextField.tap()
		amountTextField.typeText("0")
		
		let initialAmount = Double(amountTextField.value as! String) ?? 0.00
		increaseButton.tap()
		XCTAssertEqual(amountTextField.value as! String, String(format: "%.2f", initialAmount + 1))
		
		decreaseButton.tap()
		XCTAssertEqual(amountTextField.value as! String, String(format: "%.2f", initialAmount))
	}

}
