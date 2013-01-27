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

#import "AFCalenderParser.h"

@implementation AFCalenderParser {
	EKEvent* _event;
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
 Parse a "multiline" of a calender file.
 
 @return YES if the parsing is successfully finished (end of calender is reached).
 */
- (BOOL) parseLine: (NSString*) line {
	if ([line isEqualToString:@"BEGIN:VCALENDAR"]) {
		_calendar = [[EKCalendar alloc] init];
		_events = [NSMutableArray array];
		return NO;
	} else if ([line isEqualToString:@"BEGIN:VEVENT"]) {
		_event = [[EKEvent alloc] init];
		return NO;
	} else if ([line isEqualToString:@"END:VEVENT"]) {
		if (_event) {
			[_events addObject:_event];
			_event = nil;
		}
		return NO;
	} else if ([line isEqualToString:@"END:VCALENDAR"]) {
		return YES;
	}
	
	if (_calendar && _event) {
		[self parseEvent:line];
	} else if (_calendar) {
		[self parseCalender:line];
	}
	return NO;
}

- (void) parseCalender: (NSString*) line {
	/*if ([line hasPrefix:@"PRODID:"]) {
		_calendar.providerId = [line substringFromIndex:@"PRODID:".length];
	} else if ([line hasPrefix:@"VERSION:"]) {
		_calendar.version = [line substringFromIndex:@"VERSION:".length];
	} else*/ if ([line hasPrefix:@"X-WR-CALDESC:"]) {
		_calendar.title = [line substringFromIndex:@"X-WR-CALDESC:".length];
	}/* else if ([line hasPrefix:@"X-WR-TIMEZONE:"]) {
		_calendar.timezone = [line substringFromIndex:@"X-WR-TIMEZONE:".length];
	}*/ else {
		//NSLog(@"Unsupported calender line: %@", line);
	}
}

- (void) parseEvent: (NSString*) line {
	/*if ([line hasPrefix:@"UID:"]) {
		_event.uid = [line substringFromIndex:@"UID:".length];
	} else if ([line hasPrefix:@"SEQUENCE:"]) {
		_event.sequence = [line isEqualToString:@"SEQUENCE:1"];
	} else*/ if ([line hasPrefix:@"DTSTART;"]) {
		_event.startDate = [self parseEventDate:[line substringFromIndex:@"DTSTART;".length]];
	} else if ([line hasPrefix:@"DTEND;"]) {
		_event.endDate = [self parseEventDate:[line substringFromIndex:@"DTEND;".length]];
	} else if ([line hasPrefix:@"LOCATION:"]) {
		_event.location = [line substringFromIndex:@"LOCATION:".length];
	} else if ([line hasPrefix:@"SUMMARY:"]) {
		_event.title = [line substringFromIndex:@"SUMMARY:".length];
	} else if ([line hasPrefix:@"DESCRIPTION:"]) {
		_event.notes = [line substringFromIndex:@"DESCRIPTION:".length];
	} else if ([line hasPrefix:@"LOCATION:"]) {
		_event.location = [line substringFromIndex:@"LOCATION:".length];
	} else {
		//NSLog(@"Unsupported event line: %@", line);
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

@end
