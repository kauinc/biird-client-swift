Biird.shared.defaultDimensions =  [language: "en", gender: "male"]

Biird.shared.fetch(withId: "3f2728d1-250b-4d15-8b3c-ba1f2dc033f3") { (result) in
            self.imageView.image = result?.image
        }