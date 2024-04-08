//
//  ExpenseViewController.swift
//  ExpenseTrackingApp
//
//  Created by Ravishka Dulshan on 2024-04-06.
//

import UIKit
import CoreData

class ExpenseViewController: UIViewController {
	
	var summaryLabel: UILabel!
	var scrollView: UIScrollView!
	var stackView: UIStackView!
	var refreshControl: UIRefreshControl!
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		fetchExpenses()
	}
	
	func setupUI() {
		view.backgroundColor = .white
		title = "Expenses"
		
		summaryLabel = UILabel()
		summaryLabel.text = "Total Expenses: $0.00"
		summaryLabel.font = UIFont.systemFont(ofSize: 18)
		summaryLabel.textAlignment = .center
		summaryLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(summaryLabel)
		
		stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 20
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(stackView)
		view.addSubview(scrollView)
		
		refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
		scrollView.refreshControl = refreshControl
		
		NSLayoutConstraint.activate([
			summaryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
		// Clear previous data
		stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
		
		for expense in expenses {
			let expenseView = ExpenseCardView(expense: expense)
			stackView.addArrangedSubview(expenseView)
		}
	}
	
	@objc func refreshData() {
		fetchExpenses()
		refreshControl.endRefreshing()
	}
}
