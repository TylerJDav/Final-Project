# Pantry Inventory Manager
Allows a user to manage what is in their pantry,
and generate recipes based on an item in the pantry inventory list.

Known bugs: sometimes updating the database will not update the name and brand of an item;
    pantry items with spaces in their name may not load a recipe web view
    
# Classes
## 1. PantryViewController.swift
### Properties:
tableView (IBOutlet): A table view displaying the pantry items.
pantryItems: An array storing pantry items fetched from the database.
itemsDBManager: An instance of ItemsDBManager for database operations.
### Methods:
viewDidLoad(): Overrides the default method to perform additional setup after loading the view.
tableView(_:numberOfRowsInSection:): Implements the UITableViewDataSource method to specify the number of rows in the table view.
tableView(_:cellForRowAt:): Implements the UITableViewDataSource method to provide cells for the table view.
tableView(_:didSelectRowAt:): Implements the UITableViewDelegate method to handle row selection.
prepare(for:sender:): Overrides the method to prepare for a segue and pass data to the next view controller.
editButtonTapped(_:): Handles the tap event for the edit button.
deleteButtonTapped(_:): Handles the tap event for the delete button.
addButtonTapped(_:): Handles the tap event for the add button.
fetchPantryItems(): Fetches pantry items from the database and updates the UI.

## 2. AddToPantryViewController.swift
### Properties:
editedItem: A tuple representing the item being edited.
editMode: A boolean indicating whether the view is in edit mode.
foodNameTextField (IBOutlet): A text field for the food name.
foodBrandTextField (IBOutlet): A text field for the food brand.
caloriesTextField (IBOutlet): A text field for calories.
proteinGramsTextField (IBOutlet): A text field for protein grams.
carbGramsTextField (IBOutlet): A text field for carb grams.
fatGramsTextField (IBOutlet): A text field for fat grams.
servingsTextField (IBOutlet): A text field for servings.
### Methods:
viewDidLoad(): Overrides the default method to perform additional setup after loading the view.
saveButtonTapped(_:): Handles the tap event for the save button.
backButtonTapped(_:): Handles the tap event for the back button.

## 3. ItemsDBManager.swift
### Properties:
db: An OpaquePointer representing the SQLite database.
### Methods:
addItem(name:brand:calories:protein:carbs:fat:servings:): Adds a new item to the database.
readItem(withId:): Reads an item from the database based on its ID.
readAllItems(): Reads all items from the database.
updateItem(id:name:brand:calories:protein:carbs:fat:servings:): Updates an existing item in the database.
deleteItem(withId:): Deletes an item from the database based on its ID.
clearDatabase(): Clears all records from the database.
resetDatabase(): Drops and recreates the table, populating it with default items.

## 4. RecipeViewController.swift
### Properties:
recipeNameLabel (IBOutlet): A label displaying the name of the recipe.
recipeLinkButton (IBOutlet): A button to link to the recipe's URL.
webView (WKWebView): A web view to display the recipe's URL.
recipeAPIManager: An instance of RecipeAPIManager for fetching recipes.
pantryItem: A tuple representing the randomly selected pantry item.
### Methods:
viewDidLoad(): Overrides the default method to perform additional setup after loading the view.
fetchRandomPantryItem(): Fetches a random item from the pantry database.
fetchRecipes(): Fetches recipes using the pantry item name as a keyword.
recipeLinkButtonTapped(_:): Handles the tap event for the recipe link button.

## 5. ViewController.swift
### Properties:
- `databaseManager`: An optional instance of `DatabaseManager` for handling database operations.
### Methods:
- `viewDidLoad()`: Overrides the default method to perform additional setup after loading the view.
- `setupDatabaseManager()`: Initializes the shared `DatabaseManager` instance.
- `showAlert(message:)`: Displays a success alert with a provided message.
### Overview:
The `ViewController` class is a view controller in the iOS application responsible for handling the main user interface and interactions. It primarily deals with initializing the `DatabaseManager` and providing a method to display success alerts.
### Usage:
1. **Initialization:** The `DatabaseManager` instance is initialized in the `viewDidLoad` method.
2. **Alert Presentation:** The `showAlert` method can be used to present a simple success alert to the user.

