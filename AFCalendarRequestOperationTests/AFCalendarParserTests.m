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
	
	STAssertEqualObjects(parser.calendar.title, @"Deutsche Feiertage", @"Unexpected value");

	STAssertEquals(parser.events.count, (NSUInteger) 43, @"Unexpected event count");
	
	EKEvent* event0 = [parser.events objectAtIndex:0];
	
	STAssertEqualObjects(event0.startDate, [NSDate dateWithString:@"2014-10-03 00:00:00 +0200"], @"Unexpected value");
	STAssertEqualObjects(event0.endDate, [NSDate dateWithString:@"2014-10-04 00:00:00 +0200"], @"Unexpected value");
	STAssertEqualObjects(event0.title, @"Tag der deutschen Einheit", @"Unexpected value");
	STAssertNil(event0.notes, @"Unexpected value");
	STAssertNil(event0.location, @"Unexpected value");
	
}

- (void) testUniversityOfAppliedSciencesCologneCalendarEventEntry {
	NSString* calendarContent = @"BEGIN:VCALENDAR\n\
BEGIN:VEVENT\n\
SEQUENCE:0\n\
UID:13633699615400.7220173785905155\n\
SUMMARY:ST1 P\n\
DESCRIPTION:Softwaretechnik 1\\n\n\
LOCATION:2106\n\
STATUS:TENTATIVE\n\
CLASS:PUBLIC\n\
RRULE:FREQ=WEEKLY;INTERVAL=1;UNTIL=20130712T000000;BYDAY=MO;WKST=MO\n\
DTSTART;TZID=\"Europe/Berlin\":20130318T170000\n\
DTEND;TZID=\"Europe/Berlin\":20130318T174500\n\
DTSTAMP:20130315T000000\n\
LAST-MODIFIED:20130315T000000\n\
END:VEVENT\n\
END:VCALENDAR";

	AFCalendarParser* parser = [[AFCalendarParser alloc] init];
	parser.calendar = [[EKCalendar alloc] init];
	[parser parse:calendarContent];
	EKEvent* event0 = [parser.events objectAtIndex:0];
	STAssertEqualObjects(event0.title, @"ST1 P", @"Unexpected title");
	STAssertEqualObjects(event0.notes, @"Softwaretechnik 1\\n", @"Unexpected notes");
	STAssertEqualObjects(event0.startDate, [NSDate dateWithString:@"2013-03-18 17:00:00 +0100"], @"Unexpected start date");
	STAssertEqualObjects(event0.endDate, [NSDate dateWithString:@"2013-03-18 17:45:00 +0100"], @"Unexpected end date");
	STAssertNotNil(event0.recurrenceRules, @"Unexpected value");
	EKRecurrenceRule *rule = [[event0 recurrenceRules] objectAtIndex:0];
	STAssertEquals(rule.interval, (NSInteger) 1, @"Unexpected rule interval");
	STAssertEquals(rule.frequency, EKRecurrenceFrequencyWeekly, @"Unexpected rule frequency");
	STAssertEqualObjects([rule.recurrenceEnd endDate], [NSDate dateWithString:@"2013-07-12 00:00:00 +0200"], @"Unexpected rule end");
}

- (void) testBirthdayEventEntry {
	NSString* calendarContent = @"BEGIN:VCALENDAR\n\
BEGIN:VEVENT\n\
DTSTART;VALUE=DATE:20121122\n\
DTEND;VALUE=DATE:20121123\n\
RRULE:FREQ=YEARLY;WKST=MO\n\
DTSTAMP:20130316T150319Z\n\
UID:55ntc316ckalnubmd88hflud8s@google.com\n\
CREATED:20121123T091805Z\n\
DESCRIPTION:\n\
LAST-MODIFIED:20121123T091805Z\n\
LOCATION:\n\
SEQUENCE:0\n\
STATUS:CONFIRMED\n\
SUMMARY:Ingo Geburtstag\n\
TRANSP:OPAQUE\n\
END:VEVENT\n\
END:VCALENDAR";

	AFCalendarParser* parser = [[AFCalendarParser alloc] init];
	parser.calendar = [[EKCalendar alloc] init];
	[parser parse:calendarContent];
	EKEvent* event0 = [parser.events objectAtIndex:0];
	STAssertEqualObjects(event0.title, @"Ingo Geburtstag", @"Unexpected title");
	STAssertEqualObjects(event0.notes, @"", @"Unexpected notes");
	STAssertEqualObjects(event0.startDate, [NSDate dateWithString:@"2012-11-22 00:00:00 +0100"], @"Unexpected start date");
	STAssertEqualObjects(event0.endDate, [NSDate dateWithString:@"2012-11-23 00:00:00 +0100"], @"Unexpected end date");
	STAssertNotNil(event0.recurrenceRules, @"Unexpected value");
	EKRecurrenceRule *rule = [[event0 recurrenceRules] objectAtIndex:0];
	STAssertEquals(rule.interval, (NSInteger) 1, @"Unexpected rule interval");
	STAssertEquals(rule.frequency, EKRecurrenceFrequencyYearly, @"Unexpected rule frequency");
}

@end
