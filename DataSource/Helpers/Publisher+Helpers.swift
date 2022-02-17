//
//  Publisher+Helpers.swift
//  DataSource
//
//  Created by Stéphane Copin on 2/24/21.
//  Copyright © 2021 Fueled. All rights reserved.
//

import Combine

extension Publisher {
	func combinePrevious() -> AnyPublisher<(previous: Output, current: Output), Failure> {
		self.combinePreviousImplementation(nil)
	}

	func combinePrevious(_ initial: Output) -> AnyPublisher<(previous: Output, current: Output), Failure> {
		self.combinePreviousImplementation(initial)
	}

	func combinePreviousImplementation(_ initial: Output?) -> AnyPublisher<(previous: Output, current: Output), Failure> {
		var previousValue = initial
		return self
			.map { output -> AnyPublisher<(previous: Output, current: Output), Failure> in
				defer {
					previousValue = output
				}
				if let currentPreviousValue = previousValue {
					return Just((currentPreviousValue, output))
						.setFailureType(to: Failure.self)
						.eraseToAnyPublisher()
				} else {
					return Empty(completeImmediately: false).eraseToAnyPublisher()
				}
			}
			.switchToLatest()
			.eraseToAnyPublisher()
	}
}