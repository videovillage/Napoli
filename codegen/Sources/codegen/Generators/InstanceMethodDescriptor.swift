import Foundation

enum InstanceMethod {
    static func generate(maxParams: Int) throws -> Source {
        var source = Source()

        source.add("""
        // swiftformat:disable opaqueGenericParameters

        import Foundation
        import NAPIC
        """)
        source.newline()

        try source.declareClass(.public, "InstanceMethodDescriptor", genericParams: [.init(type: "This")], conformsTo: "MethodDescriptor", wheres: [.conforms("This", "AnyObject")]) { source in
            for i in (0 ..< maxParams).reversed() {
                try generateMethods(source: &source, paramCount: i)
                // try generateActorMethods(source: &source, paramCount: i)
            }
        }

        return source
    }

    static func generateMethods(source: inout Source, paramCount: Int) throws {
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
          public init\(allGenerics.bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (\(commaSeparatedInGenerics)) throws -> Result)\(wheres.backspaceIfNotEmpty()) {
              super.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                  let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
                  return try callback(\(argListAsParams))
              }
          }

          public init\(inGenerics.bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (\(commaSeparatedInGenerics)) throws -> Void)\(voidWheres.backspaceIfNotEmpty()) {
              super.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                  let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
                  try callback(\(argListAsParams))
                  return Undefined.default
              }
          }

           public init\(allGenerics.bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (Environment\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())) throws -> Result)\(wheres.backspaceIfNotEmpty()) {
               super.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                   let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
                   return try callback(env\(argListAsParams.prefixCommaIfNotEmpty()))
               }
           }

           public init\(inGenerics.bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (Environment\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())) throws -> Void)\(voidWheres.backspaceIfNotEmpty()) {
               super.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                   let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
                   try callback(env\(argListAsParams.prefixCommaIfNotEmpty()))
                   return Undefined.default
               }
           }

          public init\(allGenerics.bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (\(commaSeparatedInGenerics)) async throws -> Result)\(wheres.backspaceIfNotEmpty()) {
             super.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                 \(argListAssignedToValues)
                 let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
                 return Promise<Result> {
                      try await callback(\(argValueList))
                 }
             }
          }

          public init\(inGenerics.bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (\(commaSeparatedInGenerics)) async throws -> Void)\(voidWheres.backspaceIfNotEmpty()) {
             super.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                 \(argListAssignedToValues)
                 let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
                 return VoidPromise {
                     try await callback(\(argValueList))
                     return Undefined.default
                 }
             }
          }
        """)
    }

    static func generateActorMethods(source: inout Source, paramCount: Int) throws {
        let resultGeneric = Generic(type: "Result")
        let thisGeneric = Generic(type: "ThisActor")
        let thisConformance = Where.conforms(thisGeneric.type, "Actor")
        let inGenerics = [Generic](prefix: "P", count: paramCount)
        let allGenerics = [resultGeneric] + inGenerics
        let wheres = (allGenerics.conforming(to: Types.valueConvertible) + [thisConformance]).value

        let commaSeparatedInGenerics = inGenerics.map(\.type).commaSeparated

        let voidWheres = (inGenerics.conforming(to: Types.valueConvertible) + [thisConformance]).value

        let argListAssignedToValues: String
        if paramCount > 0 {
            argListAssignedToValues = inGenerics.enumerated().map { "let \($0.element.type.lowercased()) = try \($0.element.type)(env, from: args[\($0.offset)])" }.joined(separator: "; ")
        } else {
            argListAssignedToValues = ""
        }

        let argValueList = inGenerics.map { $0.type.lowercased() }.commaSeparated

        source.add("""
          // \(paramCount) param methods
          public init\((allGenerics + [thisGeneric]).bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: isolated ThisActor) -> @Sendable (\(commaSeparatedInGenerics)) throws -> Result)\(wheres.backspaceIfNotEmpty()) {
             super.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                 \(argListAssignedToValues)
                 let this = try Wrap<ThisActor>.unwrap(env, jsObject: this)
                 return Promise<Result> {
                      return try await callback(this)(\(argValueList))
                 }
             }
          }

          public init\((inGenerics + [thisGeneric]).bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: isolated ThisActor) -> @Sendable (\(commaSeparatedInGenerics)) throws -> Void)\(voidWheres.backspaceIfNotEmpty()) {
             super.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                 \(argListAssignedToValues)
                 let this = try Wrap<ThisActor>.unwrap(env, jsObject: this)
                 return VoidPromise {
                     try await callback(this)(\(argValueList))
                     return Undefined.default
                 }
             }
          }

          public init\((allGenerics + [thisGeneric]).bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: isolated ThisActor) -> @Sendable (\(commaSeparatedInGenerics)) async throws -> Result)\(wheres.backspaceIfNotEmpty()) {
             super.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                 \(argListAssignedToValues)
                 let this = try Wrap<ThisActor>.unwrap(env, jsObject: this)
                 return Promise<Result> {
                      return try await callback(this)(\(argValueList))
                 }
             }
          }

          public init\((inGenerics + [thisGeneric]).bracketedOrNone)(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: isolated ThisActor) -> @Sendable (\(commaSeparatedInGenerics)) async throws -> Void)\(voidWheres.backspaceIfNotEmpty()) {
             super.init(name, attributes: attributes, argCount: \(paramCount)) { env, this, args in
                 \(argListAssignedToValues)
                 let this = try Wrap<ThisActor>.unwrap(env, jsObject: this)
                 return VoidPromise {
                     try await callback(this)(\(argValueList))
                     return Undefined.default
                 }
             }
          }
        """)
    }
}
