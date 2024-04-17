//
//  AddViewController.swift
//  ExpenseTrackingApp
//
//  Created by Ravishka Dulshan on 2024-04-06.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
	
	private var titleLabel: UILabel!
	private var titleTextField: UITextField!
	private var subtitleLabel: UILabel!
	private var subtitleTextField: UITextField!
	private var amountLabel: UILabel!
	private var amountStackView: UIStackView!
	private var amountTextField: UITextField!
	private var increaseButton: UIButton!
	private var decreaseButton: UIButton!
	private var categoryLabel: UILabel!
	private var categoryTextField: UITextField!
	private var createdAtLabel: UILabel!
	private var createdAtTextField: UITextField!
	private var saveButton: UIButton!
	
	private var categoryPicker: UIPickerView!
	private var datePicker: UIDatePicker!
	
	private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .medium
		return formatter
	}()
	
	private let categories = ["Glocery", "Electronics", "Foods", "Others"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	private func setupUI() {
		title = "Add Expense"
		view.backgroundColor = .systemGray6
		
		titleLabel = createLabel(withText: "Title")
		titleTextField = createTextField()
		
		subtitleLabel = createLabel(withText: "Subtitle")
		subtitleTextField = createTextField()
		
		amountLabel = createLabel(withText: "Amount")
		amountTextField = createTextField()
		amountTextField.keyboardType = .decimalPad
		
		increaseButton = createButton(withTitle: "+")
		decreaseButton = createButton(withTitle: "-")
		amountStackView = UIStackView(arrangedSubviews: [decreaseButton, amountTextField, increaseButton])
		amountStackView.axis = .horizontal
		amountStackView.spacing = 8
		
		categoryLabel = createLabel(withText: "Category")
		categoryPicker = UIPickerView()
		categoryPicker.dataSource = self
		categoryPicker.delegate = self
		categoryTextField = createTextField()
		categoryTextField.inputView = categoryPicker
		
		createdAtLabel = createLabel(withText: "Created At")
		datePicker = UIDatePicker()
		datePicker.datePickerMode = .dateAndTime
		datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
		createdAtTextField = createTextField()
		createdAtTextField.inputView = datePicker
		
		saveButton = UIButton(type: .system)
		saveButton.setTitle("Save", for: .normal)
		saveButton.setTitleColor(.white, for: .normal)
		saveButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
		saveButton.layer.cornerRadius = 5
		saveButton.addTarget(self, action: #selector(saveExpense), for: .touchUpInside)
		
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
	
	private func createLabel(withText text: String) -> UILabel {
		let label = UILabel()
		label.text = text
		label.textColor = .darkGray
		label.font = UIFont.boldSystemFont(ofSize: 16)
		return label
	}
	
	private func createTextField() -> UITextField {
		let textField = UITextField()
		textField.borderStyle = .roundedRect
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.font = UIFont.systemFont(ofSize: 16)
		textField.backgroundColor = .white
		return textField
	}
	
	private func createButton(withTitle title: String) -> UIButton {
		let button = UIButton(type: .system)
		button.setTitle(title, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
		button.layer.cornerRadius = 5
		button.addTarget(self, action: #selector(amountButtonTapped(_:)), for: .touchUpInside)
		button.widthAnchor.constraint(equalToConstant: 44).isActive = true
		return button
	}
	
	@objc private func datePickerValueChanged(sender: UIDatePicker) {
		let formattedDate = dateFormatter.string(from: sender.date)
		createdAtTextField.text = formattedDate
	}
	
	@objc private func saveExpense() {
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
	
	@objc private func amountButtonTapped(_ sender: UIButton) {
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
}
