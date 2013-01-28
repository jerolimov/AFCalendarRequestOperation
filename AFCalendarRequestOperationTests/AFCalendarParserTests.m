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

#import "AFCalendarParserTests.h"

#import "AFCalendarParser.h"

@implementation AFCalendarParserTests

- (void) testGoogleGermanHolidayCalendar {
	NSURL* calendarUrl = [NSURL URLWithString:@"https://www.google.com/calendar/ical/german__de%40holiday.calendar.google.com/public/basic.ics"];
	NSError* error;
	NSString* calendarContent = [NSString stringWithContentsOfURL:calendarUrl encoding:NSUTF8StringEncoding error:&error];
	if (error) {
		STFail(@"Error: %@", error);
	}

	AFCalendarParser* parser = [[AFCalendarParser alloc] init];
	parser.calendar = [[EKCalendar alloc] init];
	
	[parser parse:calendarContent];
	
	//STAssertEqualObjects(parser.calendar.providerId, @"-//Google Inc//Google Calendar 70.9054//EN", @"Unexpected value");
	//STAssertEqualObjects(parser.calendar.version, @"2.0", @"Unexpected value");
	STAssertEqualObjects(parser.calendar.title, @"Deutsche Feiertage", @"Unexpected value");
	//STAssertEqualObjects(parser.calendar.timezone, @"UTC", @"Unexpected value");
	
	STAssertEquals(parser.events.count, (NSUInteger) 43, @"Unexpected event count");
	
	EKEvent* event0 = [parser.events objectAtIndex:0];
	
	//STAssertTrue([event0.uid hasSuffix:@"@google.com"], @"Unexpected value");
	//STAssertTrue(event0.sequence, @"Unexpected value");
	STAssertEqualObjects(event0.startDate, [NSDate dateWithString:@"2014-10-03 00:00:00 +0200"], @"Unexpected value");
	STAssertEqualObjects(event0.endDate, [NSDate dateWithString:@"2014-10-04 00:00:00 +0200"], @"Unexpected value");
	STAssertEqualObjects(event0.title, @"Tag der deutschen Einheit", @"Unexpected value");
	STAssertNil(event0.notes, @"Unexpected value");
	STAssertNil(event0.location, @"Unexpected value");
	
	//STAssertEquals(event0.duration, (NSTimeInterval) 24 * 60 * 60, @"Unexpected value");
}

- (void) testUniversityOfAppliedSciencesCologneCalendar {
	NSURL* calendarUrl = [NSURL URLWithString:@"http://advbs06.gm.fh-koeln.de:8080/icalender/ical/?sqlabfrage=null%20is%20null"];
	NSLog(@"url: %@", calendarUrl);
	NSError* error;
	NSString* calendarContent = [NSString stringWithContentsOfURL:calendarUrl encoding:NSASCIIStringEncoding error:&error];
	if (error) {
		STFail(@"Error: %@", error);
	}
	
	AFCalendarParser* parser = [[AFCalendarParser alloc] init];
	parser.calendar = [[EKCalendar alloc] init];
	
	[parser parse:calendarContent];
	
	//STAssertEqualObjects(parser.calendar.providerId, @"-//fh-koeln.de/NONSGML QQ2-Stundenplan iCalendar Exporter V1.3.3//EN", @"Unexpected value");
	//STAssertEqualObjects(parser.calendar.version, @"2.0", @"Unexpected value");
	STAssertEqualObjects(parser.calendar.title, @"", @"Unexpected value");
	//STAssertNil(parser.calendar.timezone, @"Unexpected value");
	
	STAssertEquals(parser.events.count, (NSUInteger) 2379, @"Unexpected event count");
	
	EKEvent* event0 = [parser.events objectAtIndex:0];
	
	//STAssertNotNil(event0.uid, @"Unexpected value");
	//STAssertEquals(event0.sequence, NO, @"Unexpected value");
	STAssertEqualObjects(event0.startDate, [NSDate dateWithString:@"2013-01-29 16:00:00 +0100"], @"Unexpected value");
	STAssertEqualObjects(event0.endDate, [NSDate dateWithString:@"2013-01-29 16:45:00 +0100"], @"Unexpected value");
	STAssertEqualObjects(event0.title, @"MA2 P", @"Unexpected value");
	STAssertEqualObjects(event0.notes, @"Mathematik 2\\n", @"Unexpected value");
	STAssertEqualObjects(event0.location, @"null", @"Unexpected value"); // TODO fix
	
	//STAssertEquals(event0.duration, (NSTimeInterval) 45 * 60, @"Unexpected value");
}

@end
