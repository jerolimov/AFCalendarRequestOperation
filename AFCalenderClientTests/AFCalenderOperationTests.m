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

#import "AFCalenderOperationTests.h"

#import "AFHTTPClient.h"

#import "AFCalenderOperation.h"

@implementation AFCalenderOperationTests

/**
 Test autodetection of the HTTPRequestOperation class based on the pat suffix
 ".ics".
 */
- (void) testGoogleGermanHolidayCalenderOperation {
	NSURL* calenderUrl = [NSURL URLWithString:@"https://www.google.com/calendar/ical/german__de%40holiday.calendar.google.com/public/basic.ics"];
	NSURLRequest* calenderRequest = [NSURLRequest requestWithURL:calenderUrl];
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	AFCalenderOperation* operation = [[AFCalenderOperation alloc] initWithRequest:calenderRequest];
	operation.successCallbackQueue = queue;
	operation.failureCallbackQueue = queue;
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		STAssertEqualObjects(NSStringFromClass([responseObject class]), NSStringFromClass(AFCalender.class), @"Unexpected class");
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		STFail(@"Error: %@", error);
	}];
	
	AFHTTPClient* client = [AFHTTPClient clientWithBaseURL:calenderUrl];
	[client enqueueHTTPRequestOperation:operation];
	// Wait until the the network code is finished.
	[client.operationQueue waitUntilAllOperationsAreFinished];
	// The we wait also "in sync" on the dispatch_async calls from the operation.
	dispatch_sync(queue, ^{});
}

/**
 Test if all other urls will also automatically use the AFCalenderOperation
 because we set the Accept header to "text/calender".
 */
- (void) testUniversityOfAppliedSciencesCologneCalenderOperation {
	NSURL* calenderUrl = [NSURL URLWithString:@"http://advbs06.gm.fh-koeln.de:8080/icalender/ical?sqlabfrage=null%20is%20null"];
	NSURLRequest* calenderRequest = [NSURLRequest requestWithURL:calenderUrl];
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	AFCalenderOperation* operation = [[AFCalenderOperation alloc] initWithRequest:calenderRequest];
	operation.successCallbackQueue = queue;
	operation.failureCallbackQueue = queue;
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		STAssertEqualObjects(NSStringFromClass([responseObject class]), NSStringFromClass(AFCalender.class), @"Unexpected class");
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		STFail(@"Error: %@", error);
	}];
	
	AFHTTPClient* client = [AFHTTPClient clientWithBaseURL:calenderUrl];
	[client enqueueHTTPRequestOperation:operation];
	// Wait until the the network code is finished.
	[client.operationQueue waitUntilAllOperationsAreFinished];
	// The we wait also "in sync" on the dispatch_async calls from the operation.
	dispatch_sync(queue, ^{});
}

@end
