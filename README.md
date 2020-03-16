# ORMFitbod
Work assessment for the Fitbod interview process where we have to load workout data and display historic metrics of One Rep Max

## Installing

This project relies on a chart library to display the One Rep Max evolution of a single exercise installed through Cocoapods.

### Dependencies

* [SwiftCarts](https://github.com/i-schuetz/SwiftCharts) - the charts library used

The dependency manager used:
* [Cocoapods](https://cocoapods.org)

### Set Up

To inspect and run the project, first we will need to clone the project into a directory of choice:

```
$ cd /directory/of/choice/
$ git clone https://github.com/guillemgbt/ORMFitbod
```

Then, install the required dependencies using Cocoapods:

```
$ cd ORMFitbod/
$ pod install
```

Now we can open the ORMFitbod.xcworkspace file and run the project.

## Code and Project Structure

The code of the project has been developed using the MVVM architecture pattern. Furthermore, some pattern ideas from [Android Architecture Components](https://developer.android.com/topic/libraries/architecture) have been used and recreated into the iOS environment.

In this section we explain the main parts of the project, that represent the pattern blocks of the code design.

#### Utils
In this folder, it can be located some tools and other helpful code used in the along the application.

* **Theme**: A enumeration defining the disponible themes and their relative subset of colors has been developed. Thus, some extensions of UIView, UIViewController and UITableViewCell have been implemented to reuse code of this functionality.

* **Rx**: To make use of the Reactive Programming paradigm without using external libraries, some really simple reactive models have been developed.

* **PromiseObject**: Following the Android Architecture Componets, we created a generic parser object that represents asynchronous fetching of data objects consisting of a fetch status, the actual object (Nullable) and an optional message. This, combined with the Rx parser is used to propagate data requests among the different blocks of the app.


#### Services
Here we can locate the classes that represent the "Service" role. The Service role is responsible for retrieving data and serve it in a generic way into the "ViewModel" role classes. Our Service classes use the **singleton** pattern.

In this case, our "ExerciseService" delivers exercise models **asyncronously** using the **Grand Central Dispatch** by providing an Rx parser (Observable) that nests a PromiseObject that nests an array of "Exercises". The ExerciseService retreives the data from the workouts .txt files. To do that, an other class is used, the "WorkoutParser" so we achieve more modularity and testabilty. This way, if in the future the exercise data should be loaded from HTTP requests, we only would need to add an API parser in the ExerciseService but the way the data and status is propagated would not need to change.

The ExerciseSevice has a default attribute initializer of WorkoutParser so in the Unit Tests we can make use of **Dependency Injection** patterns to better evaluate it.

#### Models

The model class role encapsulates the data entities in the app. They lack of complex functionality because this is delegated to another class roles. In this project, we can find 
**UnitRecord** model, that represents the data of a single workout unit (sets, reps and weight). From this model we can compute the 1RM. The **DailyRecord** model
represents the daily unit records and records the maximum 1RM of the unit records that were done that day. This way we can easily map this information to a daily 1RM chart. Finally the **Exercise** model encapsulates all the daily records under the same exercise type.

#### Views

In this section of the project there are placed classes, .xibs and other resources related to the views.

* **Cells**: In here we define the table view cells of the project. Now we only have the cell class that represents a single exercise and its relative .xib file.
* **CellType** enumeration: For each view/section of the app that has a tableView, we create its CellType enumeration where each case is a type of cell that the table will display.
This enumeration is responsible of dequeuing the cells and pass model information to populate it. This way, the UI nature of this step is not handled in the ViewModel class and the model is not passed through the View class.
* **ViewModel**: This class role gathers the functionality and data processing that a view needs. This way those functionalities are decoupled from the view lifecycle and it is easy to test. The view model classes expose the observable parser we explained earlier so the view can "listen" to the view model changes and react accordingly. We have a view model for the Exercise list view and for the Exercise chart view.
* **View**: This class roles gathers the UI tasks, but the data is provided and previously processed by their relative view model. We have a view for the Exercise list and for the Exercise chart.

## Adding a new workout .txt file

To add new workout .txt files, first you will need to add the new .txt files into the project, under the "resources" directory. Each .txt file is mapped into an enumeration. So for each new .txt file, you will need to add a new enumeration in "WorkoutParser.swift" under the "WorkoutFile" enumeration.

```
enum WorkoutFile: String {
    case workout1 = "workoutData1"
    
    case yourNewWorkout = "newWorkoutFile"
    
    // For testing purposes
    case invalidWorkout = "workoutDataInvalidLine"
    case nonExistingWorkout = "nonExistingWorkout"
}
```

Then in the same file, modify the function definition
```
func parse(file: WorkoutFile = .workout1)
```

so the default workout file is the one you want to use.

## Unit tests

There are 40 unit tests that cover a good part of the functionalities of the app such as  the Rx Observable parsers defined in this project, the Workour parser, the ExerciseService, the two ViewModels and more. 

**Dependency Injection** is achieved by default initializers of the classes we want to test. In the test cases the class we want to test is instantiated with the appropriate "Mock" of its dependency so we can test different behaviours and scenarios.

