# DataSource [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

DataSource is a Swift library that introduces a `DataSource` protocol together with a set of common implementations and related types.

Basically a `DataSource` is a provider of items grouped into sections just like a `UITableViewDataSource` is a provider of `UITableViewCell`s or a `UICollectionViewDataSource` is a provider of `UICollectionViewCell`s.
Thus a data source of a `UITableView` or a `UICollectionView` can be constructed by combining a `DataSource` with a common routine that provides a cell for each item.

The benefit of this approach is that a `DataSource` is decoupled from any view-layer logic and contains only model or view-model items that in turn serve as view-models for corresponding cells.
Such decoupling allows usage of same `DataSource` for both table and collection views as well as compositing several `DataSource`s into a single `CompositeDataSource` object without having to deal with view-related logic.

## Requirements

* iOS 8.0+
* Xcode 6.4
* [Carthage 0.7.5](https://github.com/Carthage/Carthage/releases/tag/0.7.5)
* [ReactiveCocoa 3.0 beta 9](https://github.com/ReactiveCocoa/ReactiveCocoa/releases/tag/v3.0-beta.9)

## DataSource composition

`CompositeDataSource` is one of the implementations of `DataSource` protocol. It is initialized with an array of inner `DataSource`s. The sections of a `CompositeDataSource` are sections of the first inner `DataSource`, followed by sections of the second inner `DataSource`, etc.

## Propagating changes

`DataSource` protocol exposes a `Signal` of `DataChange`s that can be subscribed for in order to update associated `UITableView` or `UICollectionView` when the underlying data changes.

`DataChange` is a simple protocol that comes with a set of implementations for insertion, deletion and reloading of items and sections as well as `DataChangeReloadData` and `DataChangeBatch` for handling multiple `DataChange`s at once.

`CompositeDataSource` automatically merges changes from inner `DataSource`s and properly maps the indices of all `DataChange`s. This means that corresponding sections of `UITableView` or `UICollectionView` are updated whenever any of the inner `DataSource`s emit changes.

## Example

Please see the [DataSourceExample](https://github.com/Vadim-Yelagin/DataSourceExample) project for examples of using DataSource.

## Using with CoreData, KVO and others

`DataSource` protocol can be used to wrap any API that provides a collection of items and notifies of any changes of that collection.

One of such APIs is `NSFetchedResultsController` from CoreData framework. DataSource comes with an implementation of `DataSource` protocol called `FetchedResultsDataSource` that does exactly that.
`FetchedResultsDataSource` can be used just as any other `DataSource` without the need to manually implement `NSFetchedResultsControllerDelegate` protocol.

`KVODataSource` implements another example of such API, Key-Value Observing (KVO) for ordered to-many relationships.

In case you need to handle data changes provided by other sources e.g. Photos framework or the new Contacts framework, similar `DataSource` implementations can be easily crafted.
