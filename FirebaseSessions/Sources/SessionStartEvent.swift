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

import Foundation

///
/// SessionStartEvent is responsible for:
///   1) Writing fields to the Session proto
///   2) Synthesizing itself for persisting to disk and logging to GoogleDataTransport
///
class SessionStartEvent: NSObject {
  var proto: firebase_appquality_SessionEvent

  init(identifiers: IdentifierProvider, time: TimeProvider) {
    proto = firebase_appquality_SessionEvent()

    super.init()

    proto.event_type = firebase_appquality_EventType_EVENT_SESSION_START
    proto.session_id = makeProtoString(identifiers.sessionID)
    proto.previous_session_id = makeProtoString(identifiers.previousSessionID)
    proto.firebase_installation_id = makeProtoString(identifiers.installationID)
    proto.event_timestamp_us = time.timestampUS
  }

  private func makeProtoString(_ string: String) -> UnsafeMutablePointer<pb_bytes_array_t> {
    return FIRSESEncodeString(string)
  }
}
