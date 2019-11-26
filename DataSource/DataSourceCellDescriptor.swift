//
//  DataSourceCellDescriptor.swift
//  DataSource
//
//  Created by Aleksei Bobrov on 05/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import UIKit

public class CellDescriptor: NSObject {
	public let reuseIdentifier: String
	public let prototypeSource: PrototypeSource
	public let isMatching: (IndexPath, Any) -> Bool

	public init(
		_ reuseIdentifier: String,
		_ prototypeSource: PrototypeSource = .storyboard,
		isMatching: @escaping (IndexPath, Any) -> Bool)
	{
		self.reuseIdentifier = reuseIdentifier
		self.prototypeSource = prototypeSource
		self.isMatching = isMatching
	}

	public convenience init<Item>(
		_ reuseIdentifier: String,
		_ itemType: Item.Type,
		_ prototypeSource: PrototypeSource = .storyboard)
	{
		self.init(reuseIdentifier, prototypeSource) { $1 is Item }
	}
}

public class HeaderFooterDescriptor: NSObject {
	public let reuseIdentifier: String
	public let prototypeSource: PrototypeSource
	public let isMatching: (IndexPath, Any) -> Bool

	public init(
		_ reuseIdentifier: String,
		_ prototypeSource: PrototypeSource,
		isMatching: @escaping (IndexPath, Any) -> Bool)
	{
		self.reuseIdentifier = reuseIdentifier
		self.prototypeSource = prototypeSource
		self.isMatching = isMatching
	}

	public convenience init<Item>(
		_ reuseIdentifier: String,
		_ itemType: Item.Type,
		_ prototypeSource: PrototypeSource = .storyboard)
	{
		self.init(reuseIdentifier, prototypeSource) { $1 is Item }
	}
}

public enum PrototypeSource {
	case storyboard
	case nib(UINib)
	case `class`(AnyObject.Type)
}

extension CollectionViewDataSource {
	@objc open func configure(_ collectionView: UICollectionView, using cellDescriptors: [CellDescriptor]) {
		self.reuseIdentifierForItem = { indexPath, item in
			guard let reuseIdentifier = cellDescriptors.first(where: { $0.isMatching(indexPath, item) })?.reuseIdentifier else {
				fatalError("Unable to determine reuse identifier")
			}
			return reuseIdentifier
		}
		for descriptor in cellDescriptors {
			switch descriptor.prototypeSource {
			case .storyboard:
				break
			case .nib(let nib):
				collectionView.register(nib, forCellWithReuseIdentifier: descriptor.reuseIdentifier)
			case .class(let type):
				collectionView.register(type, forCellWithReuseIdentifier: descriptor.reuseIdentifier)
			}
		}
		collectionView.dataSource = self
		self.collectionView = collectionView
		collectionView.performBatchUpdates(nil)
	}
}

extension TableViewDataSource {
	@objc open func configure(_ tableView: UITableView, using cellDescriptors: [CellDescriptor]) {
		self.reuseIdentifierForItem = { indexPath, item in
			guard let reuseIdentifier = cellDescriptors.first(where: { $0.isMatching(indexPath, item) })?.reuseIdentifier else {
				fatalError("Unable to determine reuse identifier")
			}
			return reuseIdentifier
		}
		for descriptor in cellDescriptors {
			switch descriptor.prototypeSource {
			case .storyboard:
				break
			case .nib(let nib):
				tableView.register(nib, forCellReuseIdentifier: descriptor.reuseIdentifier)
			case .class(let type):
				tableView.register(type, forCellReuseIdentifier: descriptor.reuseIdentifier)
			}
		}
		tableView.dataSource = self
		self.tableView = tableView
		if #available(iOS 11.0, *) {
			tableView.performBatchUpdates(nil)
		}
	}
}

extension TableViewDataSourceWithHeaderFooterViews {
	@objc open func configure(_ tableView: UITableView, using cellDescriptors: [CellDescriptor], headerDescriptor: HeaderFooterDescriptor?, footerDescriptor: HeaderFooterDescriptor?) {
		self.reuseIdentifierForItem = { indexPath, item in
			guard let reuseIdentifier = cellDescriptors.first(where: { $0.isMatching(indexPath, item) })?.reuseIdentifier else {
				fatalError("Unable to determine reuse identifier")
			}
			return reuseIdentifier
		}
		for descriptor in cellDescriptors {
			switch descriptor.prototypeSource {
			case .storyboard:
				break
			case .nib(let nib):
				tableView.register(nib, forCellReuseIdentifier: descriptor.reuseIdentifier)
			case .class(let type):
				tableView.register(type, forCellReuseIdentifier: descriptor.reuseIdentifier)
			}
		}
		if let headerDescriptor = headerDescriptor {
			self.reuseIdentifierForHeaderItem = { index, item in
				return headerDescriptor.reuseIdentifier
			}
			switch headerDescriptor.prototypeSource {
			case .storyboard:
				break
			case .nib(let nib):
				tableView.register(nib, forHeaderFooterViewReuseIdentifier: headerDescriptor.reuseIdentifier)
			case .class(let type):
				tableView.register(type, forHeaderFooterViewReuseIdentifier: headerDescriptor.reuseIdentifier)
			}
		}
		if let footerDescriptor = footerDescriptor {
			self.reuseIdentifierForFooterItem = { index, item in
				return footerDescriptor.reuseIdentifier
			}
			switch footerDescriptor.prototypeSource {
			case .storyboard:
				break
			case .nib(let nib):
				tableView.register(nib, forHeaderFooterViewReuseIdentifier: footerDescriptor.reuseIdentifier)
			case .class(let type):
				tableView.register(type, forHeaderFooterViewReuseIdentifier: footerDescriptor.reuseIdentifier)
			}
		}

		tableView.dataSource = self
		self.tableView = tableView
		if #available(iOS 11.0, *) {
			tableView.performBatchUpdates(nil)
		}
	}
}

public protocol ReusableItem: AnyObject {
	static var reuseIdentifier: String { get }
}

public protocol ReusableNib: AnyObject {
	static var nib: UINib { get }
}

extension ReusableItem where Self: UIView {
	public static var reuseIdentifier: String { return String(describing: self).components(separatedBy: ".").last! }
}

extension ReusableNib where Self: UIView, Self: ReusableItem {
	public static var nib: UINib { return UINib(nibName: self.reuseIdentifier, bundle: nil) }
}
