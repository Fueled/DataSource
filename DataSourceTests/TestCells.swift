//
//  TestCells.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 01/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import UIKit
import DataSource
import ReactiveSwift
import Result

struct TestCellModel { }

final class TestTableViewCell: TableViewCell, ReusableItem  { }

final class TestCollectionViewCell: CollectionViewCell, ReusableItem { }

struct TestHeaderFooterViewModel { }

final class TestHeaderFooterView: TableViewHeaderFooterView, ReusableItem { }