## 6. DatabaseManager.swift
### Properties:
- `shared`: A singleton instance of `DatabaseManager` accessible throughout the application.
- `db`: An OpaquePointer representing the SQLite database.
### Methods:
- `init()`: Initializes a `DatabaseManager` instance and opens the SQLite database.
- `deinit`: Closes the SQLite database when the instance is deallocated.
- `copyItemsToShoppingList()`: Copies items from the `FoodItems` table to the `ShoppingItems` table.
- `executeSQLStatement(_:)`: Executes a provided SQL statement on the database.
### Overview:
The `DatabaseManager` class is responsible for managing interactions with the SQLite database in the iOS application. It provides methods for initialization, deinitialization, copying items between tables, and executing SQL statements.
### Usage:
1. **Initialization:** The `shared` property provides access to a shared instance of `DatabaseManager` throughout the application.
2. **Database Operations:** Methods like `copyItemsToShoppingList` can be used for specific database operations.
3. **SQL Execution:** The `executeSQLStatement` method allows the execution of custom SQL statements on the database.
### Error Handling:
The class defines a custom `DatabaseError` enum for handling database-related errors.
### Notes:
- The `init` method opens the SQLite database, and `deinit` closes it when the instance is deallocated.
- The `copyItemsToShoppingList` method copies items from `FoodItems` to `ShoppingItems` where servings are 0.
- Error handling is implemented through the `DatabaseError` enum.

## 7. ShoppingListManager.swift
### Properties:
- `db`: An OpaquePointer representing the SQLite database, obtained from `DatabaseManager.shared`.
### Methods:
#### Create Item
- `addItem(name:quantity:)`: Adds a new item to the `ShoppingItems` table.
#### Read Item
- `readItem(withId:)`: Retrieves an item from the `ShoppingItems` table based on its ID.
#### Update Item
- `updateItem(id:name:quantity:)`: Updates an existing item in the `ShoppingItems` table.
#### Delete Item
- `deleteItem(withId:)`: Deletes an item from the `ShoppingItems` table based on its ID.
#### Clear Database
- `clearDatabase()`: Clears all records from the `ShoppingItems` table.
#### Reset Database
- `resetDatabase()`: Drops and recreates the `ShoppingItems` table, populating it with default items.
#### Query DB
- `executeSQLStatement(_:)`: Executes a provided SQL statement on the database.
### Overview:
The `ShoppingListManager` class manages shopping list-related operations on the SQLite database. It includes methods for creating, reading, updating, and deleting items, as well as clearing and resetting the database.
### Usage:
1. **Initialization:** The `db` property is set to the SQLite database obtained from `DatabaseManager.shared`.
2. **Database Operations:** Methods like `addItem` and `deleteItem` perform specific operations on the shopping list database.
3. **Database Maintenance:** `clearDatabase` can be used to remove all items, and `rese

## 8. RecipeAPIManager.swift
### Properties:
- `shared`: A static instance of the `APIManager` class for shared usage.
- `baseURL`: The base URL for the Edamam Recipe API.
- `appID`: The application ID for authentication with the Edamam API.
- `appKey`: The application key for authentication with the Edamam API.
- `mealType`: The meal type for filtering recipes.
### Methods:
#### Fetch Recipes
- `fetchRecipes(with:completion:)`: Fetches recipes from the Edamam Recipe API based on provided keywords.
### Helper Methods:
- `makeURL(with:)`: Constructs a URL for making API requests.
### Overview:
The `APIManager` class facilitates communication with the Edamam Recipe API. It provides a method, `fetchRecipes`, to retrieve recipes based on keywords. The class utilizes the shared instance pattern for easy access.
### Usage:
1. **Shared Instance:** Access the shared instance using `APIManager.shared`.
2. **Fetch Recipes:** Call `fetchRecipes` to obtain recipes based on specified keywords.
3. **API Authentication:** The `appID` and `appKey` properties are used for authentication with the Edamam API.
### Helper Method:
- `makeURL(with:)`: Constructs a URL for making API requests based on provided keywords.
### Response Structure:
The API returns data in the form of a `RecipeResponse` struct, containing an array of `Hit` instances, each encapsulating a `Recipe` with label, ingredient lines, and URL.
### Error Handling:
Errors during API interactions are propagated through the `completion` closure for handling.
