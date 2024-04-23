//
//  ExpenseCardView.swift
//  ExpenseTrackingApp
//
//  Created by Ravishka Dulshan on 2024-04-08.
//

import UIKit

class ExpenseCardView: UIView {
	
	var expense: Expense!
	var titleLabel: UILabel!
	var amountLabel: UILabel!
	var categoryLabel: UILabel!
	var createdAtLabel: UILabel!
	
	var parentViewController: UIViewController?
	
	init(expense: Expense, parentViewController: UIViewController) {
		super.init(frame: .zero)
		self.expense = expense
		self.parentViewController = parentViewController
		setupUI()
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
		self.addGestureRecognizer(tapGesture)
		self.isUserInteractionEnabled = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupUI() {
		backgroundColor = UIColor(red: 0, green: 0.6784, blue: 0.7098, alpha: 1.0)
		layer.cornerRadius = 15
	
		
		titleLabel = createLabel(text: expense.title, font: UIFont.boldSystemFont(ofSize: 18), alignment: .left)
		amountLabel = createLabel(text: String(format: "$%.2f", expense.amount), font: UIFont.boldSystemFont(ofSize: 18), alignment: .right)
		categoryLabel = createBadgeLabel(text: expense.category ?? "")
		createdAtLabel = createLabel(text: formatDate(expense.createdAt), font: UIFont.systemFont(ofSize: 14), alignment: .right)
		
		titleLabel.accessibilityIdentifier = "expenseTitle"
		amountLabel.accessibilityIdentifier = "expenseAmount"
		categoryLabel.accessibilityIdentifier = "expenseCategory"
		createdAtLabel.accessibilityIdentifier = "expenseCreatedAt"

		
		let labelStackView1 = createStackView(arrangedSubviews: [titleLabel, amountLabel])
		let labelStackView2 = createStackView(arrangedSubviews: [categoryLabel, createdAtLabel], spacing: 10)
		
		let contentStackView = createStackView(arrangedSubviews: [labelStackView1, labelStackView2], axis: .vertical, spacing: 10)
		
		addSubview(contentStackView)
		
		contentStackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
			contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
			contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
			contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
		])
	}
	
	public func createLabel(text: String?, font: UIFont, alignment: NSTextAlignment) -> UILabel {
		let label = UILabel()
		label.text = text
		label.font = font
		label.textAlignment = alignment
		label.numberOfLines = 0
		return label
	}
	
	public func createBadgeLabel(text: String?) -> UILabel {
		let label = UILabel()
		label.text = text
		label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
		label.textAlignment = .center
		label.textColor = .white
		label.layer.cornerRadius = 10
		label.layer.masksToBounds = true
		
		switch text {
		case "Grocery":
			label.backgroundColor = UIColor(red: 0.2706, green: 0.098, blue: 0.3216, alpha: 1.0)
		case "Electronics":
			label.backgroundColor = UIColor(red: 0.9529, green: 0.6235, blue: 0.3529, alpha: 1.0)
		case "Foods":
			label.backgroundColor = UIColor(red: 0.6824, green: 0.2667, blue: 0.3529, alpha: 1.0)
		default:
			label.backgroundColor = UIColor(red: 0.3608, green: 0.2745, blue: 0.6118, alpha: 1.0)
		}
		
		label.sizeToFit()
		label.layer.cornerRadius = 10
		return label
	}
	
	public func createStackView(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis = .horizontal, spacing: CGFloat = 0) -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
		stackView.axis = axis
		stackView.spacing = spacing
		stackView.distribution = .fillEqually
		return stackView
	}
	
	public func formatDate(_ date: Date?) -> String {
		guard let date = date else {
			return ""
		}
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter.string(from: date)
	}
	
	@objc public func cardTapped() {
		let actionSheet = UIAlertController(title: "Modify Expense", message: nil, preferredStyle: .actionSheet)
		
		let editAction = UIAlertAction(title: "Edit", style: .default) { (_) in
			self.editExpense()
		}
		let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
			self.deleteExpense()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		actionSheet.addAction(editAction)
		actionSheet.addAction(deleteAction)
		actionSheet.addAction(cancelAction)
		
		parentViewController?.present(actionSheet, animated: true, completion: nil)
	}
	
	public func editExpense() {
		let alertController = UIAlertController(title: "Edit Expense", message: nil, preferredStyle: .alert)
		alertController.addTextField { textField in
			textField.placeholder = "Title"
			textField.text = self.expense.title
		}
		alertController.addTextField { textField in
			textField.placeholder = "Amount"
			textField.text = String(self.expense.amount)
			textField.keyboardType = .decimalPad
		}
		alertController.addTextField { textField in
			textField.placeholder = "Category"
			textField.text = self.expense.category
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
			guard let title = alertController.textFields?[0].text, !title.isEmpty,
				  let amountString = alertController.textFields?[1].text, let amount = Double(amountString),
				  let category = alertController.textFields?[2].text
			else {
				self.showErrorAlert(message: "Invalid input. Please fill in all fields.")
				return
			}
			
			self.expense.title = title
			self.expense.amount = amount
			self.expense.category = category
			
			if let context = self.expense.managedObjectContext {
				do {
					try context.save()
					self.updateUI()
				} catch {
					self.showErrorAlert(message: "Failed to save changes.")
				}
			}
		}
		
		alertController.addAction(cancelAction)
		alertController.addAction(saveAction)
		
		parentViewController?.present(alertController, animated: true, completion: nil)
	}
	
	public func updateUI() {
		titleLabel.text = expense.title
		amountLabel.text = String(format: "$%.2f", expense.amount)
		categoryLabel.text = expense.category
		updateCategoryBadge(expense.category)
	}
	
	public func updateCategoryBadge(_ category: String?) {
		switch category {
		case "Grocery":
			categoryLabel.backgroundColor = UIColor(red: 0.2706, green: 0.098, blue: 0.3216, alpha: 1.0)
		case "Electronics":
			categoryLabel.backgroundColor = UIColor(red: 0.9529, green: 0.6235, blue: 0.3529, alpha: 1.0)
		case "Foods":
			categoryLabel.backgroundColor = UIColor(red: 0.6824, green: 0.2667, blue: 0.3529, alpha: 1.0)
		default:
			categoryLabel.backgroundColor = UIColor(red: 0.3608, green: 0.2745, blue: 0.6118, alpha: 1.0)
		}
	}
	
	public func deleteExpense() {
		let confirmationAlert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this expense?", preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
			if let context = self.expense.managedObjectContext {
				context.delete(self.expense)
				
				do {
					try context.save()
					UIView.animate(withDuration: 0.3, animations: {
						self.alpha = 0
					}) { _ in
						self.removeFromSuperview()
					}
				} catch {
					self.showErrorAlert(message: "Failed to delete expense.")
				}
			}
		}
		confirmationAlert.addAction(cancelAction)
		confirmationAlert.addAction(deleteAction)
		parentViewController?.present(confirmationAlert, animated: true, completion: nil)
	}
	
	public func showErrorAlert(message: String) {
		let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		errorAlert.addAction(okAction)
		parentViewController?.present(errorAlert, animated: true, completion: nil)
	}
}
