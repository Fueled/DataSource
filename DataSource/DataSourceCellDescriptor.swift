import UIKit

enum CellPrototypeSource {
	case storyboard
	case nib(UINib)
	case `class`(AnyObject.Type)
}

struct CellDescriptor {
	let reuseIdentifier: String
	let prototypeSource: CellPrototypeSource
	let isMatching: (IndexPath, Any) -> Bool

	init(
		_ reuseIdentifier: String,
		_ prototypeSource: CellPrototypeSource = .storyboard,
		isMatching: @escaping (IndexPath, Any) -> Bool)
	{
		self.reuseIdentifier = reuseIdentifier
		self.prototypeSource = prototypeSource
		self.isMatching = isMatching
	}

	init<Item>(
		_ reuseIdentifier: String,
		_ itemType: Item.Type,
		_ prototypeSource: CellPrototypeSource = .storyboard)
	{
		self.init(reuseIdentifier, prototypeSource) { $1 is Item }
	}
}

extension CollectionViewDataSource {
	func configure(_ collectionView: UICollectionView, using cellDescriptors: [CellDescriptor]) {
		self.reuseIdentifierForItem = { indexPath, item in
			for descriptor in cellDescriptors {
				if descriptor.isMatching(indexPath, item) {
					return descriptor.reuseIdentifier
				}
			}
			fatalError()
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
	}
}

extension TableViewDataSource {
	func configure(_ tableView: UITableView, using cellDescriptors: [CellDescriptor]) {
		self.reuseIdentifierForItem = { indexPath, item in
			for descriptor in cellDescriptors {
				if descriptor.isMatching(indexPath, item) {
					return descriptor.reuseIdentifier
				}
			}
			fatalError()
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
	}
}
