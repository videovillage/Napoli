import Foundation
import NAPIC

public protocol PropertyDescriptor {
    var name: String { get }
    var attributes: napi_property_attributes { get }
    func propertyDescriptor(_ env: napi_env) throws -> napi_property_descriptor
}
