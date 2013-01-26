# AFCalenderClient

AFCalenderClient is a [AFNetworking](https://github.com/AFNetworking/AFNetworking)
extension for downloading and parsing iCal calendars.

## Usage with AFCalenderClient (extends AFHTTPClient)

``` objective-c
AFHTTPClient* calenderClient = [[AFCalenderClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.google.com/calendar"]];
NSURLRequest* calenderRequest = [client requestWithMethod:@"GET" path:@"ical/german__de%40holiday.calendar.google.com/public/basic.ics" parameters:nil];

AFHTTPRequestOperation* calenderOperation = [calenderClient HTTPRequestOperationWithRequest:calenderRequest success:^(AFHTTPRequestOperation* operation, AFCalender* calender) {
	NSLog(@"Calender: %@", calender);
	NSLog(@"Events: %@", calender.events);
} failure:^(AFHTTPRequestOperation* operation, NSError* error) {
	NSLog(@"Error: %@", error);
}]
[calenderClient enqueueHTTPRequestOperation:calenderOperation];
```

## Use AFHTTPClient and AFCalenderOperation directly

``` objective-c
NSURL* calendereUrl = [NSURL URLWithString:@"https://www.google.com/calendar/ical/german__de%40holiday.calendar.google.com/public/basic.ics"];
NSURLRequest* calenderRequest = [NSURLRequest requestWithURL:calenderUrl];

AFCalenderOperation* operation = [[AFCalenderOperation alloc] initWithRequest:calenderRequest];
[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, AFCalender* calender) {
	NSLog(@"Calender: %@", calender);
	NSLog(@"Events: %@", calender.events);
} failure:^(AFHTTPRequestOperation* operation, NSError* error) {
	NSLog(@"Error: %@", error);
}]

AFHTTPClient* anyHttpClient = ...;
[anyHttpClient enqueueHTTPRequestOperation:calenderOperation];
```

## Status

* General calender parsing into a simple model, see AFCalenderModel.h
  If you want read another calender format please constribute it or add an issue for that.
* Parsing of different date formats into NSDate
* Unit tests for all classes

Open todos:

* Support for events in a sequence
* Implement comperator to simple sort the events

## How to constribute

* Clone or fork the project with AFNetworking as submodule.
* Fix or extend the code with the contain test classes.
* Add your commit under MIT license to an issue or pull request.

    git clone --recursive git@github.com:jerolimov/AFCalenderClient.git

## License

AFCalenderClient extension is available under the MIT license,
like [AFNetworking](https://github.com/AFNetworking/AFNetworking) itself.
Read the LICENSE.txt file for more details.
