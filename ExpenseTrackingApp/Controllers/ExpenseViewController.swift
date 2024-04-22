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
	var sortedExpenses: [Expense] = []
	
	private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		fetchExpenses()
	}
	
	private func setupUI() {
		view.backgroundColor = .systemGray6
		title = "Expenses"
		
		summaryLabel = UILabel()
		summaryLabel.text = "Total Expenses: $0.00"
		summaryLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
		summaryLabel.textAlignment = .center
		summaryLabel.textColor = UIColor(red: 0.2235, green: 0.2431, blue: 0.2745, alpha: 1.0)
		summaryLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(summaryLabel)
		
		stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 20
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.showsVerticalScrollIndicator = false
		scrollView.addSubview(stackView)
		view.addSubview(scrollView)
		
		refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
		scrollView.refreshControl = refreshControl
		
		let padding: CGFloat = 20
		
		NSLayoutConstraint.activate([
			summaryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
			summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
			summaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
			
			scrollView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: padding),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
			
			stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
		])
	}
	
	private func fetchExpenses() {
		do {
			let expenses = try context.fetch(Expense.fetchRequest()) as! [Expense]
			sortedExpenses = expenses.sorted { $0.createdAt! > $1.createdAt! }
			updateUI(with: sortedExpenses)
		} catch {
			showAlert(title: "Error", message: "Failed to fetch expenses. \(error.localizedDescription)")
		}
	}
	
	private func updateUI(with expenses: [Expense]) {
		stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
		
		let groupedExpenses = groupExpensesByDate(expenses)
		
		var totalExpenses: Double = 0
		
		for (sectionTitle, sectionExpenses) in groupedExpenses {
			if sectionExpenses.isEmpty {
				continue
			}
			
			let sectionLabel = UILabel()
			sectionLabel.text = sectionTitle
			sectionLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
			sectionLabel.textColor = .systemGray
			stackView.addArrangedSubview(sectionLabel)
			
			for expense in sectionExpenses {
				totalExpenses += expense.amount
				let expenseView = ExpenseCardView(expense: expense, parentViewController: self)
				stackView.addArrangedSubview(expenseView)
			}
		}
		
		summaryLabel.text = String(format: "Total Expenses: $%.2f", totalExpenses)
	}
	
	private func groupExpensesByDate(_ expenses: [Expense]) -> [String: [Expense]] {
		var groupedExpenses = [String: [Expense]]()
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM dd, yyyy"
		
		for expense in expenses {
			let dateKey = dateFormatter.string(from: expense.createdAt!)
			
			if var existingExpenses = groupedExpenses[dateKey] {
				existingExpenses.append(expense)
				groupedExpenses[dateKey] = existingExpenses
			} else {
				groupedExpenses[dateKey] = [expense]
			}
		}
		
		return groupedExpenses
	}
	
	@objc private func refreshData() {
		fetchExpenses()
		refreshControl.endRefreshing()
	}
	
	private func showAlert(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(okAction)
		present(alertController, animated: true, completion: nil)
	}
}
