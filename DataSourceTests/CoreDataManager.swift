//
//  CoreDataManager.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 12/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import CoreData

final class CoreDataManager {

	private let persistentContainer: NSPersistentContainer

	var context: NSManagedObjectContext {
		return self.persistentContainer.viewContext
	}

	init() {
		let managedObjectModel = NSManagedObjectModel.mergedModel(from: Bundle.allBundles)!
		self.persistentContainer = NSPersistentContainer(name: "Items", managedObjectModel: managedObjectModel)
		let description = NSPersistentStoreDescription()
		description.type = NSInMemoryStoreType
		self.persistentContainer.persistentStoreDescriptions = [description]
		self.persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error as NSError? {
				fatalError("An error occurred while loading persistent store \(error), \(error.userInfo)")
			}
		})
	}

	func fillItemsWithDataSet(dataSet: [Int]) {
		dataSet.forEach {
			let newItem = NSEntityDescription.insertNewObject(forEntityName: "Items", into: context) as! Items
			newItem.id = String($0)
		}
		self.saveContext()
	}

	private func saveContext () {
		do {
			try self.context.save()
		} catch {
			if let error = error as NSError? {
				fatalError("An error occurred while saving data to persistent store \(error), \(error.userInfo)")
			}
		}
	}
}
