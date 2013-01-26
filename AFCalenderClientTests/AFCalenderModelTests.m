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

#import "AFCalenderModelTests.h"

#import "AFCalenderModel.h"

@implementation AFCalenderModelTests

- (void) testCompareWithArray {
	AFCalenderEvent* event1 = [[AFCalenderEvent alloc] init];
	event1.start = [NSDate dateWithString:@"2013-01-01 00:00:00 +0000"];
	AFCalenderEvent* event2 = [[AFCalenderEvent alloc] init];
	event2.start = [NSDate dateWithString:@"2013-01-02 00:00:00 +0000"];
	
	NSMutableArray* array;
	
	array = [NSMutableArray arrayWithObjects:event1, event2, nil];
	[array sortUsingSelector:@selector(compare:)];
	
	STAssertEquals([array objectAtIndex:0], event1, @"Unexpected event at position 0.");
	STAssertEquals([array objectAtIndex:1], event2, @"Unexpected event at position 1.");
	
	array = [NSMutableArray arrayWithObjects:event2, event1, nil];
	[array sortUsingSelector:@selector(compare:)];
	
	STAssertEquals([array objectAtIndex:0], event1, @"Unexpected event at position 0.");
	STAssertEquals([array objectAtIndex:1], event2, @"Unexpected event at position 1.");
}

@end
