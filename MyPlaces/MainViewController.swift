//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Анастасия Лагарникова on 03.06.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    let restaurantNames = ["1 restaurant", "2 restaurant", "3 restaurant", "4 restaurant", "5 restaurant",
                           "6 restaurant", "7 restaurant", "8 restaurant", "9 restaurant", "10 restaurant",
                           "11 restaurant", "12 restaurant", "13 restaurant", "14 restaurant", "15 restaurant"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        restaurantNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = restaurantNames[indexPath.row]
        cell.imageView?.image = UIImage(named: restaurantNames[indexPath.row])
        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2
        cell.imageView?.clipsToBounds = true

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        85
    }
    

   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
