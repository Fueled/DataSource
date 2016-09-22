//
//  RACExtensions.swift
//  DataSource
//
//  Created by Vadim Yelagin on 16/07/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol Disposing: AnyObject {

	var disposable: CompositeDisposable { get }

}

public extension SignalProducerProtocol {

	public func start<O: Disposing>(_ target: O, _ method: @escaping (O) -> (Value) -> ()) -> Disposable {
		let disposable = self.startWithResult {
			[weak target] value in
			if let value = try? value.dematerialize(), let target = target {
				method(target)(value)
			}
		}
		target.disposable += disposable
		return disposable
	}

}
