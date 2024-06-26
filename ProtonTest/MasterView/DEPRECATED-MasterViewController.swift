//
//  MasterViewController.swift
//  ProtonTest
//
//  Created by Robert Patchett on 07.02.19.
//  Copyright © 2019 Proton Technologies AG. All rights reserved.
//

import UIKit

@available(*, deprecated)
class MasterViewController: UITableViewController, ImageDownloadDelegate {

    @IBOutlet weak var sortingControl: UISegmentedControl!
    
    var detailViewController: DetailViewController? = nil
    var objects = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        sortingControl.addTarget(self, action: "sortingControlAction:", for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let forecastUrl = URL(string: "https://protonmail.github.io/proton-mobile-test/api/forecast") {
            URLSession.shared.dataTask(with: forecastUrl, completionHandler: { (data, response, error) in
                self.objects = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [[String: Any]]
                self.tableView.reloadData()
            }).resume()
        }
    }
    
    func imageDownloadedForObject(object: [String : Any]) {
        let i = objects.firstIndex { (comparedObject) -> Bool in
            return (comparedObject["day"]! as! String) == (object["day"]! as! String)
        }!
        
        objects[i] = object
        
        tableView.reloadData()
    }
    
    @objc func sortingControlAction(_ segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 1 { // switching to sorted option
            objects.sort { (object1, object2) -> Bool in
                return object1["high"]! as! Double > object2["high"]! as! Double
            }
            
            var tempObjects = objects
            for i in 0..<objects.count {
                if (objects[i]["chance_rain"]! as! Double) > 0.5 {
                    tempObjects.removeAll { (object) -> Bool in
                        return object["chance_rain"]! as! Double == objects[i]["chance_rain"]! as! Double
                    }
                }
            }
            objects = tempObjects
        } else {
            objects.sort { (object1, object2) -> Bool in
                return (object1["day"]! as! String) < (object2["day"]! as! String)
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.delegate = self
                controller.object = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.title = "Day \(object["day"]! as! String)"
            }
        }
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = objects[indexPath.row]
        cell.textLabel!.text = "Day \(object["day"]!): \(object["description"]!)"
        if let imageDownloaded = object["image_downloaded"] as? Bool, imageDownloaded {
            cell.textLabel?.textColor = .gray
        }
        
        return cell
    }
}

