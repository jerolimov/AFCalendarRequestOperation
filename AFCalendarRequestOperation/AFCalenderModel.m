// Copyright (c) 2013 Christoph Jerolimov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFCalenderModel.h"

@implementation AFCalender
- (NSMutableArray*) events {
	if (!_events) {
		_events = [NSMutableArray array];
	}
	return _events;
}
@end

@implementation AFCalenderEvent
- (NSTimeInterval) duration {
	if (_start && _end) {
		return [_end timeIntervalSinceDate:_start];
	} else {
		return 0;
	}
}
- (NSComparisonResult)compare:(AFCalenderEvent*) other {
	if (self.start && other.start) {
		return [self.start compare:other.start];
	} else if (!self.start && !other.start) {
		return NSOrderedSame;
	} else if (!self.start && other.start) {
		return NSOrderedAscending;
	} else { // self.start && !other.start
		return NSOrderedDescending;
	}
}
@end
