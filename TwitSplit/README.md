# Note

`TweetViewModel` should takes advantage of the new Swift's `Substring`
By referring to the same `String`, it will reduce a huge amout of memory when processing user input messages.
Especially with a big trunk of data, observe the `performanceTest` and you'll see.

However, I could not fully implemented it.
There was a bug while working with `Substring` and `Substring.Index` that makes it unable to extract the correct `Tweet`'s content.
Unfortunately, `String.Index`, `Substring.Index` and `Range<String.Index>` are not producing debug-friendly message at this moment.
Therefore, I was unable to track it down to see if it is a programming error or Swift bug.

If you could found the error, please let me know by creating a pull request.
I would really appreciate it.
Thank you.

--- Xcode 9 beta 6 | Build 9M214v | Aug 21, 2017

