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

#import "AFCalenderParserTests.h"

#import "AFCalenderParser.h"

@implementation AFCalenderParserTests

- (void) testGoogleGermanHolidayCalender {
	NSURL* calenderUrl = [NSURL URLWithString:@"https://www.google.com/calendar/ical/german__de%40holiday.calendar.google.com/public/basic.ics"];
	NSError* error;
	NSString* calenderContent = [NSString stringWithContentsOfURL:calenderUrl encoding:NSUTF8StringEncoding error:&error];
	if (error) {
		STFail(@"Error: %@", error);
	}

	AFCalenderParser* parser = [[AFCalenderParser alloc] init];
	AFCalender* calender = [parser parse:calenderContent];
	
	STAssertEqualObjects(calender.providerId, @"-//Google Inc//Google Calendar 70.9054//EN", @"Unexpected value");
	STAssertEqualObjects(calender.version, @"2.0", @"Unexpected value");
	STAssertEqualObjects(calender.description, @"Deutsche Feiertage", @"Unexpected value");
	STAssertEqualObjects(calender.timezone, @"UTC", @"Unexpected value");
	
	STAssertEquals((NSUInteger) 43, calender.events.count, @"Unexpected event count");
	
	AFCalenderEvent* event0 = [calender.events objectAtIndex:0];
	
	STAssertTrue([event0.uid hasSuffix:@"@google.com"], @"Unexpected value");
	STAssertTrue(event0.sequence, @"Unexpected value");
	STAssertEqualObjects(event0.start, [NSDate dateWithString:@"2014-10-03 00:00:00 +0200"], @"Unexpected value");
	STAssertEqualObjects(event0.end, [NSDate dateWithString:@"2014-10-04 00:00:00 +0200"], @"Unexpected value");
	STAssertEqualObjects(event0.summery, @"Tag der deutschen Einheit", @"Unexpected value");
	STAssertNil(event0.description, @"Unexpected value");
	STAssertNil(event0.location, @"Unexpected value");
	
	STAssertEquals(event0.duration, (NSTimeInterval) 24 * 60 * 60, @"Unexpected value");
}

- (void) testUniversityOfAppliedSciencesCologneCalender {
	NSURL* calenderUrl = [NSURL URLWithString:@"http://advbs06.gm.fh-koeln.de:8080/icalender/ical/?sqlabfrage=null%20is%20null"];
	NSLog(@"url: %@", calenderUrl);
	NSError* error;
	NSString* calenderContent = [NSString stringWithContentsOfURL:calenderUrl encoding:NSASCIIStringEncoding error:&error];
	if (error) {
		STFail(@"Error: %@", error);
	}
	
	AFCalenderParser* parser = [[AFCalenderParser alloc] init];
	AFCalender* calender = [parser parse:calenderContent];
	
	STAssertEqualObjects(calender.providerId, @"-//fh-koeln.de/NONSGML QQ2-Stundenplan iCalendar Exporter V1.3.3//EN", @"Unexpected value");
	STAssertEqualObjects(calender.version, @"2.0", @"Unexpected value");
	STAssertNil(calender.description, @"Unexpected value");
	STAssertNil(calender.timezone, @"Unexpected value");
	
	STAssertEquals((NSUInteger) 2379, calender.events.count, @"Unexpected event count");
	
	AFCalenderEvent* event0 = [calender.events objectAtIndex:0];
	
	STAssertNotNil(event0.uid, @"Unexpected value");
	STAssertEquals(event0.sequence, NO, @"Unexpected value");
	STAssertEqualObjects(event0.start, [NSDate dateWithString:@"2013-01-29 16:00:00 +0100"], @"Unexpected value");
	STAssertEqualObjects(event0.end, [NSDate dateWithString:@"2013-01-29 16:45:00 +0100"], @"Unexpected value");
	STAssertEqualObjects(event0.summery, @"MA2 P", @"Unexpected value");
	STAssertEqualObjects(event0.description, @"Mathematik 2\\n", @"Unexpected value");
	STAssertEqualObjects(event0.location, @"null", @"Unexpected value"); // TODO fix
	
	STAssertEquals(event0.duration, (NSTimeInterval) 45 * 60, @"Unexpected value");
}

@end
