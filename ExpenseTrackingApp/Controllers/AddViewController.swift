//
//  AddViewController.swift
//  ExpenseTrackingApp
//
//  Created by Ravishka Dulshan on 2024-04-06.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
	
	public var titleLabel: UILabel!
	public var titleTextField: UITextField!
	public var subtitleLabel: UILabel!
	public var subtitleTextField: UITextField!
	public var amountLabel: UILabel!
	public var amountTextField: UITextField!
	public var increaseButton: UIButton!
	public var decreaseButton: UIButton!
	public var categoryLabel: UILabel!
	public var categoryTextField: UITextField!
	public var createdAtLabel: UILabel!
	public var createdAtTextField: UITextField!
	public var saveButton: UIButton!
	
	public var categoryPicker: UIPickerView!
	public var datePicker: UIDatePicker!
	
	public let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	public let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter
	}()
	
	public let categories = ["Grocery", "Electronics", "Foods", "Others"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	public func setupUI() {
		title = "Add Expense"
		view.backgroundColor = .systemGray6
		
		titleLabel = createLabel(withText: "Title")
		titleTextField = createTextField()
		titleTextField.accessibilityIdentifier = "TitleTextField" // Set accessibility identifier
		
		subtitleLabel = createLabel(withText: "Subtitle")
		subtitleTextField = createTextField()
		subtitleTextField.accessibilityIdentifier = "SubtitleTextField" // Set accessibility identifier
		
		amountLabel = createLabel(withText: "Amount")
		amountTextField = createTextField()
		amountTextField.accessibilityIdentifier = "AmountTextField" // Set accessibility identifier
		amountTextField.keyboardType = .decimalPad
		
		increaseButton = createButton(withTitle: "+")
		increaseButton.accessibilityIdentifier = "IncreaseButton" // Set accessibility identifier
		decreaseButton = createButton(withTitle: "-")
		decreaseButton.accessibilityIdentifier = "DecreaseButton" // Set accessibility identifier
		let amountStackView = UIStackView(arrangedSubviews: [decreaseButton, amountTextField, increaseButton])
		amountStackView.axis = .horizontal
		amountStackView.spacing = 8
		
		categoryLabel = createLabel(withText: "Category")
		categoryPicker = UIPickerView()
		categoryPicker.dataSource = self
		categoryPicker.delegate = self
		categoryTextField = createTextField()
		categoryTextField.accessibilityIdentifier = "CategoryTextField" // Set accessibility identifier
		categoryTextField.inputView = categoryPicker
		
		createdAtLabel = createLabel(withText: "Created At")
		datePicker = UIDatePicker()
		datePicker.datePickerMode = .date
		datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
		createdAtTextField = createTextField()
		createdAtTextField.accessibilityIdentifier = "CreatedAtTextField" // Set accessibility identifier
		createdAtTextField.inputView = datePicker
		
		saveButton = UIButton(type: .system)
		saveButton.setTitle("Save", for: .normal)
		saveButton.setTitleColor(.white, for: .normal)
		saveButton.backgroundColor = UIColor(red: 0, green: 0.6784, blue: 0.7098, alpha: 1.0)
		saveButton.layer.cornerRadius = 5
		saveButton.addTarget(self, action: #selector(saveExpense), for: .touchUpInside)
		saveButton.accessibilityIdentifier = "SaveButton" // Set accessibility identifier
		
		let categoryToolbar = UIToolbar()
		categoryToolbar.barStyle = .default
		categoryToolbar.isTranslucent = true
		categoryToolbar.sizeToFit()
		let categoryDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(categoryPickerDone))
		categoryToolbar.setItems([categoryDoneButton], animated: false)
		categoryToolbar.isUserInteractionEnabled = true
		categoryTextField.inputAccessoryView = categoryToolbar
		
		let dateToolbar = UIToolbar()
		dateToolbar.barStyle = .default
		dateToolbar.isTranslucent = true
		dateToolbar.sizeToFit()
		let dateDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(datePickerDone))
		dateToolbar.setItems([dateDoneButton], animated: false)
		dateToolbar.isUserInteractionEnabled = true
		createdAtTextField.inputAccessoryView = dateToolbar
		
		let stackView = UIStackView(arrangedSubviews: [titleLabel, titleTextField, subtitleLabel, subtitleTextField, amountLabel, amountStackView, categoryLabel, categoryTextField, createdAtLabel, createdAtTextField, saveButton])
		stackView.axis = .vertical
		stackView.spacing = 20
		stackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
			stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
			stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
		])
	}

	
	public func createLabel(withText text: String) -> UILabel {
		let label = UILabel()
		label.text = text
		label.textColor = .darkGray
		label.font = UIFont.boldSystemFont(ofSize: 16)
		return label
	}
	
	public func createTextField() -> UITextField {
		let textField = UITextField()
		textField.borderStyle = .roundedRect
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.font = UIFont.systemFont(ofSize: 16)
		textField.backgroundColor = .white
		return textField
	}
	
	public func createButton(withTitle title: String) -> UIButton {
		let button = UIButton(type: .system)
		button.setTitle(title, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = UIColor(red: 0, green: 0.6784, blue: 0.7098, alpha: 1.0)
		button.layer.cornerRadius = 5
		button.addTarget(self, action: #selector(amountButtonTapped(_:)), for: .touchUpInside)
		button.widthAnchor.constraint(equalToConstant: 44).isActive = true
		return button
	}
	
	@objc public func datePickerValueChanged(sender: UIDatePicker) {
		let formattedDate = dateFormatter.string(from: sender.date)
		createdAtTextField.text = formattedDate
	}
	
	@objc public func saveExpense() {
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
			clearTextFields()
		} catch {
			showAlert(message: "Failed to save expense.")
		}
	}
	
	@objc public func amountButtonTapped(_ sender: UIButton) {
		guard var amount = Double(amountTextField.text ?? "0") else { return }
		if sender == increaseButton {
			amount += 1.0
		} else if sender == decreaseButton {
			amount -= 1.0
			if amount < 0 {
				amount = 0
			}
		}
		amountTextField.text = String(format: "%.2f", amount)
	}
	
	@objc public func categoryPickerDone() {
		if categoryTextField.text == "" {
			categoryTextField.text = categories[0]
			pickerView(categoryPicker, didSelectRow: 0, inComponent: 0)
		}
		view.endEditing(true)
	}
	
	@objc public func datePickerDone() {
		createdAtTextField.text = dateFormatter.string(from: datePicker.date)
		view.endEditing(true)
	}

	public func clearTextFields() {
		titleTextField.text = ""
		subtitleTextField.text = ""
		amountTextField.text = ""
		categoryTextField.text = ""
		createdAtTextField.text = ""
	}
	
	public func showAlert(message: String) {
		let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}
}

extension AddViewController: UIPickerViewDataSource, UIPickerViewDelegate {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return categories.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return categories[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		categoryTextField.text = categories[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didClickInComponent component: Int) {
		categoryTextField.text = categories[0]
	}
}
