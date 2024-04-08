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
	
	init(expense: Expense) {
		super.init(frame: .zero)
		self.expense = expense
		setupUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupUI() {
		backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
		layer.cornerRadius = 20
		layer.masksToBounds = true
		
		titleLabel = UILabel()
		titleLabel.text = expense.title
		titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
		titleLabel.textAlignment = .left
		titleLabel.numberOfLines = 0
		
		amountLabel = UILabel()
		amountLabel.text = String(format: "$%.2f", expense.amount)
		amountLabel.font = UIFont.boldSystemFont(ofSize: 24)
		amountLabel.textAlignment = .right
		
		categoryLabel = UILabel()
		categoryLabel.text = "\(String(describing: expense.category!))"
		categoryLabel.font = UIFont.systemFont(ofSize: 16)
		categoryLabel.textAlignment = .left
		
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		let createdAtString = formatter.string(from: expense.createdAt ?? Date())
		
		createdAtLabel = UILabel()
		createdAtLabel.text = "\(createdAtString)"
		createdAtLabel.font = UIFont.systemFont(ofSize: 14)
		createdAtLabel.textAlignment = .right
		
		editButton = UIButton(type: .system)
		editButton.setTitle("Edit", for: .normal)
		editButton.setTitleColor(.white, for: .normal)
		editButton.backgroundColor = .systemBlue
		editButton.layer.cornerRadius = 10
		
		deleteButton = UIButton(type: .system)
		deleteButton.setTitle("Delete", for: .normal)
		deleteButton.setTitleColor(.white, for: .normal)
		deleteButton.backgroundColor = .systemRed
		deleteButton.layer.cornerRadius = 10
		
		let labelStackView1 = UIStackView(arrangedSubviews: [titleLabel, amountLabel])
		labelStackView1.axis = .horizontal
		labelStackView1.distribution = .fillEqually
		
		let labelStackView2 = UIStackView(arrangedSubviews: [categoryLabel, createdAtLabel])
		labelStackView2.axis = .horizontal
		labelStackView2.spacing = 50
		labelStackView2.distribution = .fillEqually
		
		let buttonStackView = UIStackView(arrangedSubviews: [editButton, deleteButton])
		buttonStackView.axis = .horizontal
		buttonStackView.spacing = 50
		buttonStackView.distribution = .fillEqually
		
		editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
		deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
		
		let contentStackView = UIStackView(arrangedSubviews: [labelStackView1, labelStackView2, buttonStackView])
		contentStackView.axis = .vertical
		contentStackView.spacing = 20
		contentStackView.alignment = .fill
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
	
	@objc func editButtonTapped() {
		
	}
	
	@objc func deleteButtonTapped() {
		if let context = expense.managedObjectContext {
			context.delete(expense)
			
			do {
				try context.save()
			} catch {
				print("Failed to save context: \(error.localizedDescription)")
			}
		}
		
		removeFromSuperview()
	}
}
