import Algorithms

struct Day06: AdventDay {
  typealias Position = (x: Int, y: Int)
  var data: String
  let guardIndicator: Character = "^"
  let obstructionIndicator: Character = "#"

  var entities: (start: Position, obstructions: [Position], bounds: Position) {
    var startPosition: Position = (0, 0)
    let lines = data.split(separator: "\n")
    let bounds: Position = (lines.count, lines.first?.count ?? 0)
    let obstructions = lines.enumerated()
      .map { line in
        line.element.enumerated().compactMap { char in
          if char.element == guardIndicator {
            startPosition = (line.offset, char.offset)
          } else if char.element == obstructionIndicator {
            return (line.offset, char.offset)
          }
          return nil
        }
      }
      .flatMap { $0 }
    return (start: startPosition, obstructions: obstructions, bounds: bounds)
  }

  /**
   --- Day 6: Guard Gallivant ---

   The Historians use their fancy device again, this time to whisk you all away to the North Pole prototype suit manufacturing lab... in the year 1518! It turns out that having direct access to history is very convenient for a group of historians.

   You still have to be careful of time paradoxes, and so it will be important to avoid anyone from 1518 while The Historians search for the Chief. Unfortunately, a single guard is patrolling this part of the lab.

   Maybe you can work out where the guard will go ahead of time so that The Historians can search safely?

   You start by making a map (your puzzle input) of the situation. For example:

   ....#.....
   .........#
   ..........
   ..#.......
   .......#..
   ..........
   .#..^.....
   ........#.
   #.........
   ......#...
   The map shows the current position of the guard with ^ (to indicate the guard is currently facing up from the perspective of the map). Any obstructions - crates, desks, alchemical reactors, etc. - are shown as #.

   Lab guards in 1518 follow a very strict patrol protocol which involves repeatedly following these steps:

   If there is something directly in front of you, turn right 90 degrees.
   Otherwise, take a step forward.
   Following the above protocol, the guard moves up several times until she reaches an obstacle (in this case, a pile of failed suit prototypes):

   ....#.....
   ....^....#
   ..........
   ..#.......
   .......#..
   ..........
   .#........
   ........#.
   #.........
   ......#...
   Because there is now an obstacle in front of the guard, she turns right before continuing straight in her new facing direction:

   ....#.....
   ........>#
   ..........
   ..#.......
   .......#..
   ..........
   .#........
   ........#.
   #.........
   ......#...
   Reaching another obstacle (a spool of several very long polymers), she turns right again and continues downward:

   ....#.....
   .........#
   ..........
   ..#.......
   .......#..
   ..........
   .#......v.
   ........#.
   #.........
   ......#...
   This process continues for a while, but the guard eventually leaves the mapped area (after walking past a tank of universal solvent):

   ....#.....
   .........#
   ..........
   ..#.......
   .......#..
   ..........
   .#........
   ........#.
   #.........
   ......#v..
   By predicting the guard's route, you can determine which specific positions in the lab will be in the patrol path. Including the guard's starting position, the positions visited by the guard before leaving the area are marked with an X:

   ....#.....
   ....XXXXX#
   ....X...X.
   ..#.X...X.
   ..XXXXX#X.
   ..X.X.X.X.
   .#XXXXXXX.
   .XXXXXXX#.
   #XXXXXXX..
   ......#X..
   In this example, the guard will visit 41 distinct positions on your map.

   Predict the path of the guard. How many distinct positions will the guard visit before leaving the mapped area?
   */
  enum Direction {
    case up
    case down
    case left
    case right

    var turnRight: Direction {
      switch self {
      case .up:
        return .right
      case .down:
        return .left
      case .left:
        return .up
      case .right:
        return .down
      }
    }

    func endPosition(p1: Position, p2: Position) -> Position {
      switch self {
      case .up:
        return (0, p1.y)
      case .down:
        return (p2.x, p1.y)
      case .left:
        return (p1.x, 0)
      case .right:
        return (p1.x, p2.y)
      }
    }
  }

  func part1() -> Any {
    var direction: Direction = .up
    let (start, obstructions, bounds) = entities
    var currentPosition = start
    var visited: [Position] = [start]
    var proceed = true
    while proceed {
      if let obstruction = findNextObstruction(p1: currentPosition, direction: direction, obstructions: obstructions) {
        let (newPosition, diff, list) = diff(p1: currentPosition, p2: obstruction, direction: direction)
        visited.append(contentsOf: list)
        currentPosition = newPosition
        direction = direction.turnRight
      } else {
        let p2 = direction.endPosition(p1: currentPosition, p2: bounds)
        let (newPosition, diff, list) = diff(p1: currentPosition, p2: p2, direction: direction)
        visited.append(contentsOf: list)
        proceed = false
      }
    }

    func findNextObstruction(p1: Position, direction: Direction, obstructions: [Position]) -> Position? {
      let filters = obstructions.filter { position in
        isNextObstruction(p1: currentPosition, p2: position, direction: direction)
      }
      switch direction {
      case .up:
        return filters.max { $1.x > $0.x }
      case .down:
        return filters.min { $0.x < $1.x }
      case .left:
        return filters.max { $1.y > $0.y }
      case .right:
        return filters.min { $0.y < $1.y }
      }
    }

    func isNextObstruction(p1: Position, p2: Position, direction: Direction) -> Bool {
      switch direction {
      case .up:
        return p2.y == p1.y && p2.x < p1.x
      case .right:
        return p2.y > p1.y && p2.x == p1.x
      case .down:
        return p2.y == p1.y && p2.x > p1.x
      case .left:
        return p2.y < p1.y && p2.x == p1.x
      }
    }

    func diff(p1: Position, p2: Position, direction: Direction) -> (new: Position, diff: Int, list: [Position]) {
      switch direction {
      case .up:
        return (new: (p2.x + 1, p2.y), diff: abs((p2.x + 1) - p1.x), list: (p2.x+1...p1.x).map { Position($0, p2.y) })
      case .right:
        return (new: (p2.x, p2.y - 1), diff: abs((p2.y - 1) - p1.y), list: (p1.y..<p2.y).map { Position(p2.x, $0) })
      case .down:
        return (new: (p2.x - 1, p2.y), diff: abs((p2.x - 1) - p1.x), list: (p1.x..<p2.x).map { Position($0, p2.y) })
      case .left:
        return (new: (p2.x, p2.y + 1), diff: abs((p2.y + 1) - p1.y), list: (p2.y+1...p1.y).map { Position(p2.x, $0) })
      }
    }

    return Set(visited.map {"\($0.x), \($0.y)"}).count
  }

  func part2() -> Any {
    return 0
  }
}

