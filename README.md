# FetchCountries
iOS app to show global currencies for the countries

**Features:**

- Search the user country and show its details based on the user location.
- Search the default country(Egypt) is location permission is denied.
- Search for any country with its name.
- The ability to add up to five countries to the main view.
- Cache added countries so that showing them in offline mode.
- The ability to remove countries from the main view.
- The added country is never be shown in the search results so the user cannot add it again.
- The ability to add or remove countries from the details bottom sheet.
- The user can only add up to 5 countries.
- The ability to shown all saved countries in offline mode.

**Description:**

- Asking for the location permission in order to access the user location to be used to fetch the user country details, and if the user denies the permission, the default country is fetched which is Egypt
- The fetched country is being cached using file caching to be shown in offline mode.
- The user can press the bar item add button to navigate to the search view and start searching.
- Once the user presses add either from the list item or from the details bottom sheet, the country is added to cache and to the main view.
- If the connection is lost while being in the main view, a message is shown to the user to reconnect and also the add button in the tool bar is hidden.
- If the connection is lost while being in the search view, the search bar is disabled and the hint message is shown as well.
- All cached countries are shown in offline mode, but the user will not be able to search until the connection back.
  
**Technologies:**

- Project is written with SwiftUI, Modern Concurrency, Combine, and Clean Architecture with MVVM for the presentation layer.
- Files are used to the caching mechanism
