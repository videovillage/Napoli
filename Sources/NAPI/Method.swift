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

public extension Method {
    typealias Callback0<Result> = TypedFunction0<Result>.Callback where Result: ValueConvertible
    typealias VoidCallback0 = TypedFunction0<Undefined>.VoidCallback

    typealias Callback1<Result, P0> = TypedFunction1<Result, P0>.Callback where Result: ValueConvertible, P0: ValueConvertible
    typealias VoidCallback1<P0> = TypedFunction1<Undefined, P0>.VoidCallback where P0: ValueConvertible

    convenience init(name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping Callback0<some Any>) {
        self.init(name: name, attributes: attributes) { _, _ in
            try callback()
        }
    }

    convenience init(name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping VoidCallback0) {
        self.init(name: name, attributes: attributes) { _, _ in
            try callback()
            return Undefined.default
        }
    }

    convenience init<P0>(name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction1<some Any, P0>.Callback) {
        self.init(name: name, attributes: attributes) { env, args in
            try callback(P0(env, from: args.0))
        }
    }

    convenience init<P0, P1>(name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction2<some Any, P0, P1>.Callback) {
        self.init(name: name, attributes: attributes) { env, args in
            try callback(P0(env, from: args.0), P1(env, from: args.1))
        }
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
