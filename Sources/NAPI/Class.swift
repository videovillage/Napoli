import NAPIC

private func defineClass(_ env: napi_env, named name: String, _ constructor: @escaping Callback, _ properties: [PropertyDescriptor]) throws -> napi_value {
    var result: napi_value?
    let nameData = name.data(using: .utf8)!
    let props = try properties.map { try $0.value(env) }

    let data = CallbackData(callback: constructor)
    let unmanagedData = Unmanaged.passRetained(data)

    do {
        try nameData.withUnsafeBytes { nameBytes in
            props.withUnsafeBufferPointer { propertiesBytes in
                napi_define_class(env, nameBytes.baseAddress?.assumingMemoryBound(to: UInt8.self), nameBytes.count, swiftNAPICallback, unmanagedData.toOpaque(), properties.count, propertiesBytes.baseAddress, &result)
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

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ constructor: @escaping Callback, _ properties: [PropertyDescriptor]) {
        value = .swift(name, constructor, properties)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, constructor, properties): return try defineClass(env, named: name, constructor, properties)
        case let .javascript(value): return value
        }
    }
}

public protocol JSClassDefinable: AnyObject {
    init(env: napi_env)
    static var jsName: String { get }
    static var jsProperties: [PropertyDescriptor] { get }
    static var jsFunctions: [PropertyDescriptor] { get }
    static var jsAttributes: napi_property_attributes { get }
}
