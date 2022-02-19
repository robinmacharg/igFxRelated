#  IG Coding Task Submission Notes

Candidate: Robin Macharg
Date: 2022/02/18

Due to other projects that require older versions of MacOS and Xcode this was completed on a MacBook Air running Catalina (MacOS 10.15.7) using Xcode 12.4.  It targets iOS 14.4.  The app was written with a portrait iPhone form-factor in mind and due to time constraints no explicit provision for different devices or orientations was made.

The JSON provided by the endpoints was fairly lengthy and somewhat nested.  To save some time, QuickType (https://app.quicktype.io/) was used to generate Codable and URLSession boilerplate.

The app is broken in to the following main parts:
- View Controllers: The app uses standard Storyboards and UIKit lifecycle.  There's no SwiftUI.
- API: a singleton that makes network requests.  The two functions here take a callback to allow the view controllers to handle returned data.
- Model: There's a model struct for each of the two main categories of data: Articles and Markets.
- Errors: Error handling is quick and dirty.  There's an IGFxError enumeration that contains error cases and general text.  Any error-specific descriptions are appended to these texts.

TODO: REMOVE
- Given the time constraints the approach was as follows:
    - Build a model
    
## Observations

The solution is required to be simple and maintainable.  To this end there is an amount of repetition of boilerplate table view controller code.  In a larger application, and with more time, I'd look to abstract away repeated code such as pull-to-refresh.  Models for standard linear tables would likely be generic with functionality described via protocols.  

UI design was not a requirement and so is minimal and functional.  Pull-to-refresh spinners have been moved below the tables (a single line).  A minimal subset of data is exposed in the UI since it's not clear from the JSON what's useful to the user, and what's intended for consumption by any (hypohetical) additional server calls.

The server-provided JSON is undocumented and so some assumptions about structure have been made:
- There are only 3 defined markets.  These are treated as special cases.  My assumption is that a separate API would provide e.g. names that map to each Market.  For simplicity `switch`es have been used to differentiate these.
- Likewise, there are only 5 defined categories of Article, and Daily Briefings fall into only 3 geographic zones.

Comments are liberal and may edge towards overly verbose for such a simple project however they're not production comments; instead they also aim to show my thinking and consideration of options.  In an established codebase I'd still code liberally but state the obvious a little less. I always try and provide both a brief "what?" summary (one line can be read, understood, and the reader can move on) and "why?" summary for non-trivial code where its place or reason for existence may not be immediately obvious.  

The Daily Briefings have been flattened up to the top level, sibling with Breaking and Top News, etc.  This provides a uniform list and a minimal UI requirement.  A more sophisticated UI is likely required to best show this data off.  Again, time constraints.

Apple recommend Split View Controllers (i.e. a default master-detail setup) are installed as the root view controller.  With the constraint of a tab bar this is not possible.
