# AFCalenderClient

AFCalenderClient is a [AFNetworking](https://github.com/AFNetworking/AFNetworking)
extension for downloading and parsing iCal calendars.

If you need to read other calender formats please add an issue for that.

## Status

Done:

* General calender parsing into a simple model, see AFCalenderModel.h
* Parsing of different date formats into NSDate
* Tests for thats

Missing:

* Support for events in a sequence
* Implement comperator to simple sort the events
* AFNetworking client integration
* AFNetworking operation integration

## Usage (not implemented yet!)

    NSURL* url = [NSURL URLWithString:@"https://www.google.com/calendar/ical/german__de%40holiday.calendar.google.com/public/basic.ics"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation* operation = [AFCalenderOperation calenderOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id todo) {
	    

    } failure:nil];
    [operation start];

or

    todo simplified call with an AFCalenderClient

## How to constribute

* Clone or fork the project with AFNetworking as submodule.
* Fix or extend the code with the contain test classes.
* Add your commit under MIT license to an issue or pull request.

    git clone --recursive git@github.com:jerolimov/AFCalenderClient.git

## License

AFCalenderClient extension is available under the MIT license,
like [AFNetworking](https://github.com/AFNetworking/AFNetworking) itself.
Read the LICENSE.txt file for more details.
