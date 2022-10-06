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

#ifndef FIRSESNanoPBHelpers_h
#define FIRSESNanoPBHelpers_h

#import <nanopb/pb.h>
#import <nanopb/pb_decode.h>
#import <nanopb/pb_encode.h>

/** Mallocs a pb_bytes_array and copies the given NSData bytes into the bytes array.
 * @note Memory needs to be free manually, through pb_free or pb_release.
 * @param data The data to copy into the new bytes array.
 */
pb_bytes_array_t *FIRSESEncodeData(NSData *data) {
  pb_bytes_array_t *pbBytes = malloc(PB_BYTES_ARRAY_T_ALLOCSIZE(data.length));
  if (pbBytes == NULL) {
    return NULL;
  }
  memcpy(pbBytes->bytes, [data bytes], data.length);
  pbBytes->size = (pb_size_t)data.length;
  return pbBytes;
}

/** Mallocs a pb_bytes_array and copies the given NSString's bytes into the bytes array.
 * @note Memory needs to be freed manually, through pb_free or pb_release.
 * @param string The string to encode as pb_bytes.
 */
pb_bytes_array_t *FIRSESEncodeString(NSString *string) {
  if ([string isMemberOfClass:[NSNull class]]) {
    string = nil;
  }
  NSString *stringToEncode = string ? string : @"";
  NSData *stringBytes = [stringToEncode dataUsingEncoding:NSUTF8StringEncoding];
  return FIRSESEncodeData(stringBytes);
}

BOOL isPBArrayEqual(pb_bytes_array_t *array, pb_bytes_array_t *expected) {
  // Treat the empty string as the same as a missing field
  if ((!array) && expected->size == 0) {
    return true;
  }

  if (array->size != expected->size) {
    return false;
  }

  for (int i = 0; i < array->size; i++) {
    if (expected->bytes[i] != array->bytes[i]) {
      return false;
    }
  }

  return true;
}

BOOL isPBStringEqual(pb_bytes_array_t *pbString, NSString *str) {
  pb_bytes_array_t *expected = FIRSESEncodeString(str);
  return isPBArrayEqual(pbString, expected);
}

BOOL isPBDataEqual(pb_bytes_array_t *pbString, NSData *data) {
  pb_bytes_array_t *expected = FIRSESEncodeData(data);
  return isPBArrayEqual(pbString, expected);
}

#endif /* FIRSESNanoPBHelpers_h */
