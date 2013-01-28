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

#import "AFCalendarRequestOperationTests.h"

#import "AFHTTPClient.h"

#import "AFCalendarRequestOperation.h"

@implementation AFCalendarRequestOperationTests

/**
 Test autodetection of the HTTPRequestOperation class based on the pat suffix
 ".ics".
 */
- (void) testGoogleGermanHolidayCalendarUrl {
	NSURL* calendarBaseUrl = [NSURL URLWithString:@"https://www.google.com/calendar"];
	AFHTTPClient* client = [AFHTTPClient clientWithBaseURL:calendarBaseUrl];
	[client registerHTTPOperationClass:[AFCalendarRequestOperation class]];
	[client setDefaultHeader:@"Accept" value:@"text/calendar"];
	
	NSURLRequest* request = [client requestWithMethod:@"GET"
												 path:@"ical/german__de%40holiday.calendar.google.com/public/basic.ics"
										   parameters:nil];
	
	AFHTTPRequestOperation* operation = [client HTTPRequestOperationWithRequest:request success:nil failure:nil];
	
	STAssertEqualObjects(NSStringFromClass(operation.class), NSStringFromClass(AFCalendarRequestOperation.class), @"Unexpected class");
}

/**
 Test if all other urls will also automatically use the AFCalendarOperation
 because we set the Accept header to "text/calendar".
 */
- (void) testUniversityOfAppliedSciencesCologneCalendarUrl {
	NSURL* calendarBaseUrl = [NSURL URLWithString:@"http://advbs06.gm.fh-koeln.de:8080/icalender"];
	AFHTTPClient* client = [AFHTTPClient clientWithBaseURL:calendarBaseUrl];
	[client registerHTTPOperationClass:[AFCalendarRequestOperation class]];
	[client setDefaultHeader:@"Accept" value:@"text/calendar"];
	
	NSURLRequest* request = [client requestWithMethod:@"GET"
												 path:@"ical"
										   parameters:@{ @"sqlabfrage": @"null is null" }];
	
	AFHTTPRequestOperation* operation = [client HTTPRequestOperationWithRequest:request success:nil failure:nil];
	
	STAssertEqualObjects(NSStringFromClass(operation.class), NSStringFromClass(AFCalendarRequestOperation.class), @"Unexpected class");
}

/**
 Test autodetection of the HTTPRequestOperation class based on the pat suffix
 ".ics".
 */
- (void) testGoogleGermanHolidayCalendarOperation {
	NSURL* calendarUrl = [NSURL URLWithString:@"https://www.google.com/calendar/ical/german__de%40holiday.calendar.google.com/public/basic.ics"];
	NSURLRequest* calendarRequest = [NSURLRequest requestWithURL:calendarUrl];
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	AFCalendarRequestOperation* operation = [[AFCalendarRequestOperation alloc] initWithRequest:calendarRequest];
	operation.successCallbackQueue = queue;
	operation.failureCallbackQueue = queue;
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		STAssertEqualObjects(NSStringFromClass([responseObject class]), NSStringFromClass(EKCalendar.class), @"Unexpected class");
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		STFail(@"Error: %@", error);
	}];
	
	AFHTTPClient* client = [AFHTTPClient clientWithBaseURL:calendarUrl];
	[client enqueueHTTPRequestOperation:operation];
	// Wait until the the network code is finished.
	[client.operationQueue waitUntilAllOperationsAreFinished];
	// The we wait also "in sync" on the dispatch_async calls from the operation.
	dispatch_sync(queue, ^{});
}

/**
 Test if all other urls will also automatically use the AFCalendarOperation
 because we set the Accept header to "text/calendar".
 */
- (void) testUniversityOfAppliedSciencesCologneCalendarOperation {
	NSURL* calendarUrl = [NSURL URLWithString:@"http://advbs06.gm.fh-koeln.de:8080/icalender/ical?sqlabfrage=null%20is%20null"];
	NSURLRequest* calendarRequest = [NSURLRequest requestWithURL:calendarUrl];
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	AFCalendarRequestOperation* operation = [[AFCalendarRequestOperation alloc] initWithRequest:calendarRequest];
	operation.successCallbackQueue = queue;
	operation.failureCallbackQueue = queue;
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		STAssertEqualObjects(NSStringFromClass([responseObject class]), NSStringFromClass(EKCalendar.class), @"Unexpected class");
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		STFail(@"Error: %@", error);
	}];
	
	AFHTTPClient* client = [AFHTTPClient clientWithBaseURL:calendarUrl];
	[client enqueueHTTPRequestOperation:operation];
	// Wait until the the network code is finished.
	[client.operationQueue waitUntilAllOperationsAreFinished];
	// The we wait also "in sync" on the dispatch_async calls from the operation.
	dispatch_sync(queue, ^{});
}

/**
 Test autodetection of the HTTPRequestOperation class based on the pat suffix
 ".ics".
 */
- (void) testGoogleGermanHolidayStaticCalendarOperation {
	NSURL* calendarUrl = [NSURL URLWithString:@"https://www.google.com/calendar/ical/german__de%40holiday.calendar.google.com/public/basic.ics"];
	NSURLRequest* calendarRequest = [NSURLRequest requestWithURL:calendarUrl];
	
	AFCalendarRequestOperation* operation = [AFCalendarRequestOperation calendarRequestOperationWithRequest:calendarRequest success:^(AFCalendarRequestOperation* operation) {
		// TODO assert the data
	} failure:^(AFCalendarRequestOperation* operation, NSError *error) {
		STFail(@"Error: %@", error);
	}];
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	operation.successCallbackQueue = queue;
	operation.failureCallbackQueue = queue;
	
	AFHTTPClient* client = [AFHTTPClient clientWithBaseURL:calendarUrl];
	[client enqueueHTTPRequestOperation:operation];
	// Wait until the the network code is finished.
	[client.operationQueue waitUntilAllOperationsAreFinished];
	// The we wait also "in sync" on the dispatch_async calls from the operation.
	dispatch_sync(queue, ^{});
}

/**
 Test if all other urls will also automatically use the AFCalendarOperation
 because we set the Accept header to "text/calendar".
 */
- (void) testUniversityOfAppliedSciencesCologneStaticCalendarOperation {
	NSURL* calendarUrl = [NSURL URLWithString:@"http://advbs06.gm.fh-koeln.de:8080/icalender/ical?sqlabfrage=null%20is%20null"];
	NSURLRequest* calendarRequest = [NSURLRequest requestWithURL:calendarUrl];
	
	AFCalendarRequestOperation* operation = [AFCalendarRequestOperation calendarRequestOperationWithRequest:calendarRequest success:^(AFCalendarRequestOperation* operation) {
		// TODO assert the data
	} failure:^(AFCalendarRequestOperation* operation, NSError *error) {
		STFail(@"Error: %@", error);
	}];
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	operation.successCallbackQueue = queue;
	operation.failureCallbackQueue = queue;
	
	AFHTTPClient* client = [AFHTTPClient clientWithBaseURL:calendarUrl];
	[client enqueueHTTPRequestOperation:operation];
	// Wait until the the network code is finished.
	[client.operationQueue waitUntilAllOperationsAreFinished];
	// The we wait also "in sync" on the dispatch_async calls from the operation.
	dispatch_sync(queue, ^{});
}

@end
