import Foundation
import NAPIC

/// Here Be Dragons
public protocol ObjectConvertible: ValueConvertible {
    init()
}

public extension ObjectConvertible {
    init(_ populator: (inout Self) -> Void) {
        var new = Self()
        populator(&new)
        self = new
    }

    private var allProperties: [(label: String, prop: AnyProperty)] {
        let props = Mirror(reflecting: self).children.compactMap { child -> (String, AnyProperty)? in
            guard let label = child.label, let property = child.value as? AnyProperty else {
                return nil
            }

            return (String(label.suffix(from: label.index(after: label.startIndex))), property)
        }
        guard !props.isEmpty else {
            fatalError("an object with no @Property values defined is not allowed")
        }
        return props
    }

    init(_ env: Environment, from: napi_value) throws {
        try self.init(object: [String: AnyValue](env, from: from))
    }

    init(_ any: AnyValue) throws {
        try self.init(object: [String: AnyValue](any))
    }

    init(object: [String: AnyValue]) {
        self.init()
        for prop in allProperties {
            prop.prop.value = object[prop.label]!
        }
    }

    func napiValue(_ env: Environment) throws -> napi_value {
        try eraseToAny().napiValue(env)
    }

    func eraseToAny() throws -> AnyValue {
        var result = [String: AnyValue]()

        for prop in allProperties {
            result[prop.label] = prop.prop.value
        }

        return .object(result)
    }

    static var defaultValue: Self {
        Self()
    }
}

private protocol AnyProperty {
    var value: AnyValue { get nonmutating set }
}

@propertyWrapper
public struct ObjectProperty<Value: ValueConvertible>: AnyProperty {
    fileprivate class Storage {
        var value: Value = .defaultValue
    }

    fileprivate let storage = Storage()

    public init(wrappedValue: Value = .defaultValue) {
        storage.value = wrappedValue
    }

    public var wrappedValue: Value {
        get {
            storage.value
        }
        set {
            storage.value = newValue
        }
    }

    public var value: AnyValue {
        get { try! storage.value.eraseToAny() }
        nonmutating set { storage.value = try! Value(newValue) }
    }
}
