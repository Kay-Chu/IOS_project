//
//  Messages+CoreDataProperties.swift
//  IOS_project
//
//  Created by KA YING CHU on 28/1/2024.
//
//

import Foundation
import CoreData


extension Messages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Messages> {
        return NSFetchRequest<Messages>(entityName: "Messages")
    }

    @NSManaged public var owner: String?
    @NSManaged public var id: UUID?
    @NSManaged public var text: String?

}

extension Messages : Identifiable {

}
