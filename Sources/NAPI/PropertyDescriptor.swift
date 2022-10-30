import Foundation
import NAPIC

private enum InternalPropertyDescriptor {
    case getSet(String, getter: Callback, setter: Callback? = nil, napi_property_attributes)
    case method(String, Callback, napi_property_attributes)
    case value(String, ValueConvertible, napi_property_attributes)
}

public struct PropertyDescriptor {
    fileprivate let value: InternalPropertyDescriptor

    private init(_ value: InternalPropertyDescriptor) {
        self.value = value
    }

    func value(_ env: napi_env) throws -> napi_property_descriptor {
        switch value {
        case let .getSet(name, getter, setter, attributes):
            let _name = try name.napiValue(env)
            let data = GetSetCallbackData(getter: getter, setter: setter)
            let dataPointer = Unmanaged.passRetained(data).toOpaque()
            return napi_property_descriptor(utf8name: nil, name: _name, method: nil, getter: swiftNAPIGetterCallback, setter: setter != nil ? swiftNAPISetterCallback : nil, value: nil, attributes: attributes, data: dataPointer)
        case let .method(name, callback, attributes):
            let _name = try name.napiValue(env)
            let data = CallbackData(callback: callback)
            let dataPointer = Unmanaged.passRetained(data).toOpaque()
            return napi_property_descriptor(utf8name: nil, name: _name, method: swiftNAPICallback, getter: nil, setter: nil, value: nil, attributes: attributes, data: dataPointer)
        case let .value(name, value, attributes):
            let _name = try name.napiValue(env)
            let _value = try value.napiValue(env)
            return napi_property_descriptor(utf8name: nil, name: _name, method: nil, getter: nil, setter: nil, value: _value, attributes: attributes, data: nil)
        }
    }

