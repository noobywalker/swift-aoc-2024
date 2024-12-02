import Testing

@testable import AdventOfCode

struct Day02Tests {

  let testData = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    55 54 57 60 61
    78 82 85 87 89 92 94 95
    17 20 19 18 16 13 10 7
    
    """

  @Test func testPart1() async throws {
    let challenge = Day02(data: testData)
    #expect(String(describing: challenge.part1()) == "2")
  }


  @Test func testPart2() async throws {
    let challenge = Day02(data: testData)
    #expect(String(describing: challenge.part2()) == "7")
  }
}
