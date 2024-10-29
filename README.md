## Steps to Run the App
- You can either download the code and run it.  I have a build in Testflight waiting for review, and once it is approved I'll add the link here (Update, approved: https://testflight.apple.com/join/ZksTzV8K).  If you want to see how the app behaves with either the malformed json url or an empty list, you can update the "activeLinks" property in Constants to either malformedRecipeUrl or emptyRecipeUrl before running (the Testflight build obviously will only have the functional list).

### Features and running the app
- On the loading of the main app view, the API is called and the app is populated. The list has swipe down to refresh, and will rehit the API and reload the data.  The list is searchable, which queries the names of all of the recipes. There is the ability to filter based on the cuisine (the list of cuisines is populated after the api is hit, it is not hardcoded) and sort in either alphabetical or reverse alphabetical based on the name or the cuisine.  The filter indicates which filter is active with a checkmark, and to remove the filter you can tap on the current filter again to "uncheck" it.  The sort defaults to Name in alphabetical order and it is not possible to not have a selected sort.  If you select an item on the list, a sheet is presented that shows the name, cuisine and small image of the recipe.  If there is a valid youtube link that loads properly, the video is embedded in the sheet, otherwise the large image is shown.  Lastly, the link to the source of the recipe is shown.  To dismiss the sheet, you can either tap off of it, or swipe it down/

## Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
- I spent most of my time focusing on the list and searchability, sorting and filtering options. I chose to focus on this since it is the core functionality of the app. If the API returned the recipe ingredients and instructions, I may have spent more time in displaying the steps, but as is, I wanted to make the recipe list as usable as possible.

## Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
- I probably spent most of 5 hours total, between initial coding, refactoring and test cases. I allocated my time in ~3 hours design and implementation, ~1.5 hours in refactoring the views to be more readable and reusable, and ~30 min in determining and implementing test cases.

## Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
1. I decided to support iOS 16 since that is what Fetch supports. This didn't change too much, other than creating a custom Error View instead of the ContentUnavailableView (which I am supporting on iOS 17+).  It also changed the ViewModel to use ObservableObject instead of the @Observable macro.
2. Since Lists are lazy by nature, they should only be fetching the images when the list element is about to appear. 
3. I decided to use the small image url for network and caching purposes, since the list displays a small image in which the small url looks good in. However, if there is an issue in loading the Youtube video on the sheet, the large image is pulled in and shown instead.
4. I decided to use MVVM - this allowed me to pull the logic out of the views so it could be unit tested.
5. It put a little more logic in the views, but I wanted to differentiate between the API returning no results and the users filter and search criteria returning no results, adding to the user experience
6. I included a unit test for that checks that the API returns 63 recipes, and hardcodes tests that check for the cuisine is one of the current 12.  I like these tests to know if the API has been updated so tests can be updated to stay up to date.

## Weakest Part of the Project: What do you think is the weakest part of your project?
- Design. While it works, I did not add anything "fancy". Everything is pretty stock SwiftUI with no custom colors. I'm also not entirely happy with the search/filter/sort UI in the fact that once you type in a search, the filter and sort buttons are no longer accessible.  This means you have to set the sort and filter before searching, and you can't decide after the search that you'd rather only see a specific cuisine.  I'd also look into the YouTubePlayerKit a little more - I don't like on failure the view is shown ontop of a failed youtube player, I'd spend more time to not display the player in this case (examples of failures are on the Apple & Blackberry Cruble and Apple Frangipan Tart)

## External Code and Dependencies: Did you use any external code, libraries, or dependencies?
- Yes.  I used Kingfisher for image caching and YouTubePlayerKit to enable playback of the Youtube Links in the app itself.

## Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
- I just wanted to thank you for the opportunity to do this project. My career has been primarily batch jobs and integrations to this point, with a side passion in iOS development for the past couple of years. Having a chance to do this project proved to myself that I do know what I'm doing when it comes to iOS, and I had a lot of fun implementing it.