    public static func value(_ name: String, _ value: ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.value(name, value, attributes))
    }

    public static func `class`<This: AnyObject>(_ name: String, _ constructor: @escaping () throws -> This, _ properties: [PropertyDescriptor], attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.value(name, Class(named: name, { env, args in let native = try constructor(); try Wrap<This>.wrap(env, jsObject: args.this, nativeObject: native); return nil }, properties), attributes))
    }

    public static func `class`<This: AnyObject>(_ name: String, _ constructor: @escaping (napi_env) throws -> This, _ properties: [PropertyDescriptor], attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.value(name, Class(named: name, { env, args in let native = try constructor(env); try Wrap<This>.wrap(env, jsObject: args.this, nativeObject: native); return nil }, properties), attributes))
    }

    public static func `class`<This: JSClassDefinable>(_: This.Type) -> PropertyDescriptor {
        .class(This.jsName, { env in This(env: env) }, This.jsProperties + This.jsFunctions, attributes: This.jsAttributes)
    }

    /* (...) -> Void */

    public static func function(_ name: String, _ callback: @escaping () throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { _, _ in try callback(); return Value.undefined }, attributes))
    }

    public static func function<A: ValueConvertible>(_ name: String, _ callback: @escaping (A) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(A(env, from: args.0)); return Value.undefined }, attributes))
    }

    public static func function<A: ValueConvertible, B: ValueConvertible>(_ name: String, _ callback: @escaping (A, B) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(A(env, from: args.0), B(env, from: args.1)); return Value.undefined }, attributes))
    }

    public static func function(_ name: String, _ callback: @escaping (napi_env) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, _ in try callback(env); return Value.undefined }, attributes))
    }

    public static func function<A: ValueConvertible>(_ name: String, _ callback: @escaping (napi_env, A) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(env, A(env, from: args.0)); return Value.undefined }, attributes))
    }

    public static func function<A: ValueConvertible, B: ValueConvertible>(_ name: String, _ callback: @escaping (napi_env, A, B) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(env, A(env, from: args.0), B(env, from: args.1)); return Value.undefined }, attributes))
    }

    /* (...) -> ValueConvertible */

    public static func function(_ name: String, _ callback: @escaping () throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { _, _ in try callback() }, attributes))
    }

    public static func function<A: ValueConvertible>(_ name: String, _ callback: @escaping (A) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(A(env, from: args.0)) }, attributes))
    }

    public static func function<A: ValueConvertible, B: ValueConvertible>(_ name: String, _ callback: @escaping (A, B) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(A(env, from: args.0), B(env, from: args.1)) }, attributes))
    }

    public static func function(_ name: String, _ callback: @escaping (napi_env) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, _ in try callback(env) }, attributes))
    }

    public static func function<A: ValueConvertible>(_ name: String, _ callback: @escaping (napi_env, A) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(env, A(env, from: args.0)) }, attributes))
    }

    public static func function<A: ValueConvertible, B: ValueConvertible>(_ name: String, _ callback: @escaping (napi_env, A, B) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(env, A(env, from: args.0), B(env, from: args.1)) }, attributes))
    }

    /* (this, ...) -> Void */

    public static func instanceMethod<This: AnyObject>(_ name: String, _ callback: @escaping (This) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(Wrap<This>.unwrap(env, jsObject: args.this)); return Value.undefined }, attributes))
    }

    public static func instanceMethod<This: AnyObject, A: ValueConvertible>(_ name: String, _ callback: @escaping (This, A) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(Wrap<This>.unwrap(env, jsObject: args.this), A(env, from: args.0)); return Value.undefined }, attributes))
    }

    public static func instanceMethod<This: AnyObject, A: ValueConvertible, B: ValueConvertible>(_ name: String, _ callback: @escaping (This, A, B) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(Wrap<This>.unwrap(env, jsObject: args.this), A(env, from: args.0), B(env, from: args.1)); return Value.undefined }, attributes))
    }

    public static func instanceMethod<This: AnyObject>(_ name: String, _ callback: @escaping (napi_env, This) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(env, Wrap<This>.unwrap(env, jsObject: args.this)); return Value.undefined }, attributes))
    }

    public static func instanceMethod<This: AnyObject, A: ValueConvertible>(_ name: String, _ callback: @escaping (napi_env, This, A) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(env, Wrap<This>.unwrap(env, jsObject: args.this), A(env, from: args.0)); return Value.undefined }, attributes))
    }

    public static func instanceMethod<This: AnyObject, A: ValueConvertible, B: ValueConvertible>(_ name: String, _ callback: @escaping (napi_env, This, A, B) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(env, Wrap<This>.unwrap(env, jsObject: args.this), A(env, from: args.0), B(env, from: args.1)); return Value.undefined }, attributes))
    }

    /* (this, ...) -> ValueConvertible */

    public static func instanceMethod<This: AnyObject>(_ name: String, _ callback: @escaping (This) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(Wrap<This>.unwrap(env, jsObject: args.this)) }, attributes))
    }

    public static func instanceMethod<This: AnyObject, A: ValueConvertible>(_ name: String, _ callback: @escaping (This, A) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(Wrap<This>.unwrap(env, jsObject: args.this), A(env, from: args.0)) }, attributes))
    }

    public static func instanceMethod<This: AnyObject, A: ValueConvertible, B: ValueConvertible>(_ name: String, _ callback: @escaping (This, A, B) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(Wrap<This>.unwrap(env, jsObject: args.this), A(env, from: args.0), B(env, from: args.1)) }, attributes))
    }

    public static func instanceMethod<This: AnyObject>(_ name: String, _ callback: @escaping (napi_env, This) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(env, Wrap<This>.unwrap(env, jsObject: args.this)) }, attributes))
    }

    public static func instanceMethod<This: AnyObject, A: ValueConvertible>(_ name: String, _ callback: @escaping (napi_env, This, A) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(env, Wrap<This>.unwrap(env, jsObject: args.this), A(env, from: args.0)) }, attributes))
    }

    public static func instanceMethod<This: AnyObject, A: ValueConvertible, B: ValueConvertible>(_ name: String, _ callback: @escaping (napi_env, This, A, B) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.method(name, { env, args in try callback(env, Wrap<This>.unwrap(env, jsObject: args.this), A(env, from: args.0), B(env, from: args.1)) }, attributes))
    }

    /* Instance Properties */

    public static func instancePropertyReadOnly<This: AnyObject, A: ValueConvertible>(_ name: String, getter: @escaping (This) throws -> A, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.getSet(name, getter: { env, args in try getter(Wrap<This>.unwrap(env, jsObject: args.this)) }, attributes))
    }

    public static func instanceProperty<This: AnyObject, A: ValueConvertible>(_ name: String, getter: @escaping (This) throws -> A, setter: @escaping (This, A) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.getSet(name,
                      getter: { env, args in try getter(Wrap<This>.unwrap(env, jsObject: args.this)) },
                      setter: { env, args in try setter(Wrap<This>.unwrap(env, jsObject: args.this), A(env, from: args.0)); return Value.undefined },
                      attributes))
    }

    public static func instancePropertyReadOnly<This: AnyObject, A: ValueConvertible>(_ name: String, keyPath: KeyPath<This, A>, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .instancePropertyReadOnly(name, getter: { (obj: This) in obj[keyPath: keyPath] }, attributes: attributes)
    }

    public static func instanceProperty<This: AnyObject, A: ValueConvertible>(_ name: String, keyPath: ReferenceWritableKeyPath<This, A>, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .instanceProperty(name,
                          getter: { (obj: This) in obj[keyPath: keyPath] },
                          setter: { (obj: This, new: A) in obj[keyPath: keyPath] = new },
                          attributes: attributes)
    }

    public static func propertyReadOnly<A: ValueConvertible>(_ name: String, getter: @escaping () throws -> A, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.getSet(name, getter: { _, _ in try getter() }, attributes))
    }

    public static func property<A: ValueConvertible>(_ name: String, getter: @escaping () throws -> A, setter: @escaping (A) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        .init(.getSet(name,
                      getter: { _, _ in try getter() },
                      setter: { env, args in try setter(A(env, from: args.0)); return nil },
                      attributes))
    }
}
