import Foundation
import NAPIC

public protocol PropertyDescribable {
    var name: String { get }
    var attributes: napi_property_attributes { get }
    func propertyDescriptor(_ env: napi_env) throws -> napi_property_descriptor
}

public class Method: PropertyDescribable {
    public let name: String
    public let attributes: napi_property_attributes
    private let callback: Callback

    public init(name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping Callback) {
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

    public init(name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping SelfCallback) {
        super.init(name: name, attributes: attributes) { env, args in
            try callback(Wrap<This>.unwrap(env, jsObject: args.this))(env, args)
        }
    }
}

public class Property: PropertyDescribable {
    public let name: String
    public let attributes: napi_property_attributes

    private let getter: Callback
    private let setter: Callback?

    fileprivate init(name: String, attributes: napi_property_attributes, getter: @escaping Callback, setter: Callback?) {
        self.name = name
        self.attributes = attributes
        self.getter = getter
        self.setter = setter
    }

    public init<V: ValueConvertible>(name: String, attributes: napi_property_attributes = napi_default, getter: @escaping () -> V, setter: ((V) -> Void)? = nil) {
        self.name = name
        self.attributes = attributes

        self.getter = { _, _ in
            getter()
        }

        if let setter {
            self.setter = { env, args in
                try setter(V(env, from: args.0))
                return Undefined.default
            }
        } else {
            self.setter = nil
        }
    }

    public func propertyDescriptor(_ env: napi_env) throws -> napi_property_descriptor {
        let _name = try name.napiValue(env)
        let data = GetSetCallbackData(getter: getter, setter: setter)
        let dataPointer = Unmanaged.passRetained(data).toOpaque()
        return napi_property_descriptor(utf8name: nil, name: _name, method: nil, getter: swiftNAPIGetterCallback, setter: setter != nil ? swiftNAPISetterCallback : nil, value: nil, attributes: attributes, data: dataPointer)
    }
}

public class InstanceProperty<This: AnyObject>: Property {
    public init<V: ValueConvertible>(name: String, attributes: napi_property_attributes = napi_default, keyPath: ReferenceWritableKeyPath<This, V>) {
        super.init(name: name,
                   attributes: attributes,
                   getter: { env, args in
            try Wrap<This>.unwrap(env, jsObject: args.this)[keyPath: keyPath]
        },
                   setter: { env, args in
            try Wrap<This>.unwrap(env, jsObject: args.this)[keyPath: keyPath] = V(env, from: args.0)
            return Undefined.default
        })
    }
}
