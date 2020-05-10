// From raywenderlich / SKTUtils
// https://github.com/raywenderlich/SKTUtils/blob/master/Examples/Tests/SKTUtilsTests/CGPointTests.swift

@testable import DungeonCrawl

import XCTest
import CoreGraphics

class CGFloatTests: XCTestCase {

  func testClamped() {
    XCTAssertEqual(CGFloat(10).clamped(-5, 6), CGFloat(6))
    XCTAssertEqual(CGFloat(7).clamped(-5, 6), CGFloat(6))
    XCTAssertEqual(CGFloat(6).clamped(-5, 6), CGFloat(6))
    XCTAssertEqual(CGFloat(5).clamped(-5, 6), CGFloat(5))
    XCTAssertEqual(CGFloat(1).clamped(-5, 6), CGFloat(1))
    XCTAssertEqual(CGFloat(0).clamped(-5, 6), CGFloat(0))
    XCTAssertEqual(CGFloat(-4).clamped(-5, 6), CGFloat(-4))
    XCTAssertEqual(CGFloat(-5).clamped(-5, 6), CGFloat(-5))
    XCTAssertEqual(CGFloat(-6).clamped(-5, 6), CGFloat(-5))
    XCTAssertEqual(CGFloat(-10).clamped(-5, 6), CGFloat(-5))
  }

  func testClampedReverseOrder() {
    XCTAssertEqual(CGFloat(10).clamped(6, -5), CGFloat(6))
    XCTAssertEqual(CGFloat(7).clamped(6, -5), CGFloat(6))
    XCTAssertEqual(CGFloat(6).clamped(6, -5), CGFloat(6))
    XCTAssertEqual(CGFloat(5).clamped(6, -5), CGFloat(5))
    XCTAssertEqual(CGFloat(1).clamped(6, -5), CGFloat(1))
    XCTAssertEqual(CGFloat(0).clamped(6, -5), CGFloat(0))
    XCTAssertEqual(CGFloat(-4).clamped(6, -5), CGFloat(-4))
    XCTAssertEqual(CGFloat(-5).clamped(6, -5), CGFloat(-5))
    XCTAssertEqual(CGFloat(-6).clamped(6, -5), CGFloat(-5))
    XCTAssertEqual(CGFloat(-10).clamped(6, -5), CGFloat(-5))
  }

  func testThatClampedDoesNotChangeOriginalValue() {
    let original: CGFloat = 50
    _ = original.clamped(100, 200)
    XCTAssertEqual(original, CGFloat(50))
  }

  func testThatClampReturnsNewValue() {
    var original: CGFloat = 50
    _ = original.clamp(100, 200)
    XCTAssertEqual(original, CGFloat(100))
  }
  
  func testSign() {
    XCTAssertEqual(CGFloat(-100.0).sign(), -1.0)
    XCTAssertEqual(CGFloat(100.0).sign(), CGFloat(1.0))
    XCTAssertEqual(CGFloat(0.0).sign(), CGFloat(1.0))
  }

  func testDegreesToRadians() {
    XCTAssertEqual(CGFloat(0).degreesToRadians(), CGFloat(0), accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual(CGFloat(45).degreesToRadians(), π/4, accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual(CGFloat(90).degreesToRadians(), π/2, accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual(CGFloat(135).degreesToRadians(), 3*π/4, accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual(CGFloat(180).degreesToRadians(), π, accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual(CGFloat(-135).degreesToRadians(), -3*π/4, accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual(CGFloat(-90).degreesToRadians(), -π/2, accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual(CGFloat(-45).degreesToRadians(), -π/4, accuracy: CGFloat.ulpOfOne)
  }

  func testRadiansToDegrees() {
    XCTAssertEqual(CGFloat(0).radiansToDegrees(), CGFloat(0), accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual((π/4).radiansToDegrees(), CGFloat(45), accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual((π/2).radiansToDegrees(), CGFloat(90), accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual((3*π/4).radiansToDegrees(), CGFloat(135), accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual(π.radiansToDegrees(), CGFloat(180), accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual((-3*π/4).radiansToDegrees(), CGFloat(-135), accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual((-π/2).radiansToDegrees(), CGFloat(-90), accuracy: CGFloat.ulpOfOne)
    XCTAssertEqual((-π/4).radiansToDegrees(), CGFloat(-45), accuracy: CGFloat.ulpOfOne)
  }

  func testAllAngles() {
    let startAngle = CGFloat(-360)
    let endAngle = CGFloat(360)
    for angle in stride(from: startAngle, through: endAngle, by: 0.5) {
      let radians = angle.degreesToRadians()
      XCTAssertEqual(radians.radiansToDegrees(), angle, accuracy: 1.0e6)
    }
  }
}
