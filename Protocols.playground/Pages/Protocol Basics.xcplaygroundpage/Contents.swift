import Foundation

//: # Protocols
//: Protocols are, as per Apple's definition in the _Swift Programming Language_ book:
//:
//: "... a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality. The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements. Any type that satisfies the requirements of a protocol is said to conform to that protocol."
//:
//: The below example shows a protocol that requires conforming types have a particular property defined.

//Getter = Read access
//Setter = Write access
protocol fullyNamed {
    var fullName: String { get }
}
    // 1.) Adoption
    //2.) Conformance
    struct Person: fullyNamed {
        var fullName: String
        
    }

let jonhnny = Person(fullName: "Johnny Bravo")

let ben = Person(fullName: "Ben 10")
print(jonhnny.fullName)




class StarShip: fullyNamed {
    var name : String
    var prefix: String?
    
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    
    //computed property (Calculated Property)
    var fullName: String {
        //Ternary Operator
        let name = (prefix != nil ? prefix! + " " : " " ) + self.name
        return name
    }
}

var ncc1781 = StarShip(name: "Enterprise", prefix: "USS")
var firefly = StarShip(name: "Serenity")

ncc1781.fullName
firefly.fullName
//: Protocols can also require that conforming types implement certain methods.

protocol GeneratsRandomNumbers {
    func random() -> Int
}

class OnThroughTen: GeneratsRandomNumbers {
    func random() -> Int {
        return Int.random(in: 1...10)
    }
    
}

let rand = OnThroughTen()

rand.random()




//: Using built-in Protocols
extension StarShip: Equatable {
    static func == (lhs: StarShip, rhs: StarShip) -> Bool {
        if lhs.fullName == rhs.fullName { return true} else { return false }
    }
    }
    
   

if ncc1781 == firefly {
     print("Well those are the same")
} else { print( "those starships are different")}



//: ## Protocols as Types

class Dice {
    let sides: Int
    let generator: GeneratsRandomNumbers
    
    init(sides: Int, generator: GeneratsRandomNumbers) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        return Int(generator.random() % sides + 1)
        // Dice 6 sides
        // the " + 1 " stops the dice from ever resulting in the integer 1
        // 1 % 6 + 1 = 6
        // 2 % 6 + 1 = 5
        // 3 % 6 + 1 = 4
        // 4 % 6 + 1 = 3
        // 5 % 6 + 1 = 2
        // 6 ^ 6 + 1 = 1
        // 10 % 6 + 1 = 5
        
    }
    
}
var moneyRoll = Dice(sides: 6, generator: OnThroughTen())

for _ in 1...5 {
    print("Random dice roll is \(moneyRoll.roll())")
}


