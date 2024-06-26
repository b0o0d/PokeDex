# PokeDex

### Developing Environment
Xcode 15.3.0

### Architecture UML Diagram
![PokeDex drawio (2)](https://github.com/b0o0d/PokeDex/assets/14214264/59161234-7521-4488-b95e-b231e23e6fd7)

### Features
List
1. Display Pokemon ID, name, types, thumbnail image on List.
2. Touching on an entry should take the user to the Pokemon Detail page.
3. Automatic loading of additional Pokemon data as the user scrolls to the end of the list.
4. User can mark/unmark any Pokemon as favorite. And record in local storage in Core Data.
5. A filter button on List to display only favorite Pokemon.

Detail
1. Display Pokemon ID, name, types, image, evolution chain, description text
2. Touching on an evolution chain Pokemon should take the user to its detail page.
3. Allow users to mark/unmark Pokemon as favorite. And record in local storage in Core Data.

## Dependency Frameworks
### [Alamofire](https://github.com/Alamofire/Alamofire)
To make HTTP request easy. 
### [SDWebImage](https://github.com/SDWebImage/SDWebImage)
Async image downloader.
### [SnapKit](https://github.com/SnapKit/SnapKit)
To make Auto Layout easy.
### [swift-collections](https://github.com/apple/swift-collections)
To use queue(deque) to draw evolution chain.
