//
// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import XCTest

@testable import FirebaseSessions

class SessionStartEventTests: XCTestCase {
  var identifiers: MockIdentifierProvider!
  var time: MockTimeProvider!

  override func setUp() {
    super.setUp()

    identifiers = MockIdentifierProvider()
    time = MockTimeProvider()
  }

  // The file and line fields in this function capture the file and line of the
  // function call site in the test, and pass them to XCTAssert. Without this, the
  // test will attribute the failure to this function instead of the call in the test.
  func assertEqualProtoString(_ value: UnsafeMutablePointer<pb_bytes_array_t>!, expected: String,
                              fieldName: String, file: StaticString = #filePath,
                              line: UInt = #line) {
    XCTAssert(
      isPBStringEqual(value, expected),
      "Field \(fieldName) does not match expected value \"\(expected)\"",
      file: file,
      line: line
    )
  }

  func testValidSessionStartEventBegin() {
    identifiers.sessionID = "testSessionID"
    identifiers.previousSessionID = "testPreviousSessionID"
    identifiers.installationID = "testInstallationID"
    time.timestampUS = 123

    let event = SessionStartEvent(identifiers: identifiers, time: time)
    assertEqualProtoString(
      event.proto.session_id,
      expected: "testSessionID",
      fieldName: "session_id"
    )
    assertEqualProtoString(
      event.proto.previous_session_id,
      expected: "testPreviousSessionID",
      fieldName: "previous_session_id"
    )
    assertEqualProtoString(
      event.proto.firebase_installation_id,
      expected: "testInstallationID",
      fieldName: "firebase_installation_id"
    )
    XCTAssertEqual(event.proto.event_timestamp_us, 123)
  }
}
