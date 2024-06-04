# Proton_Test
I refactored the code using a MVVM+C approach

Model - View - ViewModel - Coordinator (router)

In my opinion this architecture gives the best combination of separation, testability and scalability.
I've also adopted a protocol oriented approach with dependency injection. This solution is a close as possible to a proper SOLID adoption as well allowing for easy mocking whilst testing.

I wanted to show how, even in a simple project as this, adoption a clean structure and decoposing the right components easily allow to expand, or repacle, parts of the architecture with a decend level of safety (given by interfaces).

## NOTES:
* I left the UX very simple on purpose, considering the time, and the constraints using autoLayout and UIKit, I didn't want to waste time on too much decoration
* I removed Storyboard, for personal preference, but also to improve scalability, .xibs are too prone to conflicts if more developers work on a project
* Due to time restrictions I didn't, on purpose, fully test the project, but you can see my approach in the unit tests for the main screen (WeekWeatherViewModel)
* I was considering refactoring the entire project to SwiftUI, this would have sped up the UI developement but also, using Combine, simplify the logic. I wasn't sure sticking with UIKit was a requirement so I used what I was given
* I didn't implement any caching logic besides the one provided by default by URLSession. Considering the data structure I would have modified the model struct to be Codable so that I could have easily converted it into a file and save it on the device. Using CoreData or any other DB would have been an overkill.

### PREVIEW
![proton mov](https://github.com/Tbruni85/Proton_Test/assets/13588914/47a0c9d8-4316-4c91-8311-bece13251db3)
