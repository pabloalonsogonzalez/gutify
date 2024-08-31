//
//  BaseMapper.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 28/8/24.
//

import Foundation

enum MapError: Error {
    case invalidData
}

/**
 Mapper that converts type T into type S and the opposite. It also manages
 lists.
 
 It is used to transform data model to domain model and the oposite, but it can
 be also used to make another mappings.
 */
class BaseMapper<T, S> {

    /// Transform from type T (data model object) to S (domain model object).
    ///
    /// - Parameter dataModel: Type T object.
    /// - Returns: Type S object
    class func transform(_ dataModel: T) throws -> S {
        fatalError("Override this method")
    }

    /// Transform from type S (domain model object) to T (data model object).
    ///
    /// - Parameter domainModel: Type S object.
    /// - Returns: Type T object.
    class func reverseTransform(_ domainModel: S) throws -> T {
        fatalError("Override this method")
    }

    /// Transform from type T (data model object) list to S (domain model
    /// object) list.
    ///
    /// - Parameter dataModelList: Type T object list.
    /// - Returns: Type S object list.
    class func listTransform(_ dataModelList: [T]) throws -> [S] {
        return try dataModelList.map(transform)
    }

    /// Transform from type S (domain model object) list to T (data model
    /// object) list.
    ///
    /// - Parameter domainModelList: Type S object list.
    /// - Returns: Type T object list.
    class func reverseListTransform(_ domainModelList: [S]) throws -> [T] {
        return try domainModelList.map(reverseTransform)
    }

}
