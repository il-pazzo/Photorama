//
//  TagsViewController.swift
//  Photorama
//
//  Created by Glenn Cole on 6/20/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import UIKit
import CoreData

class TagsViewController: UITableViewController {
    
    var store: PhotoStore!
    var photo: Photo!
    
    var selectedIndexPaths = [IndexPath]()
    
    let tagDataSource = TagDataSource()
    
    
    // MARK: - Code begins here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = tagDataSource
        tableView.delegate = self
        
        updateTags()
    }
    
    @IBAction func done( _ sender: UIBarButtonItem ) {
        
        presentingViewController?.dismiss( animated: true )
    }
    
    @IBAction func addNewTag( _ sender: UIBarButtonItem ) {
        
        let alertController = setupAlertControllerForAdd()
        
        present( alertController, animated: true )
    }
    
    private func updateTags( selecting newTag: Tag? = nil ) {
        
        store.fetchAllTags() { (tagsResult) in
            
            // we'll need to reload the selectedIndexPaths array, so erase what's there now
            self.selectedIndexPaths.removeAll( keepingCapacity: true )
            
            switch tagsResult {
                    
            case let .failure( error ):
                print( "Error fetching tags: \(error)." )

            case let .success( tags ):
                self.tagDataSource.tags = tags
                
                guard let photoTags = self.photo.tags as? Set<Tag> else {
                    return
                }

                // update the index paths for existing tags
                for tag in photoTags {
                    if let index = self.tagDataSource.tags.firstIndex( of: tag ) {
                        let indexPath = IndexPath( row: index, section: 0 )
                        self.selectedIndexPaths.append( indexPath )
                    }
                }

                // if a new tag was added just now, ASSUME IT APPLIES HERE and update accordingly
                if let newTag = newTag,
                    let newIndex = self.tagDataSource.tags.firstIndex( of: newTag) {
                    
                    let indexPath = IndexPath( row: newIndex, section: 0 )
                    self.updateLinkagesFor( tag: newTag, at: indexPath )
                }
            }
            
            self.tableView.reloadSections( IndexSet( integer: 0 ),
                                           with: .automatic )
        }
    }
}


// MARK: - setup AlertController for add button

extension TagsViewController {
    
    func setupAlertControllerForAdd() -> UIAlertController {
        
        let alertController = UIAlertController( title: "Add Tag",
                                                 message: nil,
                                                 preferredStyle: .alert )
        
        alertController.addTextField { (textField) in
            textField.placeholder = "tag name"
            textField.autocapitalizationType = .words
        }
        
        let okAction = UIAlertAction( title: "OK", style: .default ) { (action) in
            
            if let tagName = alertController.textFields?.first?.text {
                let context = self.store.persistentContainer.viewContext
                let newTag = Tag( context: context )
                newTag.setValue( tagName, forKey: "name" )
                
                do {
                    try context.save()
                }
                catch {
                    print( "Core Data save failed: \(error)." )
                }
                
                self.updateTags( selecting: newTag )
            }
        }
        alertController.addAction( okAction )
        
        let cancelAction = UIAlertAction( title: "Cancel",
                                          style: .cancel,
                                          handler: nil )
        alertController.addAction( cancelAction )
        
        return alertController
    }
}


// MARK: - TableViewDelegate methods

extension TagsViewController {
    
    override func tableView( _ tableView: UITableView,
                             didSelectRowAt indexPath: IndexPath ) {
        
        let tag = tagDataSource.tags[ indexPath.row ]
    
        updateLinkagesFor( tag: tag, at: indexPath )
        
        tableView.reloadRows( at: [indexPath], with: .automatic )
    }
    
    private func updateLinkagesFor( tag: Tag, at indexPath: IndexPath ) {
        
        if let index = selectedIndexPaths.firstIndex( of: indexPath ) {
            selectedIndexPaths.remove( at: index )
            photo.removeFromTags( tag )
        }
        else {
            selectedIndexPaths.append( indexPath )
            photo.addToTags( tag )
        }
        
        do {
            try store.persistentContainer.viewContext.save()
        }
        catch {
            print( "Core Data save failed: \(error)." )
        }
    }
    
    override func tableView( _ tableView: UITableView,
                             willDisplay cell: UITableViewCell,
                             forRowAt indexPath: IndexPath ) {
        
        if selectedIndexPaths.firstIndex( of: indexPath ) != nil {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
    }
}
