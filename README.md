Swift client for the biird Api service.

Download the biird swift library from here:

https://github.com/biirdio/client-swift/blob/master/biird.swift

To change any dimension pass a dictionary to the shared Biird object.
<pre>
Biird.shared.defaultDimensions =  [language: "en", gender: "male"]
</pre>

Call Fetch to retrieve the values.

<pre>
Biird.shared.fetch(withId: "64b5e1fa-2891-4038-9ac1-b5adbc254846") { 
    (result) in self.imageView.image = result?.image
}
</pre>