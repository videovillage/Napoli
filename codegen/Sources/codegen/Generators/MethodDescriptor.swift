import Foundation

enum Method {
    static func generate(maxParams: Int) throws -> Source {
        var source = Source()
        source.add("""
        // swiftformat:disable opaqueGenericParameters

        import Foundation
        import NAPIC

        public class MethodDescriptor: PropertyDescriptor {
            public let name: String
            public let attributes: napi_property_attributes
            private let callback: TypedFunctionCallback
            private let argCount: Int

            internal init(_ name: String, attributes: napi_property_attributes = napi_default, argCount: Int, _ callback: @escaping TypedFunctionCallback) {
                self.name = name
                self.attributes = attributes
                self.callback = callback
                self.argCount = argCount
            }

            public func propertyDescriptor(_ env: Environment) throws -> napi_property_descriptor {
                let _name = try name.napiValue(env)
                let data = TypedFunctionCallbackData(callback: callback, argCount: argCount)
                let dataPointer = Unmanaged.passRetained(data).toOpaque()
                return napi_property_descriptor(utf8name: nil, name: _name, method: typedFuncNAPICallback, getter: nil, setter: nil, value: nil, attributes: attributes, data: dataPointer)
            }
        }
        """)
        source.newline()

        for i in (0 ..< maxParams).reversed() {
            try generateExtension(source: &source, paramCount: i)
        }

        return source
    }

    static func generateExtension(source: inout Source, paramCount: Int) throws {
        let resultGeneric = Generic(type: "Result")
        let inGenerics = [Generic](prefix: "P", count: paramCount)
        let allGenerics = [resultGeneric] + inGenerics
        let wheres = allGenerics.conforming(to: Types.valueConvertible).value

        let commaSeparatedInGenerics = inGenerics.map(\.type).commaSeparated

        let voidWheres = inGenerics.conforming(to: Types.valueConvertible).value

        let argListAsParams: String
        if paramCount > 0 {
            argListAsParams = inGenerics.enumerated().map { "\($0.element.type)(env, from: args[\($0.offset)])" }.commaSeparated
        } else {
            argListAsParams = ""
        }

        let argListAssignedToValues: String
        if paramCount > 0 {
            argListAssignedToValues = inGenerics.enumerated().map { "let \($0.element.type.lowercased()) = try \($0.element.type)(env, from: args[\($0.offset)])" }.joined(separator: "; ")
        } else {
            argListAssignedToValues = ""
        }

        let argValueList = inGenerics.map { $0.type.lowercased() }.commaSeparated

        source.add("""
         // \(paramCount) param methods
         public extension MethodDescriptor {
             convenience init\(allGenerics.bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (\(commaSeparatedInGenerics)) throws -> Result)\(wheres.backspaceIfNotEmpty()) {
                 self.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                     try callback(\(argListAsParams))
                 }
             }

             convenience init\(inGenerics.bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (\(commaSeparatedInGenerics)) throws -> Void)\(voidWheres.backspaceIfNotEmpty()) {
                 self.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                     try callback(\(argListAsParams))
                     return Undefined.default
                 }
             }

              convenience init\(allGenerics.bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (Environment\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())) throws -> Result)\(wheres.backspaceIfNotEmpty()) {
                  self.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                      try callback(env\(argListAsParams.prefixCommaIfNotEmpty()))
                  }
              }

              convenience init\(inGenerics.bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (Environment\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())) throws -> Void)\(voidWheres.backspaceIfNotEmpty()) {
                  self.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                      try callback(env\(argListAsParams.prefixCommaIfNotEmpty()))
                      return Undefined.default
                  }
              }

             convenience init\(allGenerics.bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (\(commaSeparatedInGenerics)) async throws -> Result)\(wheres.backspaceIfNotEmpty()) {
                self.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                    \(argListAssignedToValues)
                    return Promise<Result> {
                         try await callback(\(argValueList))
                    }
                }
             }

             convenience init\(inGenerics.bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (\(commaSeparatedInGenerics)) async throws -> Void)\(voidWheres.backspaceIfNotEmpty()) {
                self.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                    \(argListAssignedToValues)
                    return Promise<Undefined> {
                        try await callback(\(argValueList))
                        return Undefined.default
                    }
                }
             }
         }
        """)
    }
}
