//
//  ContextManager.swift
//  TGMovve
//
//  Created by ALEKSEY SUSLOV on 03.09.2022.
//

import UIKit
import CoreData

class ContextManager {
    static let shared = ContextManager()
    private init() {}
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func delete(content: Content) {
        context.delete(content)
        saveContext()
    }
    
    func fetchContents() -> [Content]? {
        let request: NSFetchRequest<Content> = Content.fetchRequest()
        
        do {
            let contents = try context.fetch(request)
            return contents
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        return nil
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func isDataMatchesWith(title: String) -> Bool? {
        let request: NSFetchRequest<Content> = Content.fetchRequest()
        request.predicate = NSPredicate(format: "title MATCHES[cd] %@", title)
        
        do {
            let contents = try context.fetch(request)
            if contents.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        return nil
    }
    
    func deleteIfMatches(title: String) -> Bool? {
        let request: NSFetchRequest<Content> = Content.fetchRequest()
        request.predicate = NSPredicate(format: "title MATCHES[cd] %@", title)
        
        do {
            let contents = try context.fetch(request)
            if contents.count > 0 {
                delete(content: contents.first!)
                return true
            } else {
                return false
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        return nil
    }
    
    
}
