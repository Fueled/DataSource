//
//  FetchedResultsDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 11/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import UIKit
import XCTest
import DataSource
import ReactiveSwift
import Quick
import Nimble
import CoreData

class FetchedResultsDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		beforeSuite {
			self.initCoreDataManagerWithTestData(testData: self.testDataSet)
		}
		var dataSource: FetchedResultsDataSource!
		beforeEach {
			dataSource = try? FetchedResultsDataSource(fetchRequest: Items().fetchSortedRequest(), managedObjectContext: self.coreDataManager!.context)
		}
		itBehavesLike("DataSource protocol") { ["DataSource": dataSource, "InitialData": [self.testDataSet]] }
	}
}
