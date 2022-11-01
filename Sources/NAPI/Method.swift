import Foundation
import NAPIC

public class Method: PropertyDescribable {
    public let name: String
    public let attributes: napi_property_attributes
    private let callback: Callback

    fileprivate init(name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping Callback) {
        self.name = name
        self.attributes = attributes
        self.callback = callback
    }

    public func propertyDescriptor(_ env: napi_env) throws -> napi_property_descriptor {
        let _name = try name.napiValue(env)
        let data = CallbackData(callback: callback)
        let dataPointer = Unmanaged.passRetained(data).toOpaque()
        return napi_property_descriptor(utf8name: nil, name: _name, method: swiftNAPICallback, getter: nil, setter: nil, value: nil, attributes: attributes, data: dataPointer)
    }
}

public class InstanceMethod<This: AnyObject>: Method {
    public typealias SelfCallback = (_ self: This) -> Callback

    private init(name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping SelfCallback) {
        super.init(name: name, attributes: attributes) { env, args in
            try callback(Wrap<This>.unwrap(env, jsObject: args.this))(env, args)
        }
    }
}
