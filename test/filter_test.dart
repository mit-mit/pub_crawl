//  Copyright 2021 Google LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import 'package:pub_crawl/src/filters.dart';
import 'package:test/test.dart';

void main() {
  group('filter', () {
    group('dart 2', () {
      group('bad', () {
        for (var constraint in [
          '>=1.7.2',
          '^1.7.2',
          '<2.0.0',
          '>= 3.0.0',
        ]) {
          test(constraint, () {
            expect(isDart2(constraint), isFalse);
          });
        }
      });
      group('good', () {
        for (var constraint in [
          '>=2.0.0',
          '>=2.12.0-0 <3.0.0',
        ]) {
          test(constraint, () {
            expect(isDart2(constraint), isTrue);
          });
        }
      });
    });
  });
}
