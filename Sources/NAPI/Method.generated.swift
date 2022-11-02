// swiftformat:disable opaqueGenericParameters

import Foundation
import NAPIC

public class Method: PropertyDescribable {
    public let name: String
    public let attributes: napi_property_attributes
    private let callback: TypedFunctionCallback
    private let argCount: Int

    fileprivate init(_ name: String, attributes: napi_property_attributes = napi_default, argCount: Int, _ callback: @escaping TypedFunctionCallback) {
        self.name = name
        self.attributes = attributes
        self.callback = callback
        self.argCount = argCount
    }

    public func propertyDescriptor(_ env: napi_env) throws -> napi_property_descriptor {
        let _name = try name.napiValue(env)
        let data = TypedFunctionCallbackData(callback: callback, argCount: argCount)
        let dataPointer = Unmanaged.passRetained(data).toOpaque()
        return napi_property_descriptor(utf8name: nil, name: _name, method: newNAPICallback, getter: nil, setter: nil, value: nil, attributes: attributes, data: dataPointer)
    }
}

// 9 param methods
public extension Method {
    convenience init<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>.ConvenienceCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 9) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]), P8(env, from: args[8]))
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>.ConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 9) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]), P8(env, from: args[8]))
            return Undefined.default
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8, R>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>.AsyncConvenienceCallback<R>) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible, R: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 9) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6]); let p7 = try P7(env, from: args[7]); let p8 = try P8(env, from: args[8])
            return Promise<R> {
                try await callback(p0, p1, p2, p3, p4, p5, p6, p7, p8)
            }
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>.AsyncConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 9) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6]); let p7 = try P7(env, from: args[7]); let p8 = try P8(env, from: args[8])
            return Promise<Undefined> {
                try await callback(p0, p1, p2, p3, p4, p5, p6, p7, p8)
                return Undefined.default
            }
        }
    }
}

// 8 param methods
public extension Method {
    convenience init<Result, P0, P1, P2, P3, P4, P5, P6, P7>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7>.ConvenienceCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 8) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]))
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4, P5, P6, P7>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7>.ConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 8) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]))
            return Undefined.default
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4, P5, P6, P7, R>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7>.AsyncConvenienceCallback<R>) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, R: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 8) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6]); let p7 = try P7(env, from: args[7])
            return Promise<R> {
                try await callback(p0, p1, p2, p3, p4, p5, p6, p7)
            }
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4, P5, P6, P7>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7>.AsyncConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 8) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6]); let p7 = try P7(env, from: args[7])
            return Promise<Undefined> {
                try await callback(p0, p1, p2, p3, p4, p5, p6, p7)
                return Undefined.default
            }
        }
    }
}

// 7 param methods
public extension Method {
    convenience init<Result, P0, P1, P2, P3, P4, P5, P6>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6>.ConvenienceCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 7) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]))
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4, P5, P6>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6>.ConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 7) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]))
            return Undefined.default
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4, P5, P6, R>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6>.AsyncConvenienceCallback<R>) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, R: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 7) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6])
            return Promise<R> {
                try await callback(p0, p1, p2, p3, p4, p5, p6)
            }
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4, P5, P6>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6>.AsyncConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 7) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6])
            return Promise<Undefined> {
                try await callback(p0, p1, p2, p3, p4, p5, p6)
                return Undefined.default
            }
        }
    }
}

// 6 param methods
public extension Method {
    convenience init<Result, P0, P1, P2, P3, P4, P5>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction6<Result, P0, P1, P2, P3, P4, P5>.ConvenienceCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 6) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]))
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4, P5>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction6<Result, P0, P1, P2, P3, P4, P5>.ConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 6) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]))
            return Undefined.default
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4, P5, R>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction6<Result, P0, P1, P2, P3, P4, P5>.AsyncConvenienceCallback<R>) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, R: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 6) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5])
            return Promise<R> {
                try await callback(p0, p1, p2, p3, p4, p5)
            }
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4, P5>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction6<Result, P0, P1, P2, P3, P4, P5>.AsyncConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 6) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5])
            return Promise<Undefined> {
                try await callback(p0, p1, p2, p3, p4, p5)
                return Undefined.default
            }
        }
    }
}

// 5 param methods
public extension Method {
    convenience init<Result, P0, P1, P2, P3, P4>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction5<Result, P0, P1, P2, P3, P4>.ConvenienceCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 5) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]))
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction5<Result, P0, P1, P2, P3, P4>.ConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 5) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]))
            return Undefined.default
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4, R>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction5<Result, P0, P1, P2, P3, P4>.AsyncConvenienceCallback<R>) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, R: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 5) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4])
            return Promise<R> {
                try await callback(p0, p1, p2, p3, p4)
            }
        }
    }

    convenience init<Result, P0, P1, P2, P3, P4>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction5<Result, P0, P1, P2, P3, P4>.AsyncConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 5) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4])
            return Promise<Undefined> {
                try await callback(p0, p1, p2, p3, p4)
                return Undefined.default
            }
        }
    }
}

