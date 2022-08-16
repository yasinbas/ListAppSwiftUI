# ListAppSwiftUI for Patika.dev 


## CoreData -> delete all item in entity




```swift

            let appDelegate = UIApplication.shared.delegate as? AppDelegate
                       
                       let managedObjectContext = appDelegate?.persistentContainer.viewContext
                       
                       for item in self.data {
                           managedObjectContext?.delete(item)
                       }
                       
                       try? managedObjectContext?.save()
                       
                       self.fetch()
            
        }
    }
    
```

