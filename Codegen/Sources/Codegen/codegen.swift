import SwiftSyntaxBuilder

@main
public enum Codegen {
    public static func main() {
        print(TypedFunction.generate().formatted())
    }
}

enum TypedFunction {
    static func generate() -> SourceFile {
        let source = SourceFile {
            ExtensionDecl("public extension Cool") {

            }
        }

        return source
    }
}
