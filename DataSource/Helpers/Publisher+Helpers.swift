//
//  Publisher+Helpers.swift
//  DataSource
//
//  Created by Stéphane Copin on 2/24/21.
//  Copyright © 2021 Fueled. All rights reserved.
//

import Combine

extension Publisher {
	public func combinePrevious() -> AnyPublisher<(previous: Output, current: Output), Failure> {
		self.combinePreviousImplementation(nil)
	}

	public func combinePrevious(_ initial: Output) -> AnyPublisher<(previous: Output, current: Output), Failure> {
		self.combinePreviousImplementation(initial)
	}

	private func combinePreviousImplementation(_ initial: Output?) -> AnyPublisher<(previous: Output, current: Output), Failure> {
		var previousValue = initial
		return self
			.flatMap { output -> AnyPublisher<(previous: Output, current: Output), Failure> in
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
			.eraseToAnyPublisher()
	}
}
