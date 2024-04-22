//
//  AddViewControllerUnitTest.swift
//  ExpenseTrackingAppTests
//
//  Created by Ravishka Dulshan on 2024-04-22.
//

import XCTest
@testable import ExpenseTrackingApp // Replace YourAppName with your app's module name
import CoreData

class AddViewControllerUnitTest: XCTestCase {
	
	var sut: AddViewController!
	
	override func setUpWithError() throws {
		sut = AddViewController()
		sut.loadViewIfNeeded()
	}
	
	override func tearDownWithError() throws {
		sut = nil
	}
	
	func testAmountButtonTapped() throws {
		// Given
		sut.amountTextField.text = "10.00"
		
		// When
		sut.amountButtonTapped(sut.increaseButton)
		
		// Then
		XCTAssertEqual(sut.amountTextField.text, "11.00")
		
		// When
		sut.amountButtonTapped(sut.decreaseButton)
		
		// Then
		XCTAssertEqual(sut.amountTextField.text, "10.00")
		
		// When
		sut.amountButtonTapped(sut.decreaseButton)
		
		// Then
		XCTAssertEqual(sut.amountTextField.text, "9.00")
		
		// When
		sut.amountTextField.text = "-5.00"
		sut.amountButtonTapped(sut.decreaseButton)
		
		// Then
		XCTAssertEqual(sut.amountTextField.text, "0.00")
	}
	
	func testCategoryPickerDone() throws {
		// When
		sut.categoryPickerDone()
		
		// Then
		XCTAssertEqual(sut.categoryTextField.text, "Grocery")
	}
	
	func testDatePickerDone() throws {
		// When
		sut.datePickerDone()
		
		// Then
		XCTAssertFalse(sut.createdAtTextField.text?.isEmpty ?? true)
	}
	
	func testClearTextFields() throws {
		// Given
		sut.titleTextField.text = "Test Title"
		sut.subtitleTextField.text = "Test Subtitle"
		sut.amountTextField.text = "100.00"
		sut.categoryTextField.text = "Test Category"
		sut.createdAtTextField.text = "Test Date"
		
		// When
		sut.clearTextFields()
		
		// Then
		XCTAssertTrue(sut.titleTextField.text?.isEmpty ?? false)
		XCTAssertTrue(sut.subtitleTextField.text?.isEmpty ?? false)
		XCTAssertTrue(sut.amountTextField.text?.isEmpty ?? false)
		XCTAssertTrue(sut.categoryTextField.text?.isEmpty ?? false)
		XCTAssertTrue(sut.createdAtTextField.text?.isEmpty ?? false)
	}
}

