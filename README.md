# AFCalenderClient

AFCalenderClient is a [AFNetworking](https://github.com/AFNetworking/AFNetworking)
extension for downloading and parsing iCal calendars.

If you need to read other calender formats please add an issue for that.

## Status

Done:

* General calender parsing into a simple model, see AFCalenderModel.h
* Parsing of different date formats into NSDate
* Tests for thats
* AFNetworking client integration
* AFNetworking operation integration

Missing:

* Support for events in a sequence
* Implement comperator to simple sort the events

## Usage with AFCalenderClient (extends AFHTTPClient)

    NSURL* calenderBaseUrl = [NSURL URLWithString:@"https://www.google.com/calendar"];
    AFHTTPClient* client = [[AFCalenderClient alloc] initWithBaseURL:calenderBaseUrl];
    NSURLRequest* request = [client requestWithMethod:@"GET"
                                                 path:@"ical/german__de%40holiday.calendar.google.com/public/basic.ics"
										   parameters:nil];

    AFHTTPRequestOperation* operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, AFCalender calender) {
	
		NSLog(@"Calender: %@", calender);
		NSLog(@"Events: %@", calender.events);

	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {

		NSLog(@"Error: %@", error);

	}]

## How to constribute

* Clone or fork the project with AFNetworking as submodule.
* Fix or extend the code with the contain test classes.
* Add your commit under MIT license to an issue or pull request.

    git clone --recursive git@github.com:jerolimov/AFCalenderClient.git

## License

AFCalenderClient extension is available under the MIT license,
like [AFNetworking](https://github.com/AFNetworking/AFNetworking) itself.
Read the LICENSE.txt file for more details.
