import Foundation
import NAPIC

public class GetSetPropertyDescriptor: PropertyDescriptor {
    public let name: String
    public let attributes: napi_property_attributes

    private let getter: Callback
    private let setter: Callback

    fileprivate init(_ name: String, attributes: napi_property_attributes, getter: @escaping Callback, setter: Callback?) {
        self.name = name
        self.attributes = attributes
        self.getter = getter
        self.setter = setter ?? { _, _ in
            throw ReadOnlyError(name)
        }
    }

    public init<V: ValueConvertible>(_ name: String, attributes: napi_property_attributes = napi_default, getter: @escaping () -> V, setter: ((V) -> Void)? = nil) {
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
            self.setter = { _, _ in
                throw ReadOnlyError(name)
            }
        }
    }

    public func propertyDescriptor(_ env: Environment) throws -> napi_property_descriptor {
        let _name = try name.napiValue(env)
        let data = GetSetCallbackData(getter: getter, setter: setter)
        let dataPointer = Unmanaged.passRetained(data).toOpaque()
        return napi_property_descriptor(utf8name: nil, name: _name, method: nil, getter: swiftNAPIGetterCallback, setter: swiftNAPISetterCallback, value: nil, attributes: attributes, data: dataPointer)
    }

    private struct ReadOnlyError: ErrorConvertible {
        let code: String? = "ESWIFTREADONLYPROPERTY"
        let message: String

        init(_ name: String) {
            message = "Tried to write to read-only property \"\(name)\""
        }
    }
}

public class InstanceGetSetPropertyDescriptor<This: AnyObject>: GetSetPropertyDescriptor {
    public init<V: ValueConvertible>(_ name: String, attributes: napi_property_attributes = napi_default, keyPath: ReferenceWritableKeyPath<This, V>) {
        super.init(name,
                   attributes: attributes,
                   getter: { env, args in
                       try Wrap<This>.unwrap(env, jsObject: args.this)[keyPath: keyPath]
                   },
                   setter: { env, args in
                       try Wrap<This>.unwrap(env, jsObject: args.this)[keyPath: keyPath] = V(env, from: args.0)
                       return Undefined.default
                   })
    }

    public init(_ name: String, attributes: napi_property_attributes = napi_default, keyPath: KeyPath<This, some ValueConvertible>) {
        super.init(name,
                   attributes: attributes,
                   getter: { env, args in
                       try Wrap<This>.unwrap(env, jsObject: args.this)[keyPath: keyPath]
                   },
                   setter: nil)
    }

    public init(_ name: String, attributes: napi_property_attributes = napi_default, _ get: @escaping (_ this: isolated This) async throws -> some ValueConvertible) where This: Actor {
        super.init(name,
                   attributes: attributes,
                   getter: { env, args in
                       let this = try Wrap<This>.unwrap(env, jsObject: args.this)
                       return Promise {
                           try await get(this)
                       }
                   },
                   setter: nil)
    }
}
