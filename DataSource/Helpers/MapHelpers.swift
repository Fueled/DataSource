//
//  MapHelpers.swift
//  DataSource
//
//  Created by Stéphane Copin on 2/24/21.
//  Copyright © 2021 Fueled. All rights reserved.
//

import Foundation

func mapInside(_ inner: [DataSource], _ outerSection: Int) -> (Int, Int) {
	var innerSection = outerSection
	var index = 0
	while innerSection >= inner[index].numberOfSections {
		innerSection -= inner[index].numberOfSections
		index += 1
	}
	return (index, innerSection)
}

func mapOutside(_ inner: [DataSource], _ index: Int) -> (Int) -> Int {
	return { innerSection in
		var outerSection = innerSection
		for i in 0 ..< index {
			outerSection += inner[i].numberOfSections
		}
		return outerSection
	}
}
