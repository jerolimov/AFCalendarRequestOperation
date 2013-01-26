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

#import "AFCalenderClientTests.h"

#import "AFHTTPRequestOperation.h"

#import "AFCalenderClient.h"
#import "AFCalenderOperation.h"

@implementation AFCalenderClientTests

/**
 Test autodetection of the HTTPRequestOperation class based on the pat suffix
 ".ics".
 */
- (void) testGoogleGermanHolidayCalenderUrl {
	NSURL* calenderBaseUrl = [NSURL URLWithString:@"https://www.google.com/calendar"];
	AFCalenderClient* client = [[AFCalenderClient alloc] initWithBaseURL:calenderBaseUrl];
	NSURLRequest* request = [client requestWithMethod:@"GET"
												 path:@"ical/german__de%40holiday.calendar.google.com/public/basic.ics"
										   parameters:nil];
	
	AFHTTPRequestOperation* operation = [client HTTPRequestOperationWithRequest:request success:nil failure:nil];
	
	STAssertEqualObjects(NSStringFromClass(operation.class), NSStringFromClass(AFCalenderOperation.class), @"Unexpected class");
}

/**
 Test if all other urls will also automatically use the AFCalenderOperation
 because we set the Accept header to "text/calender".
 */
- (void) testUniversityOfAppliedSciencesCologneCalenderUrl {
	NSURL* calenderBaseUrl = [NSURL URLWithString:@"http://advbs06.gm.fh-koeln.de:8080/icalender"];
	AFHTTPClient* client = [[AFCalenderClient alloc] initWithBaseURL:calenderBaseUrl];
	NSURLRequest* request = [client requestWithMethod:@"GET"
												 path:@"ical"
										   parameters:@{ @"sqlabfrage": @"null is null" }];
	
	AFHTTPRequestOperation* operation = [client HTTPRequestOperationWithRequest:request success:nil failure:nil];
	
	STAssertEqualObjects(NSStringFromClass(operation.class), NSStringFromClass(AFCalenderOperation.class), @"Unexpected class");
}

@end
