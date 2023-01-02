import Foundation
//: We're building a dice game called _Knock Out!_. It is played using the following rules:
//: 1. Each player chooses a “knock out number” – either 6, 7, 8, or 9. More than one player can choose the same number.
//: 2. Players take turns throwing both dice, once each turn. Add the number of both dice to the player's running score.
//: 3. If a player rolls their own knock out number, they are knocked out of the game.
//: 4. Play ends when either all players have been knocked out, or if a single player scores 100 points or higher.
//:
//: Let's reuse some of the work we defined from the previous page.

protocol GeneratesRandomNumbers {
    func random() -> Int
}

class OneThroughTen: GeneratesRandomNumbers {
    func random() -> Int {
        return Int.random(in: 1...10)
    }
}

class Dice {
    let sides: Int
    let generator: GeneratesRandomNumbers
    
    init(sides: Int, generator: GeneratesRandomNumbers) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        return Int(generator.random() % sides) + 1
    }
}

//: Now, let's define a couple protocols for managing a dice-based game.

protocol DiceGame {
    var dice: Dice { get }
    func play()
    
}

protocol DiceGameDelegate {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}


//: Lastly, we'll create a custom class for tracking a player in our dice game.

class Player {
    let id: Int
    let knockOutNumber: Int = Int.random(in: 6...9)
    var score: Int = 0
    var knockedOut: Bool = false
    
    init(id: Int) {
        self.id = id
    }
}

//: With all that configured, let's build our dice game class called _Knock Out!_

class KnockOut: DiceGame {
    let dice: Dice = Dice(sides: 6, generator: OneThroughTen())
    var players = [Player]()
    
    init(numberOfPlayers: Int) {
        for i in 1...numberOfPlayers {
            let aPlayer = Player(id: i)
            players.append(aPlayer)
        }
    }
    
    var delegate: DiceGameDelegate?
    
    func play() {
        delegate?.gameDidStart(self)
        
        var reachedGameEnd = false
        while !reachedGameEnd {
            for player in players where player.knockedOut == false {
                // Rolling the Dice
                let diceRollSum = dice.roll() + dice.roll()
                
                delegate?.game(self, didStartNewTurnWithDiceRoll: diceRollSum)
                // Check knockout Number
                
                if diceRollSum == player.knockOutNumber {
                    print("player \(player.id) is knocked out by rolling: \(player.knockOutNumber)")
                }
                // If knockout is true, bye player, if not add score to running score
                player.knockedOut = true
                
                let activePlayers = players.filter( {$0.knockedOut == false})
                
                if activePlayers.count == 0 {
                    reachedGameEnd = true
                    print("All players have been knocked out")
                } else {
                    // if not, add score to running score
                    player.score += diceRollSum
                   if player.score >= 100 {
                        reachedGameEnd
                       print("Player \(player.id) has won with a final score of \(player.score)")
                    }
                }
            }
        }
        // Game is Over when all players are knocked out or player reaches 100
        delegate?.gameDidEnd(self)
    
    }
    
    
}

//: The following class is used to track the status of the above game, and will conform to the `DiceGameDelegate` protocol.


class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns =  0
        if game is KnockOut {
            print("Started a new game of knock out")
        }
        
        print("The game is using a \(game.dice.sides) - sided dice")
    }
    
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
    
    
}
//: Finally, we need to test out our game. Let's create a game instance, add a tracker, and instruct the game to play.


let tracker = DiceGameTracker()
let game = KnockOut(numberOfPlayers: 6)
game.delegate = tracker
game.play()
