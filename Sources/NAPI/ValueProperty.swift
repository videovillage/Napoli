import Foundation
import NAPIC

public struct ValueProperty: PropertyDescribable {
    public let name: String
    public let attributes: napi_property_attributes
    public let value: ValueConvertible

    public init(_ name: String, attributes: napi_property_attributes = napi_default, value: ValueConvertible) {
        self.name = name
        self.attributes = attributes
        self.value = value
    }

    public func propertyDescriptor(_ env: napi_env) throws -> napi_property_descriptor {
        let _name = try name.napiValue(env)
        let _value = try value.napiValue(env)
        return napi_property_descriptor(utf8name: nil, name: _name, method: nil, getter: nil, setter: nil, value: _value, attributes: attributes, data: nil)
    }
}


