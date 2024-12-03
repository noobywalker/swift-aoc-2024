import Testing

@testable import AdventOfCode

struct Day03Tests {

  let testDataPart1 = """
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    """

  let testDataPart2 = """
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
    """

  @Test func testPart1() async throws {
    let challenge = Day03(data: testDataPart1)
    #expect(String(describing: challenge.part1()) == "161")
  }


  @Test func testPart2() async throws {
    let challenge = Day03(data: testDataPart2)
    #expect(String(describing: challenge.part2()) == "48")
  }
}
