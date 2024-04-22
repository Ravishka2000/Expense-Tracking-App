//
//  LaunchScreen.swift
//  ExpenseTrackingApp
//
//  Created by Ravishka Dulshan on 2024-04-21.
//

import UIKit

class LaunchScreen: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let imageView = UIImageView(image: UIImage(named: "Logo"))
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(imageView)
		
		NSLayoutConstraint.activate([
			imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			imageView.widthAnchor.constraint(equalToConstant: 200),
			imageView.heightAnchor.constraint(equalToConstant: 200)
		])
	}
}
