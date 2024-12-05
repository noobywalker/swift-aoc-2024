import Algorithms

struct Day04: AdventDay {

  var data: String

  var entities: [String] {
    return data.split(separator: "\n")
      .map { String($0) }
  }

  /**
   --- Day 4: Ceres Search ---

   "Looks like the Chief's not here. Next!" One of The Historians pulls out a device and pushes the only button on it. After a brief flash, you recognize the interior of the Ceres monitoring station!

   As the search for the Chief continues, a small Elf who lives on the station tugs on your shirt; she'd like to know if you could help her with her word search (your puzzle input). She only has to find one word: XMAS.

   This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words. It's a little unusual, though, as you don't merely need to find one instance of XMAS - you need to find all of them. Here are a few ways XMAS might appear, where irrelevant characters have been replaced with .:

   ..X...
   .SAMX.
   .A..A.
   XMAS.S
   .X....
   The actual word search will be full of letters instead. For example:

   MMMSXXMASM
   MSAMXMSMSA
   AMXSXMAAMM
   MSAMASMSMX
   XMASAMXAMM
   XXAMMXXAMA
   SMSMSASXSS
   SAXAMASAAA
   MAMMMXMMMM
   MXMXAXMASX
   In this word search, XMAS occurs a total of 18 times; here's the same word search again, but where letters not involved in any XMAS have been replaced with .:

   ....XXMAS.
   .SAMXMS...
   ...S..A...
   ..A.A.MS.X
   XMASAMX.MM
   X.....XA.A
   S.S.S.S.SS
   .A.A.A.A.A
   ..M.M.M.MM
   .X.X.XMASX
   Take a look at the little Elf's word search. How many times does XMAS appear?
   */

  enum WordType {
    case normal, backwards
  }

  enum SearchMode {
    case horizontal, vertical, diagonal, cross
  }

  enum Direction {
    case vertical, diagonalLeft, diagonalRight
  }

  func searchXMAS(mode: SearchMode, type: WordType) -> Int {
    switch mode {
    case .horizontal:
      let regex = type == .normal ? /XMAS/ : /SAMX/
      return entities.map {
        $0.matches(of: regex).count
      }.reduce(0, +)
    case .vertical:
      return searchVertical(word: "XMAS", type: type)
    case .diagonal:
      return searchDiagonal(word: "XMAS", type: type)
    case .cross:
      return searchCross(word: "MAS")
    }
  }

  func getWord(from data: [[String]], at: (x: Int, y: Int), direction: Direction, nextCharacters num: Int = 3) -> String? {
    let x = at.x
    let y = at.y
    var result = ""
    switch direction {
    case .vertical where x + num < data.count:
      (0...num).forEach { result += data[x+$0][y] }
    case .diagonalRight where x + num < data.count && y + num < data[x].count:
      (0...num).forEach { result += data[x+$0][y+$0] }
    case .diagonalLeft where x + num < data.count && y - num >= 0:
      (0...num).forEach { result += data[x+$0][y-$0] }
    default:
      break
    }
    return result
  }


  func searchCross(word: String) -> Int {
    var matchCount = 0
    let data = entities.map { Array($0).map { String($0) } }
    let expected = word
    let expectedReversed = String(word.reversed())
    let letters = Array(expected).map { String($0) }
    let middleIndex = letters.count / 2
    let middleLetter = letters[middleIndex]

    for i in 0..<data.count {
      for j in 0..<data[i].count {
        if data[i][j] == middleLetter {
          if i - middleIndex >= 0 && j - middleIndex >= 0 && j + middleIndex < data[i].count {
            let dRight = getWord(from: data, at: (i - middleIndex, j - middleIndex), direction: .diagonalRight, nextCharacters: letters.count - 1)
            let dLeft = getWord(from: data, at: (i - middleIndex, j + middleIndex), direction: .diagonalLeft, nextCharacters: letters.count - 1)
            if (dRight == expected || dRight == expectedReversed) && (dLeft == expected || dLeft == expectedReversed) {
              matchCount += 1
            }
          }
        }
      }
    }
    return matchCount
  }

  func searchDiagonal(word: String, type: WordType) -> Int {
    var matchCount = 0
    let data = entities.map { Array($0).map { String($0) } }
    let expected = type == .normal ? word : String(word.reversed())
    let letters = Array(expected).map { String($0) }
    for i in 0..<data.count {
      for j in 0..<data[i].count {
        if data[i][j] == letters.first {
          if getWord(from: data, at: (i, j), direction: .diagonalRight) == expected {
            matchCount += 1
          }
          if getWord(from: data, at: (i, j), direction: .diagonalLeft) == expected {
            matchCount += 1
          }
        }
      }
    }
    return matchCount
  }

  func searchVertical(word: String, type: WordType) -> Int {
    var matchCount = 0
    let data = entities.map { Array($0).map { String($0) } }
    let expected = type == .normal ? word : String(word.reversed())
    let letters = Array(expected).map { String($0) }
    for j in 0..<data[0].count {
      for i in 0..<data.count {
        if data[i][j] == letters.first {
          if getWord(from: data, at: (i, j), direction: .vertical) == expected {
            matchCount += 1
          }
        }
      }
    }
    return matchCount
  }

  func part1() -> Any {
    return searchXMAS(mode: .horizontal, type: .normal)
    + searchXMAS(mode: .horizontal, type: .backwards)
    + searchXMAS(mode: .vertical, type: .normal)
    + searchXMAS(mode: .vertical, type: .backwards)
    + searchXMAS(mode: .diagonal, type: .normal)
    + searchXMAS(mode: .diagonal, type: .backwards)
  }

  /**
   --- Part Two ---
   The Elf looks quizzically at you. Did you misunderstand the assignment?

   Looking for the instructions, you flip over the word search to find that this isn't actually an XMAS puzzle; it's an X-MAS puzzle in which you're supposed to find two MAS in the shape of an X. One way to achieve that is like this:

   M.S
   .A.
   M.S
   Irrelevant characters have again been replaced with . in the above diagram. Within the X, each MAS can be written forwards or backwards.

   Here's the same example from before, but this time all of the X-MASes have been kept instead:

   .M.S......
   ..A..MSMS.
   .M.S.MAA..
   ..A.ASMSM.
   .M.S.M....
   ..........
   S.S.S.S.S.
   .A.A.A.A..
   M.M.M.M.M.
   ..........
   In this example, an X-MAS appears 9 times.

   Flip the word search from the instructions back over to the word search side and try again. How many times does an X-MAS appear?
   */

  func part2() -> Any {
    return searchXMAS(mode: .cross, type: .normal)
  }
}
