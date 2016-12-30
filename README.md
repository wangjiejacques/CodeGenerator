# CodeGenerator
CodeGenerator is a Xcode extension for swift code generation.

## Generating mock
![alt tag](https://j.gifs.com/pgVEVr.gif)

## Generating Equatable
```
class EquatableClazz {
    var var0: Int!
    let var1: String
    var var2: Bool?
}
```

```
extension EquatableClazz: Equatable {
    static func ==(lhs: EquatableClazz, rhs: EquatableClazz) -> Bool {
        return lhs.var0 == rhs.var0 && lhs.var1 == rhs.var1 && lhs.var2 == rhs.var2
    }
}
```

And also, if you don't want to use all the vars for the Equatable, just select the vars you want and click Generat... -> Equatable
