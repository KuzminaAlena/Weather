//
//  ViewController + Extension Alert.swift
//  Weather
//
//  Created by Алена on 14.12.2021.
//

import Foundation
import UIKit

extension ViewController {
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, complitionHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.addTextField { tf in
            let cities = ["San Francisco", "Moscow", "Prague", "Paris", "Amsterdam"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = alertController.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                complitionHandler(city)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(search)
        alertController.addAction(cancel)asdfkasdfgasldkjfhasdkjlfhaskldjf
        present(alertController, animated: true, completion: nil)
    }
}