// 4 param methods
public extension Method {
    convenience init<Result, P0, P1, P2, P3>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction4<Result, P0, P1, P2, P3>.ConvenienceCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 4) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]))
        }
    }

    convenience init<Result, P0, P1, P2, P3>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction4<Result, P0, P1, P2, P3>.ConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 4) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]))
            return Undefined.default
        }
    }

    convenience init<Result, P0, P1, P2, P3, R>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction4<Result, P0, P1, P2, P3>.AsyncConvenienceCallback<R>) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, R: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 4) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3])
            return Promise<R> {
                try await callback(p0, p1, p2, p3)
            }
        }
    }

    convenience init<Result, P0, P1, P2, P3>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction4<Result, P0, P1, P2, P3>.AsyncConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 4) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3])
            return Promise<Undefined> {
                try await callback(p0, p1, p2, p3)
                return Undefined.default
            }
        }
    }
}

// 3 param methods
public extension Method {
    convenience init<Result, P0, P1, P2>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction3<Result, P0, P1, P2>.ConvenienceCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 3) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]))
        }
    }

    convenience init<Result, P0, P1, P2>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction3<Result, P0, P1, P2>.ConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 3) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]))
            return Undefined.default
        }
    }

    convenience init<Result, P0, P1, P2, R>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction3<Result, P0, P1, P2>.AsyncConvenienceCallback<R>) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, R: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 3) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2])
            return Promise<R> {
                try await callback(p0, p1, p2)
            }
        }
    }

    convenience init<Result, P0, P1, P2>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction3<Result, P0, P1, P2>.AsyncConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 3) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2])
            return Promise<Undefined> {
                try await callback(p0, p1, p2)
                return Undefined.default
            }
        }
    }
}

// 2 param methods
public extension Method {
    convenience init<Result, P0, P1>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction2<Result, P0, P1>.ConvenienceCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 2) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]))
        }
    }

    convenience init<Result, P0, P1>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction2<Result, P0, P1>.ConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 2) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]))
            return Undefined.default
        }
    }

    convenience init<Result, P0, P1, R>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction2<Result, P0, P1>.AsyncConvenienceCallback<R>) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, R: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 2) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1])
            return Promise<R> {
                try await callback(p0, p1)
            }
        }
    }

    convenience init<Result, P0, P1>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction2<Result, P0, P1>.AsyncConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 2) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1])
            return Promise<Undefined> {
                try await callback(p0, p1)
                return Undefined.default
            }
        }
    }
}

// 1 param methods
public extension Method {
    convenience init<Result, P0>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction1<Result, P0>.ConvenienceCallback) where Result: ValueConvertible, P0: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 1) { env, _, args in
            try callback(P0(env, from: args[0]))
        }
    }

    convenience init<Result, P0>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction1<Result, P0>.ConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 1) { env, _, args in
            try callback(P0(env, from: args[0]))
            return Undefined.default
        }
    }

    convenience init<Result, P0, R>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction1<Result, P0>.AsyncConvenienceCallback<R>) where Result: ValueConvertible, P0: ValueConvertible, R: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 1) { env, _, args in
            let p0 = try P0(env, from: args[0])
            return Promise<R> {
                try await callback(p0)
            }
        }
    }

    convenience init<Result, P0>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction1<Result, P0>.AsyncConvenienceVoidCallback) where Result: ValueConvertible, P0: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 1) { env, _, args in
            let p0 = try P0(env, from: args[0])
            return Promise<Undefined> {
                try await callback(p0)
                return Undefined.default
            }
        }
    }
}

// 0 param methods
public extension Method {
    convenience init<Result>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction0<Result>.ConvenienceCallback) where Result: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 0) { _, _, _ in
            try callback()
        }
    }

    convenience init<Result>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction0<Result>.ConvenienceVoidCallback) where Result: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 0) { _, _, _ in
            try callback()
            return Undefined.default
        }
    }

    convenience init<Result, R>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction0<Result>.AsyncConvenienceCallback<R>) where Result: ValueConvertible, R: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 0) { _, _, _ in

            Promise<R> {
                try await callback()
            }
        }
    }

    convenience init<Result>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping TypedFunction0<Result>.AsyncConvenienceVoidCallback) where Result: ValueConvertible {
        self.init(name, attributes: attributes, argCount: 0) { _, _, _ in

            Promise<Undefined> {
                try await callback()
                return Undefined.default
            }
        }
    }
}
