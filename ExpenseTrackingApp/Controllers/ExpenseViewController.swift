//
//  ExpenseViewController.swift
//  ExpenseTrackingApp
//
//  Created by Ravishka Dulshan on 2024-04-06.
//

import UIKit
import CoreData

class ExpenseViewController: UIViewController {
	
	// UI components
	var titleLabel: UILabel!
	var summaryLabel: UILabel!
	var scrollView: UIScrollView!
	var stackView: UIStackView!
	
	// Core Data context
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		fetchExpenses()
	}
	
	func setupUI() {
		view.backgroundColor = .white
		
		// Title label
		titleLabel = UILabel()
		titleLabel.text = "Expense Tracker"
		titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
		titleLabel.textAlignment = .center
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(titleLabel)
		
		// Summary label
		summaryLabel = UILabel()
		summaryLabel.text = "Total Expenses: $0.00"
		summaryLabel.font = UIFont.systemFont(ofSize: 18)
		summaryLabel.textAlignment = .center
		summaryLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(summaryLabel)
		
		// Stack view for expense cards
		stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 20
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		// Scroll view to contain the stack view
		scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(stackView)
		view.addSubview(scrollView)
		
		// Constraints
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
			summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			summaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			scrollView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
		])
	}
	
	func fetchExpenses() {
		do {
			let expenses = try context.fetch(Expense.fetchRequest()) as [Expense]
			updateUI(with: expenses)
		} catch {
			print("Failed to fetch expenses: \(error.localizedDescription)")
		}
	}
	
	func updateUI(with expenses: [Expense]) {
		for expense in expenses {
			let expenseView = ExpenseCardView(expense: expense)
			stackView.addArrangedSubview(expenseView)
		}
	}
}

class ExpenseCardView: UIView {
	
	var expense: Expense!
	var titleLabel: UILabel!
	var subtitleLabel: UILabel!
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
		// Card view style
		backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
		layer.cornerRadius = 16
		layer.masksToBounds = true
		
		// Title label
		titleLabel = UILabel()
		titleLabel.text = expense.title
		titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
		titleLabel.textAlignment = .center
		titleLabel.numberOfLines = 0
		
		// Subtitle label
		subtitleLabel = UILabel()
		subtitleLabel.text = expense.subtitle
		subtitleLabel.font = UIFont.systemFont(ofSize: 18)
		subtitleLabel.textAlignment = .center
		
		// Amount label
		amountLabel = UILabel()
		amountLabel.text = String(format: "$%.2f", expense.amount)
		amountLabel.font = UIFont.boldSystemFont(ofSize: 20)
		amountLabel.textAlignment = .center
		
		// Category label
		categoryLabel = UILabel()
		categoryLabel.text = "Category: \(String(describing: expense.category))"
		categoryLabel.font = UIFont.systemFont(ofSize: 16)
		categoryLabel.textAlignment = .center
		
		// Created At label
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .medium
		let createdAtString = formatter.string(from: expense.createdAt ?? Date())
		
		createdAtLabel = UILabel()
		createdAtLabel.text = "Created At: \(createdAtString)"
		createdAtLabel.font = UIFont.systemFont(ofSize: 14)
		createdAtLabel.textAlignment = .center
		
		// Edit button
		editButton = UIButton(type: .system)
		editButton.setTitle("Edit", for: .normal)
		editButton.setTitleColor(.systemBlue, for: .normal)
		
		// Delete button
		deleteButton = UIButton(type: .system)
		deleteButton.setTitle("Delete", for: .normal)
		deleteButton.setTitleColor(.systemRed, for: .normal)
		
		// Stack view to hold labels
		let labelStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, amountLabel, categoryLabel, createdAtLabel])
		labelStackView.axis = .vertical
		labelStackView.spacing = 10
		
		// Stack view to hold buttons
		let buttonStackView = UIStackView(arrangedSubviews: [editButton, deleteButton])
		buttonStackView.axis = .horizontal
		buttonStackView.spacing = 20
		buttonStackView.alignment = .center
		
		// Stack view to hold content
		let contentStackView = UIStackView(arrangedSubviews: [labelStackView, buttonStackView])
		contentStackView.axis = .vertical
		contentStackView.spacing = 20
		contentStackView.alignment = .center
		addSubview(contentStackView)
		
		// Constraints
		contentStackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
			contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
			contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
			contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
			buttonStackView.widthAnchor.constraint(equalTo: labelStackView.widthAnchor)
		])
	}
}
