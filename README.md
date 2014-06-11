codepath-rotten-tomatoes
========================

Rotten Tomatoes App for Codepath.

How many hours did it take to complete?

~ 18. I really struggled implementing the third party loading library. I was trying to use https://github.com/Marxon13/M13ProgressSuite and the lack of documentation/relevant examples took up a lot of my time. I ended up using a much simpler version. I was also trying to TDD everything at first but realized it was taking too much time so I scraped it.

Which required and optional stories have you completed?

- User can view a list of movies from Rotten Tomatoes.  Poster images must be loading asynchronously.
- User can view movie details by tapping on a cell
- User sees loading state while waiting for movies API.  You can use one of the 3rd party libraries here.
- User sees error message when there's a networking error.  You may not use UIAlertView to display the error.
- User can pull to refresh the movie list.
- All images fade in (optional)
- For the large poster, load the low-res image first, switch to high-res when complete (optional)
- All images should be cached in memory and disk. In other words, images load immediately upon cold start (optional).

GIF walkthrough of all required and optional stories:

![alt tag](rotten-tomatoes.gif)
