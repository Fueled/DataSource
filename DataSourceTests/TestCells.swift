//
//  TestCells.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 01/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import DataSource

struct TestCellModel { }

final class TestTableViewCell: TableViewCell, ReusableItem  { }

final class TestCollectionViewCell: CollectionViewCell, ReusableItem { }

struct TestHeaderFirstViewModel { }

final class TestHeaderFirstView: TableViewHeaderFooterView, ReusableItem { }

struct TestHeaderSecondViewModel { }

final class TestHeaderSecondView: TableViewHeaderFooterView, ReusableItem { }

struct TestFooterFirstViewModel { }

final class TestFooterFirstView: TableViewHeaderFooterView, ReusableItem { }

struct TestFooterSecondViewModel { }

final class TestFooterSecondView: TableViewHeaderFooterView, ReusableItem { }
