//
//  AddViewController.swift
//  ExpenseTrackingApp
//
//  Created by Ravishka Dulshan on 2024-04-06.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
	
	var titleLabel: UILabel!
	var titleTextField: UITextField!
	var subtitleLabel: UILabel!
	var subtitleTextField: UITextField!
	var amountLabel: UILabel!
	var amountTextField: UITextField!
	var categoryLabel: UILabel!
	var categoryTextField: UITextField!
	var createdAtLabel: UILabel!
	var createdAtTextField: UITextField!
	var saveButton: UIButton!
	var datePicker: UIDatePicker!
	var datePickerToolbar: UIToolbar!
	
	// Core Data context
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	// Date formatter
	let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .medium
		return formatter
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	func setupUI() {
		title = "Add Expense"		
		view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
		
		titleLabel = UILabel()
		configureLabel(titleLabel, withText: "Title")
		titleTextField = createTextField()
		
		subtitleLabel = UILabel()
		configureLabel(subtitleLabel, withText: "Subtitle")
		subtitleTextField = createTextField()
		
		amountLabel = UILabel()
		configureLabel(amountLabel, withText: "Amount")
		amountTextField = createTextField()
		amountTextField.keyboardType = .decimalPad
		
		categoryLabel = UILabel()
		configureLabel(categoryLabel, withText: "Category")
		categoryTextField = createTextField()
		
		createdAtLabel = UILabel()
		configureLabel(createdAtLabel, withText: "Created At")
		createdAtTextField = createTextField()
		
		saveButton = UIButton(type: .system)
		saveButton.setTitle("Save", for: .normal)
		saveButton.setTitleColor(.white, for: .normal)
		saveButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
		saveButton.layer.cornerRadius = 5
		saveButton.addTarget(self, action: #selector(saveExpense), for: .touchUpInside)
		
		let stackView = UIStackView(arrangedSubviews: [titleLabel, titleTextField, subtitleLabel, subtitleTextField, amountLabel, amountTextField, categoryLabel, categoryTextField, createdAtLabel, createdAtTextField, saveButton])
		stackView.axis = .vertical
		stackView.spacing = 20
		stackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
			stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
			stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
		])
		
		// Set up toolbar for date picker
		datePickerToolbar = UIToolbar()
		datePickerToolbar.barStyle = .default
		datePickerToolbar.sizeToFit()
		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(datePickerDoneButtonPressed))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		datePickerToolbar.setItems([spaceButton, doneButton], animated: false)
		
		// Set up date picker
		datePicker = UIDatePicker()
		datePicker.datePickerMode = .dateAndTime
		datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
		
		// Assign date picker and its toolbar to the text field
		createdAtTextField.inputView = datePicker
		createdAtTextField.inputAccessoryView = datePickerToolbar
	}
	
	func configureLabel(_ label: UILabel, withText text: String) {
		label.text = text
		label.textColor = .darkGray
		label.font = UIFont.boldSystemFont(ofSize: 16)
	}
	
	func createTextField() -> UITextField {
		let textField = UITextField()
		textField.borderStyle = .roundedRect
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.font = UIFont.systemFont(ofSize: 16)
		textField.backgroundColor = .white
		return textField
	}
	
	@objc func datePickerValueChanged(sender: UIDatePicker) {
		let formattedDate = dateFormatter.string(from: sender.date)
		createdAtTextField.text = formattedDate
	}
	
	@objc func datePickerDoneButtonPressed() {
		createdAtTextField.resignFirstResponder()
	}
	
	@objc func saveExpense() {
		guard let title = titleTextField.text, !title.isEmpty,
			  let subtitle = subtitleTextField.text, !subtitle.isEmpty,
			  let amountString = amountTextField.text, let amount = Double(amountString),
			  let category = categoryTextField.text, !category.isEmpty,
			  let createdAtString = createdAtTextField.text,
			  let createdAt = dateFormatter.date(from: createdAtString) else {
			showAlert(message: "Please fill in all fields.")
			return
		}
		
		let newExpense = Expense(context: context)
		newExpense.title = title
		newExpense.subtitle = subtitle
		newExpense.amount = amount
		newExpense.category = category
		newExpense.createdAt = createdAt
		
		do {
			try context.save()
			showAlert(message: "Expense saved successfully.")
			clearTextFields() // Clear text fields after successful save
		} catch {
			showAlert(message: "Failed to save expense.")
		}
	}
	
	private func clearTextFields() {
		titleTextField.text = ""
		subtitleTextField.text = ""
		amountTextField.text = ""
		categoryTextField.text = ""
		createdAtTextField.text = ""
	}
	
	private func showAlert(message: String) {
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}
}
