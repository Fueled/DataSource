//
//  Sequence+DataSource.swift
//  DataSource
//
//  Created by Stéphane Copin on 2/24/21.
//  Copyright © 2021 Fueled. All rights reserved.
//

import Combine

extension Sequence where Element: DataSource {
	var allInnerChanges: AnyPublisher<DataChange, Never> {
		return Publishers.MergeMany(
			self.enumerated().map { index, dataSource in
				return dataSource.changes.map {
					$0.mapSections(mapOutside(Array(self), index))
				}
			}
		)
			.eraseToAnyPublisher()
	}
}
