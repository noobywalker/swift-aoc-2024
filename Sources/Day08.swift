import Algorithms

struct Day08: AdventDay {

  struct Position {
    let row: Int
    let col: Int
  }

  var data: String

  var parsedData: (entities: [String: [Position]], maxRow: Int, maxCol: Int) {
    var dic: [String: [Position]] = [:]

    let rows = data.split(separator: "\n")
    let maxRow = rows.count
    var maxCol: Int = 0

    rows.enumerated().forEach { line in
      for char in line.element.enumerated() {
        if char.element != "." && char.element != "#" {
          var array = dic[String(char.element)] ?? []
          array.append(Position(row: line.offset, col: char.offset))
          dic[String(char.element)] = array
        }
      }
      maxCol = line.element.count
    }
    return (dic, maxRow, maxCol)
  }

  /**
   --- Day 8: Resonant Collinearity ---

   You find yourselves on the roof of a top-secret Easter Bunny installation.

   While The Historians do their thing, you take a look at the familiar huge antenna. Much to your surprise, it seems to have been reconfigured to emit a signal that makes people 0.1% more likely to buy Easter Bunny brand Imitation Mediocre Chocolate as a Christmas gift! Unthinkable!

   Scanning across the city, you find that there are actually many such antennas. Each antenna is tuned to a specific frequency indicated by a single lowercase letter, uppercase letter, or digit. You create a map (your puzzle input) of these antennas. For example:

   ............
   ........0...
   .....0......
   .......0....
   ....0.......
   ......A.....
   ............
   ............
   ........A...
   .........A..
   ............
   ............
   The signal only applies its nefarious effect at specific antinodes based on the resonant frequencies of the antennas. In particular, an antinode occurs at any point that is perfectly in line with two antennas of the same frequency - but only when one of the antennas is twice as far away as the other. This means that for any pair of antennas with the same frequency, there are two antinodes, one on either side of them.

   So, for these two antennas with frequency a, they create the two antinodes marked with #:

   ..........
   ...#......
   ..........
   ....a.....
   ..........
   .....a....
   ..........
   ......#...
   ..........
   ..........
   Adding a third antenna with the same frequency creates several more antinodes. It would ideally add four antinodes, but two are off the right side of the map, so instead it adds only two:

   ..........
   ...#......
   #.........
   ....a.....
   ........a.
   .....a....
   ..#.......
   ......#...
   ..........
   ..........
   Antennas with different frequencies don't create antinodes; A and a count as different frequencies. However, antinodes can occur at locations that contain antennas. In this diagram, the lone antenna with frequency capital A creates no antinodes but has a lowercase-a-frequency antinode at its location:

   ..........
   ...#......
   #.........
   ....a.....
   ........a.
   .....a....
   ..#.......
   ......A...
   ..........
   ..........
   The first example has antennas with two different frequencies, so the antinodes they create look like this, plus an antinode overlapping the topmost A-frequency antenna:

   ......#....#
   ...#....0...
   ....#0....#.
   ..#....0....
   ....0....#..
   .#....A.....
   ...#........
   #......#....
   ........A...
   .........A..
   ..........#.
   ..........#.
   Because the topmost A-frequency antenna overlaps with a 0-frequency antinode, there are 14 total unique locations that contain an antinode within the bounds of the map.

   Calculate the impact of the signal. How many unique locations within the bounds of the map contain an antinode?
   */

  func part1() -> Any {
    return findAntinodeCount(for: .single)
  }

  enum NodeType {
    case single, line
  }

  private func findAntinodeCount(for nodeType: NodeType) -> Int {
    let (antennas, maxRow, maxCol) = parsedData
    var check: [Position] = []
    for (_, positions) in antennas {
      for i in 0..<positions.count {
        var tempPositions = positions
        let pos = tempPositions.remove(at: i)
        for next in tempPositions {
          let dRow = pos.row - next.row
          let dCol = pos.col - next.col
          var nRow = pos.row
          var nCol = pos.col

          var proceed = true
          while proceed {
            nRow += dRow
            nCol += dCol
            let nPos = Position(row: nRow, col: nCol)
            let isWithInbounds = nRow < maxRow && nRow >= 0 && nCol < maxCol && nCol >= 0
            if isWithInbounds && !check.contains(nPos) {
              check.append(nPos)
            }
            proceed = nodeType != .single && isWithInbounds
          }

          if nodeType == .line {
            if !check.contains(pos) {
              check.append(pos)
            }
            if !check.contains(next) {
              check.append(next)
            }
          }
        }
      }
    }
    return check.count
  }
  /**
   --- Part Two ---

   Watching over your shoulder as you work, one of The Historians asks if you took the effects of resonant harmonics into your calculations.

   Whoops!

   After updating your model, it turns out that an antinode occurs at any grid position exactly in line with at least two antennas of the same frequency, regardless of distance. This means that some of the new antinodes will occur at the position of each antenna (unless that antenna is the only one of its frequency).

   So, these three T-frequency antennas now create many antinodes:

   T....#....
   ...T......
   .T....#...
   .........#
   ..#.......
   ..........
   ...#......
   ..........
   ....#.....
   ..........
   In fact, the three T-frequency antennas are all exactly in line with two antennas, so they are all also antinodes! This brings the total number of antinodes in the above example to 9.

   The original example now has 34 antinodes, including the antinodes that appear on every antenna:

   ##....#....#
   .#.#....0...
   ..#.#0....#.
   ..##...0....
   ....0....#..
   .#...#A....#
   ...#..#.....
   #....#.#....
   ..#.....A...
   ....#....A..
   .#........#.
   ...#......##
   Calculate the impact of the signal using this updated model. How many unique locations within the bounds of the map contain an antinode?

   */

  func part2() -> Any {
    findAntinodeCount(for: .line)
  }
}

extension Day08.Position: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.col == rhs.col && lhs.row == rhs.row
  }
}
