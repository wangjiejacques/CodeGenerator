# CodeGenerator
CodeGenerator is a Xcode extension for swift code generation.

![alt tag](https://j.gifs.com/pgVEVr.gif)

## Generating mock

### Example:

```swift
protocol Pokemon {
    var height: Double! { get set }
    var canEvolve: Bool! { get }

    func eat(food: String)

    func drink(_ water: String)

    func isFlying() -> Bool

    func evolve(successHandler: @escaping (String) -> Void, failureHandler: (String?) -> String?)
}
```

```swift
class PokemonMock: Pokemon {
    var height: Double!
    var canEvolve: Bool!

    var eatFood: String?
    var drinkWater: String?
    var evolveShouldCallSuccessHandler = true
    var evolveSuccessHandlerParam0: String!
    var evolveShouldCallFailureHandler = true
    var evolveFailureHandlerParam0: String!
    var evolveFailureHandlerDidReturn: String?

    var eatFoodWasCalled: Bool?
    var drinkWasCalled: Bool?
    var isFlyingWasCalled: Bool?
    var evolveSuccessHandlerWasCalled: Bool?

    var isFlyingShouldReturn: Bool!

    func eat(food: String) {
        eatFood = food
        eatFoodWasCalled = true
    }

    func drink(_ water: String) {
        drinkWater = water
        drinkWasCalled = true
    }

    func isFlying() -> Bool {
        isFlyingWasCalled = true
        return isFlyingShouldReturn
    }

    func evolve(successHandler: @escaping (String) -> Void, failureHandler: (String?) -> String?) {
        if evolveShouldCallSuccessHandler {
            successHandler(evolveSuccessHandlerParam0)
        }
        if evolveShouldCallFailureHandler {
            evolveFailureHandlerDidReturn = failureHandler(evolveFailureHandlerParam0)
        }
        evolveSuccessHandlerWasCalled = true
    }

}
```

## Generating Equatable
### Example:
```swift
class EquatableClazz {
    var var0: Int!
    let var1: String
    var var2: Bool?
}
```

```swift
extension EquatableClazz: Equatable {
    static func ==(lhs: EquatableClazz, rhs: EquatableClazz) -> Bool {
        return lhs.var0 == rhs.var0 && lhs.var1 == rhs.var1 && lhs.var2 == rhs.var2
    }
}
```

if you don't want to use all the vars for the Equatable, just select the vars you want and click Generat... -> Equatable
