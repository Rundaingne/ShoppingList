//
//  ShoppingItemTableViewController.swift
//  ShoppingList
//
//  Created by Brooke Kumpunen on 3/15/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit
import CoreData

class ShoppingItemTableViewController: UITableViewController {
    
    //MARK: Properties and landing pads if needed
    let fetchedResultsController: NSFetchedResultsController<ShoppingItem> = {
        //I need to make a request first
        let request: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        //Now I need to sort the request using a sorter.
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        //This last line gives me all the requested fetches in the array of type sorter. Now I just need to return the results controller instance with my data. I.E. the request
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }() //DO NOT FORGET TO MAKE THIS A CLOSURE, DANG IT

    override func viewDidLoad() {
        fetchedResultsController.delegate = self
        super.viewDidLoad()
        //Now in the viewDidLoad I need to preform a fetch, so everytime the app loads up I fetch all my data.
        //To do this, I will need to create the delegate for the resultscontroller. Time to use my code snippet.
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching data")
        }

    }
    
    //MARK: - Methods
    func presentAlertController() {
        let alertController = UIAlertController(title: "Add item", message: "You should probably buy this thing!", preferredStyle: .alert)
        //Alright, I've got an alert controller instance. Now let's add a text field to it, and some actions.
        alertController.addTextField { (textField) in
            textField.placeholder = "What do you need to buy?"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let itemAdded = alertController.textFields?[0].text else {return}
            ShoppingItemController.shared.createItem(name: itemAdded)
        }
        //Now add those actions to the alert controller and present it.
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingItemCell", for: indexPath) as? ShoppingItemTableViewCell
        //Now set the delegate and get the data, and then configure the cell:
        let shoppingItem = fetchedResultsController.object(at: indexPath)
        //We've got an item. Now put it into the cell:
        cell?.delegate = self
        cell?.shoppingItem = shoppingItem

        return cell ?? UITableViewCell()
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = fetchedResultsController.object(at: indexPath)
            ShoppingItemController.shared.deleteItem(item: itemToDelete)
        }
    }
    //Am I even using a segue ever? Nope, don't think so.
    
    //MARK: Actions
    //I will need the plus button action here, where I will make and present the alert controller. And that is it. Whoa.
    @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
        presentAlertController()
    }
    
    //Alright, now before I get too excited I need to configure the cell. This will crash as it is.
    
    
}

extension ShoppingItemTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: indexPath, to: newIndexPath)
            tableView.reloadRows(at: [indexPath, newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
    }
}

//Now I need to set the delegate.
extension ShoppingItemTableViewController: ShoppingItemTableViewCellDelegate {
    func buttonCellButtonTapped(cell: ShoppingItemTableViewCell) {
        //When I tap this button, the image needs to change and isPurchased needs to toggle
        guard let shoppingItem = cell.shoppingItem else {return}
        shoppingItem.isPurchased = !shoppingItem.isPurchased
        if shoppingItem.isPurchased {
            cell.buttonImage.setImage(UIImage(imageLiteralResourceName: "Venus"), for: .normal)
            cell.itemNameLabel.textColor = UIColor.green
            cell.backgroundColor = .black
        } else {
            cell.buttonImage.setImage(UIImage(imageLiteralResourceName: "Isaac2"), for: .normal)
            cell.itemNameLabel.textColor = UIColor.red
            cell.backgroundColor = .white
        }
        tableView.reloadData()
    }
    
    
}
