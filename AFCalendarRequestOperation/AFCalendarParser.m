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

#import "AFCalendarParser.h"

@implementation AFCalendarParser {
	EKEvent* _currentEvent;
	// NSString or NSMutableString
	id _lastLine;
}

- (void) parse: (NSString*) content {
	[content enumerateLinesUsingBlock:^(NSString* line, BOOL* stop) {
		if ([line hasPrefix:@" "]) {
			if (![_lastLine isMemberOfClass:NSMutableString.class]) {
				_lastLine = [_lastLine mutableCopy];
			}
			[_lastLine appendString:[line substringFromIndex:1]];
		} else if (_lastLine) {
			[self parseLine:_lastLine];
			_lastLine = line;
		} else {
			_lastLine = line;
		}
	}];
}

/**
 Parse a "multiline" of a calendar file.
 
 @return YES if the parsing is successfully finished (end of calendar is reached).
 */
- (BOOL) parseLine: (NSString*) line {
	if ([line isEqualToString:@"BEGIN:VCALENDAR"]) {
		_events = [NSMutableArray array];
		return NO;
	} else if ([line isEqualToString:@"BEGIN:VEVENT"]) {
		_currentEvent = [EKEvent eventWithEventStore:_store];
		return NO;
	} else if ([line isEqualToString:@"END:VEVENT"]) {
		if (_currentEvent) {
			[_events addObject:_currentEvent];
			_currentEvent = nil;
		}
		return NO;
	} else if ([line isEqualToString:@"END:VCALENDAR"]) {
		return YES;
	}
	
	if (_currentEvent) {
		[self parseEvent:line];
	} else {
		[self parseCalendar:line];
	}
	return NO;
}

- (void) parseCalendar: (NSString*) line {
	if ([line hasPrefix:@"PRODID:"]) {
		// Create or load a new event store for the given calendar identifier.
		if (_store && !_calendar) {
			_calendar = [_store calendarWithIdentifier:[line substringFromIndex:@"PRODID:".length]];
		}
	}
	
	if (!_calendar) {
		return;
	}
		
	if ([line hasPrefix:@"X-WR-CALDESC:"]) {
		_calendar.title = [line substringFromIndex:@"X-WR-CALDESC:".length];
	}
}

/**
 SUMMARY:BWL2 V
 DESCRIPTION:Betriebswirtschaftslehre 2 (Inf)\n
 LOCATION:0401
 RRULE:FREQ=WEEKLY;INTERVAL=1;UNTIL=20130712T000000;BYDAY=TH;WKST=MO
 DTSTART;TZID="Europe/Berlin":20130321T130000
 DTEND;TZID="Europe/Berlin":20130321T134500
 */
- (void) parseEvent: (NSString*) line {
	if ([line hasPrefix:@"DTSTART;"]) {
		_currentEvent.startDate = [self parseEventDate:[line substringFromIndex:@"DTSTART;".length]];
	} else if ([line hasPrefix:@"DTEND;"]) {
		_currentEvent.endDate = [self parseEventDate:[line substringFromIndex:@"DTEND;".length]];
	} else if ([line hasPrefix:@"LOCATION:"]) {
		_currentEvent.location = [line substringFromIndex:@"LOCATION:".length];
	} else if ([line hasPrefix:@"SUMMARY:"]) {
		_currentEvent.title = [line substringFromIndex:@"SUMMARY:".length];
	} else if ([line hasPrefix:@"DESCRIPTION:"]) {
		_currentEvent.notes = [line substringFromIndex:@"DESCRIPTION:".length];
	} else if ([line hasPrefix:@"RRULE:"]) {
		_currentEvent.recurrenceRules = [self parseRecurrenceRules:[line substringFromIndex:@"RRULE:".length]];
	}
}

/**
 VALUE=DATE:20121003
 TZID="Europe/Berlin":20130130T130000
 */
- (NSDate*) parseEventDate: (NSString*) date {
	NSString* format = @"yyyyMMdd'T'HHmmss";
	
	NSRange delimiter = [date rangeOfString:@":" options:NSBackwardsSearch];
	
	for (NSString* keyValue in [[date substringToIndex:delimiter.location] componentsSeparatedByString:@";"]) {
		NSRange delimiter2 = [keyValue rangeOfString:@"="];
		NSString* key = [keyValue substringToIndex:delimiter2.location];
		NSString* value = [keyValue substringFromIndex:delimiter2.location + delimiter2.length];
		if ([key isEqualToString:@"VALUE"] && [value isEqualToString:@"DATE"]) {
			format = @"yyyyMMdd";
		}
	}

	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = format;
	//dateFormatter.timeZone = ...
	NSDate* result = [dateFormatter dateFromString:[date substringFromIndex:delimiter.location + delimiter.length]];
	
	//NSLog(@"parsed: %@ with: %@ result: %@", [date substringFromIndex:delimiter.location + delimiter.length], format, result);
	return result;
}

/**
 RRULE:FREQ=WEEKLY;INTERVAL=1;UNTIL=20130712T000000;BYDAY=MO;WKST=MO
 RRULE:FREQ=YEARLY;WKST=MO
 */
- (NSArray*) parseRecurrenceRules: (NSString*) rules {
	NSArray *ruleComponents = [rules componentsSeparatedByString:@";"];

	// Frequency
	NSString *frequency = [self getRuleByKey:@"FREQ" inComponents:ruleComponents];
	EKRecurrenceFrequency recurrenceFrequency;
	if ([frequency isEqualToString: @"DAILY"]) {
		recurrenceFrequency = EKRecurrenceFrequencyDaily;
	} else if ([frequency isEqualToString: @"WEEKLY"]) {
		recurrenceFrequency = EKRecurrenceFrequencyWeekly;
	} else if ([frequency isEqualToString: @"MONTHLY"]) {
		recurrenceFrequency = EKRecurrenceFrequencyMonthly;
	} else if ([frequency isEqualToString: @"YEARLY"]) {
		recurrenceFrequency = EKRecurrenceFrequencyYearly;
	} else {
		return nil;
	}

	// Interval
	NSInteger *interval = [[self getRuleByKey:@"INTERVAL" inComponents:ruleComponents] intValue];
	if (interval <= 0)
		interval = 1;

	// End
	NSString *end = [self getRuleByKey:@"UNTIL" inComponents:ruleComponents];
	EKRecurrenceEnd * recurrenceEnd;
	if (end != nil) {
		NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyyMMdd'T'HHmmss";
		NSDate *endDate = [dateFormatter dateFromString:end];
		recurrenceEnd = [EKRecurrenceEnd recurrenceEndWithEndDate:endDate];
	} else {
		recurrenceEnd = nil;
	}

	// The rule
	EKRecurrenceRule * recurrenceRule = [[EKRecurrenceRule alloc]
						initRecurrenceWithFrequency:recurrenceFrequency
						interval:interval
						end:recurrenceEnd];
	

	NSMutableArray *recurrenceRules = [[NSMutableArray alloc] init];
	[recurrenceRules addObject:recurrenceRule];
	return recurrenceRules;
}

- (NSString*) getRuleByKey: (NSString*) searchKey inComponents: (NSArray *)ruleComponents {
	for (NSString *rule in ruleComponents) {
		NSRange delimiter = [rule rangeOfString:@"="];
		NSString* key = [rule substringToIndex:delimiter.location];

		if ( [key isEqualToString:searchKey])
			return[rule substringFromIndex:delimiter.location + delimiter.length];
	}

	return nil;
}

@end
