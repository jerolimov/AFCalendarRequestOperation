# AFCalendarRequestOperation

AFCalendarRequestOperation is a [AFNetworking](https://github.com/AFNetworking/AFNetworking)
extension for downloading and parsing iCal calendars.

## Work in process API

## Configure AFHTTPClient to use AFCalendarRequestOperation automatically

``` objective-c
AFHTTPClient* calendarClient = [[AFCalendarClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.google.com/calendar"]];
NSURLRequest* calendarRequest = [client requestWithMethod:@"GET" path:@"ical/german__de%40holiday.calendar.google.com/public/basic.ics" parameters:nil];

AFHTTPRequestOperation* calendarOperation = [calendarClient HTTPRequestOperationWithRequest:calendarRequest success:^(AFHTTPRequestOperation* operation, AFCalendar* calendar) {
	NSLog(@"Calendar: %@", calendar);
	NSLog(@"Events: %@", calendar.events);
} failure:^(AFHTTPRequestOperation* operation, NSError* error) {
	NSLog(@"Error: %@", error);
}]
[calendarClient enqueueHTTPRequestOperation:calendarOperation];
```

## Use AFHTTPClient and use AFCalendarRequestOperation manually

``` objective-c
NSURL* calendareUrl = [NSURL URLWithString:@"https://www.google.com/calendar/ical/german__de%40holiday.calendar.google.com/public/basic.ics"];
NSURLRequest* calendarRequest = [NSURLRequest requestWithURL:calendarUrl];

AFCalendarOperation* operation = [[AFCalendarOperation alloc] initWithRequest:calendarRequest];
[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, AFCalendar* calendar) {
	NSLog(@"Calendar: %@", calendar);
	NSLog(@"Events: %@", calendar.events);
} failure:^(AFHTTPRequestOperation* operation, NSError* error) {
	NSLog(@"Error: %@", error);
}]

AFHTTPClient* anyHttpClient = ...;
[anyHttpClient enqueueHTTPRequestOperation:calendarOperation];
```

## Status

* General calendar parsing into a simple model, see AFCalendarModel.h
  If you want read another calendar format please constribute it or add an issue for that.
* Parsing of different date formats into NSDate
* Unit tests for all classes

Open todos:

* Support for events in a sequence
* Implement comperator to simple sort the events

## How to constribute

* Clone or fork the project with AFNetworking as submodule.
* Fix or extend the code with the contain test classes.
* Add your commit under MIT license to an issue or pull request.

    git clone --recursive git@github.com:jerolimov/AFCalendarRequestOperation.git

## License

AFCalendarRequestOperation extension is available under the MIT license,
like [AFNetworking](https://github.com/AFNetworking/AFNetworking) itself.
Read the LICENSE.txt file for more details.
