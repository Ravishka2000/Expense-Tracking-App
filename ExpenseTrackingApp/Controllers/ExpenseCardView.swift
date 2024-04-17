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
	var editButton: UIButton!
	var deleteButton: UIButton!
	
	var parentViewController: UIViewController?
	
	init(expense: Expense, parentViewController: UIViewController) {
		super.init(frame: .zero)
		self.expense = expense
		self.parentViewController = parentViewController
		setupUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupUI() {
		backgroundColor = .white
		layer.cornerRadius = 20
		layer.masksToBounds = true
		
		titleLabel = createLabel(text: expense.title, font: UIFont.boldSystemFont(ofSize: 24), alignment: .left)
		amountLabel = createLabel(text: String(format: "$%.2f", expense.amount), font: UIFont.boldSystemFont(ofSize: 24), alignment: .right)
		categoryLabel = createLabel(text: expense.category ?? "", font: UIFont.systemFont(ofSize: 16), alignment: .left)
		createdAtLabel = createLabel(text: formatDate(expense.createdAt), font: UIFont.systemFont(ofSize: 14), alignment: .right)
		editButton = createButton(title: "Edit", backgroundColor: .systemBlue, action: #selector(editButtonTapped))
		deleteButton = createButton(title: "Delete", backgroundColor: .systemRed, action: #selector(deleteButtonTapped))
		
		let labelStackView1 = createStackView(arrangedSubviews: [titleLabel, amountLabel])
		let labelStackView2 = createStackView(arrangedSubviews: [categoryLabel, createdAtLabel], spacing: 50)
		let buttonStackView = createStackView(arrangedSubviews: [editButton, deleteButton], spacing: 50)
		
		let contentStackView = createStackView(arrangedSubviews: [labelStackView1, labelStackView2, buttonStackView], axis: .vertical, spacing: 20)
		
		addSubview(contentStackView)
		
		contentStackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
			contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
			contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
			contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
			editButton.widthAnchor.constraint(equalTo: deleteButton.widthAnchor),
			categoryLabel.widthAnchor.constraint(equalTo: createdAtLabel.widthAnchor)
		])
	}
	
	private func createLabel(text: String?, font: UIFont, alignment: NSTextAlignment) -> UILabel {
		let label = UILabel()
		label.text = text
		label.font = font
		label.textAlignment = alignment
		label.numberOfLines = 0
		return label
	}
	
	private func createButton(title: String, backgroundColor: UIColor, action: Selector) -> UIButton {
		let button = UIButton(type: .system)
		button.setTitle(title, for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = backgroundColor
		button.layer.cornerRadius = 10
		button.addTarget(self, action: action, for: .touchUpInside)
		return button
	}
	
	private func createStackView(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis = .horizontal, spacing: CGFloat = 0) -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
		stackView.axis = axis
		stackView.spacing = spacing
		stackView.distribution = .fillEqually
		return stackView
	}
	
	private func formatDate(_ date: Date?) -> String {
		guard let date = date else {
			return ""
		}
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter.string(from: date)
	}
		
	@objc private func editButtonTapped() {
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
					UIView.transition(with: self.titleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
						self.titleLabel.text = title
					})
					UIView.transition(with: self.amountLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
						self.amountLabel.text = String(format: "$%.2f", amount)
					})
					UIView.transition(with: self.categoryLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
						self.categoryLabel.text = category
					})
				} catch {
					self.showErrorAlert(message: "Failed to save changes.")
				}
			}
		}
		
		alertController.addAction(cancelAction)
		alertController.addAction(saveAction)
		
		parentViewController?.present(alertController, animated: true, completion: nil)
	}
	
	@objc private func deleteButtonTapped() {
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
	
	private func showErrorAlert(message: String) {
		let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		errorAlert.addAction(okAction)
		parentViewController?.present(errorAlert, animated: true, completion: nil)
	}

}
