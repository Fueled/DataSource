//
//  ItemsExtensions.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 13/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import CoreData

extension Items {

	func fetchSortedRequest() -> NSFetchRequest<NSFetchRequestResult> {
		let itemsFetchRequest: NSFetchRequest<NSFetchRequestResult> = Items.fetchRequest()
		itemsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
		return itemsFetchRequest
	}
}
