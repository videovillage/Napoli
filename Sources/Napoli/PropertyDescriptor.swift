import Foundation
import NAPIC

public protocol PropertyDescriptor {
    var name: String { get }
    var attributes: napi_property_attributes { get }
    func propertyDescriptor(_ env: Environment) throws -> napi_property_descriptor
}
