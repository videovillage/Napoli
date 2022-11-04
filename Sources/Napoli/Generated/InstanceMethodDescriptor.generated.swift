// swiftformat:disable opaqueGenericParameters

import Foundation
import NAPIC

public class InstanceMethodDescriptor<This>: MethodDescriptor where This: AnyObject {
      // 9 param methods
      public init<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5, P6, P7, P8) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 9) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              return try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]), P8(env, from: args[8]))
          }
      }
    
      public init<P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5, P6, P7, P8) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 9) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]), P8(env, from: args[8]))
              return Undefined.default
          }
      }
    
       public init<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2, P3, P4, P5, P6, P7, P8) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 9) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               return try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]), P8(env, from: args[8]))
           }
       }
    
       public init<P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2, P3, P4, P5, P6, P7, P8) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 9) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]), P8(env, from: args[8]))
               return Undefined.default
           }
       }
    
      public init<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5, P6, P7, P8) async throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 9) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6]); let p7 = try P7(env, from: args[7]); let p8 = try P8(env, from: args[8])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Result> {
                  try await callback(p0, p1, p2, p3, p4, p5, p6, p7, p8)
             }
         }
      }
    
      public init<P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5, P6, P7, P8) async throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 9) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6]); let p7 = try P7(env, from: args[7]); let p8 = try P8(env, from: args[8])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Undefined> {
                 try await callback(p0, p1, p2, p3, p4, p5, p6, p7, p8)
                 return Undefined.default
             }
         }
      }
      // 8 param methods
      public init<Result, P0, P1, P2, P3, P4, P5, P6, P7>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 8) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              return try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]))
          }
      }
    
      public init<P0, P1, P2, P3, P4, P5, P6, P7>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 8) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]))
              return Undefined.default
          }
      }
    
       public init<Result, P0, P1, P2, P3, P4, P5, P6, P7>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 8) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               return try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]))
           }
       }
    
       public init<P0, P1, P2, P3, P4, P5, P6, P7>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 8) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]))
               return Undefined.default
           }
       }
    
      public init<Result, P0, P1, P2, P3, P4, P5, P6, P7>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5, P6, P7) async throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 8) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6]); let p7 = try P7(env, from: args[7])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Result> {
                  try await callback(p0, p1, p2, p3, p4, p5, p6, p7)
             }
         }
      }
    
      public init<P0, P1, P2, P3, P4, P5, P6, P7>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5, P6, P7) async throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 8) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6]); let p7 = try P7(env, from: args[7])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Undefined> {
                 try await callback(p0, p1, p2, p3, p4, p5, p6, p7)
                 return Undefined.default
             }
         }
      }
      // 7 param methods
      public init<Result, P0, P1, P2, P3, P4, P5, P6>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5, P6) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 7) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              return try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]))
          }
      }
    
      public init<P0, P1, P2, P3, P4, P5, P6>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5, P6) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 7) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]))
              return Undefined.default
          }
      }
    
       public init<Result, P0, P1, P2, P3, P4, P5, P6>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2, P3, P4, P5, P6) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 7) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               return try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]))
           }
       }
    
       public init<P0, P1, P2, P3, P4, P5, P6>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2, P3, P4, P5, P6) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 7) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]))
               return Undefined.default
           }
       }
    
      public init<Result, P0, P1, P2, P3, P4, P5, P6>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5, P6) async throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 7) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Result> {
                  try await callback(p0, p1, p2, p3, p4, p5, p6)
             }
         }
      }
    
      public init<P0, P1, P2, P3, P4, P5, P6>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5, P6) async throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 7) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Undefined> {
                 try await callback(p0, p1, p2, p3, p4, p5, p6)
                 return Undefined.default
             }
         }
      }
      // 6 param methods
      public init<Result, P0, P1, P2, P3, P4, P5>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 6) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              return try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]))
          }
      }
    
      public init<P0, P1, P2, P3, P4, P5>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 6) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]))
              return Undefined.default
          }
      }
    
       public init<Result, P0, P1, P2, P3, P4, P5>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2, P3, P4, P5) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 6) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               return try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]))
           }
       }
    
       public init<P0, P1, P2, P3, P4, P5>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2, P3, P4, P5) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 6) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]))
               return Undefined.default
           }
       }
    
      public init<Result, P0, P1, P2, P3, P4, P5>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5) async throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 6) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Result> {
                  try await callback(p0, p1, p2, p3, p4, p5)
             }
         }
      }
    
      public init<P0, P1, P2, P3, P4, P5>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4, P5) async throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 6) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Undefined> {
                 try await callback(p0, p1, p2, p3, p4, p5)
                 return Undefined.default
             }
         }
      }
      // 5 param methods
      public init<Result, P0, P1, P2, P3, P4>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 5) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              return try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]))
          }
      }
    
      public init<P0, P1, P2, P3, P4>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 5) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]))
              return Undefined.default
          }
      }
    
       public init<Result, P0, P1, P2, P3, P4>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2, P3, P4) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 5) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               return try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]))
           }
       }
    
       public init<P0, P1, P2, P3, P4>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2, P3, P4) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 5) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]))
               return Undefined.default
           }
       }
    
      public init<Result, P0, P1, P2, P3, P4>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4) async throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 5) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Result> {
                  try await callback(p0, p1, p2, p3, p4)
             }
         }
      }
    
      public init<P0, P1, P2, P3, P4>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3, P4) async throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 5) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Undefined> {
                 try await callback(p0, p1, p2, p3, p4)
                 return Undefined.default
             }
         }
      }
      // 4 param methods
      public init<Result, P0, P1, P2, P3>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 4) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              return try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]))
          }
      }
    
      public init<P0, P1, P2, P3>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 4) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]))
              return Undefined.default
          }
      }
    
       public init<Result, P0, P1, P2, P3>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2, P3) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 4) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               return try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]))
           }
       }
    
       public init<P0, P1, P2, P3>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2, P3) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 4) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]))
               return Undefined.default
           }
       }
    
      public init<Result, P0, P1, P2, P3>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3) async throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 4) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Result> {
                  try await callback(p0, p1, p2, p3)
             }
         }
      }
    
      public init<P0, P1, P2, P3>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2, P3) async throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 4) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Undefined> {
                 try await callback(p0, p1, p2, p3)
                 return Undefined.default
             }
         }
      }
      // 3 param methods
      public init<Result, P0, P1, P2>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 3) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              return try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]))
          }
      }
    
      public init<P0, P1, P2>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 3) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]))
              return Undefined.default
          }
      }
    
       public init<Result, P0, P1, P2>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 3) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               return try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]))
           }
       }
    
       public init<P0, P1, P2>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1, P2) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 3) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]))
               return Undefined.default
           }
       }
    
      public init<Result, P0, P1, P2>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2) async throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 3) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Result> {
                  try await callback(p0, p1, p2)
             }
         }
      }
    
      public init<P0, P1, P2>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1, P2) async throws -> Void) where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 3) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Undefined> {
                 try await callback(p0, p1, p2)
                 return Undefined.default
             }
         }
      }
      // 2 param methods
      public init<Result, P0, P1>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 2) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              return try callback(P0(env, from: args[0]), P1(env, from: args[1]))
          }
      }
    
      public init<P0, P1>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 2) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              try callback(P0(env, from: args[0]), P1(env, from: args[1]))
              return Undefined.default
          }
      }
    
       public init<Result, P0, P1>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 2) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               return try callback(env, P0(env, from: args[0]), P1(env, from: args[1]))
           }
       }
    
       public init<P0, P1>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0, P1) throws -> Void) where P0: ValueConvertible, P1: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 2) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               try callback(env, P0(env, from: args[0]), P1(env, from: args[1]))
               return Undefined.default
           }
       }
    
      public init<Result, P0, P1>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1) async throws -> Result) where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 2) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Result> {
                  try await callback(p0, p1)
             }
         }
      }
    
      public init<P0, P1>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0, P1) async throws -> Void) where P0: ValueConvertible, P1: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 2) { env, this, args in
             let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Undefined> {
                 try await callback(p0, p1)
                 return Undefined.default
             }
         }
      }
      // 1 param methods
      public init<Result, P0>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 1) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              return try callback(P0(env, from: args[0]))
          }
      }
    
      public init<P0>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0) throws -> Void) where P0: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 1) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              try callback(P0(env, from: args[0]))
              return Undefined.default
          }
      }
    
       public init<Result, P0>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0) throws -> Result) where Result: ValueConvertible, P0: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 1) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               return try callback(env, P0(env, from: args[0]))
           }
       }
    
       public init<P0>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env, P0) throws -> Void) where P0: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 1) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               try callback(env, P0(env, from: args[0]))
               return Undefined.default
           }
       }
    
      public init<Result, P0>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0) async throws -> Result) where Result: ValueConvertible, P0: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 1) { env, this, args in
             let p0 = try P0(env, from: args[0])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Result> {
                  try await callback(p0)
             }
         }
      }
    
      public init<P0>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (P0) async throws -> Void) where P0: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 1) { env, this, args in
             let p0 = try P0(env, from: args[0])
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Undefined> {
                 try await callback(p0)
                 return Undefined.default
             }
         }
      }
      // 0 param methods
      public init<Result>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> () throws -> Result) where Result: ValueConvertible {
          super.init(name, attributes: attributes, argCount: 0) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              return try callback()
          }
      }
    
      public init(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> () throws -> Void) {
          super.init(name, attributes: attributes, argCount: 0) { env, this, args in
              let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
              try callback()
              return Undefined.default
          }
      }
    
       public init<Result>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env) throws -> Result) where Result: ValueConvertible {
           super.init(name, attributes: attributes, argCount: 0) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               return try callback(env)
           }
       }
    
       public init(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> (napi_env) throws -> Void) {
           super.init(name, attributes: attributes, argCount: 0) { env, this, args in
               let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
               try callback(env)
               return Undefined.default
           }
       }
    
      public init<Result>(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> () async throws -> Result) where Result: ValueConvertible {
         super.init(name, attributes: attributes, argCount: 0) { env, this, args in
             
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Result> {
                  try await callback()
             }
         }
      }
    
      public init(_ name: String, attributes: napi_property_attributes = napi_default, _ callback: @escaping (_ this: This) -> () async throws -> Void) {
         super.init(name, attributes: attributes, argCount: 0) { env, this, args in
             
             let callback = try callback(Wrap<This>.unwrap(env, jsObject: this))
             return Promise<Undefined> {
                 try await callback()
                 return Undefined.default
             }
         }
      }
}
