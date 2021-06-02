//
//  CanvassArea+CoreDataProperties.swift
//  RegModel
//
//  Created by Matt Hogg on 22/04/2021.
//
//

import Foundation
import CoreData


extension CanvassArea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CanvassArea> {
        return NSFetchRequest<CanvassArea>(entityName: "CanvassArea")
    }


}

extension CanvassArea : Identifiable {

}
