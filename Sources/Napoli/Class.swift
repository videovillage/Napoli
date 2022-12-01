import NAPIC

private func defineClass(_ env: Environment, named name: String, _ constructor: @escaping Callback, _ props: [napi_property_descriptor]) throws -> napi_value {
    var result: napi_value?
    let nameData = name.data(using: .utf8)!
    let propCount = props.count

    let data = CallbackData(callback: constructor)
    let unmanagedData = Unmanaged.passRetained(data)

    do {
        try nameData.withUnsafeBytes { nameBytes in
            props.withUnsafeBufferPointer { propertiesBytes in
                napi_define_class(env.env, nameBytes.baseAddress?.assumingMemoryBound(to: UInt8.self), nameBytes.count, swiftNAPICallback, unmanagedData.toOpaque(), propCount, propertiesBytes.baseAddress, &result)
            }
        }.throwIfError()
    } catch {
        unmanagedData.release()
        throw error
    }

    return result!
}

private enum InternalClass {
    case swift(String, Callback, [PropertyDescriptor])
    case javascript(napi_value)
}

public class Class: ValueConvertible {
    fileprivate let value: InternalClass

    public required init(_: Environment, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ constructor: @escaping Callback, _ properties: [PropertyDescriptor]) {
        value = .swift(name, constructor, properties)
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        switch value {
        case let .swift(name, constructor, properties): return try defineClass(env, named: name, constructor, properties.map { try $0.propertyDescriptor(env) })
        case let .javascript(value): return value
        }
    }
}

/// The name of the class exposed in JavaScript will be the same name as the Swift class by default, but can be overriden using the static `jsName` property.
public protocol ClassDescribable: AnyObject {
    init()
    static var jsName: String { get }
    static var jsInstanceProperties: [InstanceGetSetPropertyDescriptor<Self>] { get }
    static var jsInstanceMethods: [InstanceMethodDescriptor<Self>] { get }
    static var jsAttributes: napi_property_attributes { get }
}

public extension ClassDescribable {
    static var jsName: String {
        String(describing: Self.self)
    }
}

public extension ClassDescribable {
    static var jsAttributes: napi_property_attributes {
        napi_default
    }
}

public struct ClassDescriptor: PropertyDescriptor {
    public var name: String {
        value.name
    }

    public var attributes: napi_property_attributes {
        value.attributes
    }

    private let value: ValueProperty

    public init<C: ClassDescribable>(_: C.Type) {
        value = .init(C.jsName,
                      attributes: C.jsAttributes,
                      value: Class(named: C.jsName, { env, args in
                          let native = C()
                          try Wrap<C>.wrap(env, jsObject: args.this, nativeObject: native)
                          return Undefined.default
                      }, C.jsInstanceProperties + C.jsInstanceMethods))
    }

    public func propertyDescriptor(_ env: Environment) throws -> napi_property_descriptor {
        try value.propertyDescriptor(env)
    }
}
