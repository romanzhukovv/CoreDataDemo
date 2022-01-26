//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Roman Zhukov on 25.01.2022.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    var taskList: [Task] = []

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    private init() {}

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() {
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try context.fetch(fetchRequest)
        } catch {
            print("Faild to fetch data", error)
        }
    }
    
    func saveTask(_ taskName: String) {
        let task = Task(context: context)
        task.name = taskName
        taskList.append(task)
        saveContext()
    }
    
    func editTask(_ newTaskName: String, at indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        task.name = newTaskName
        saveContext()
    }
    
    func deleteTask(at indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        taskList.remove(at: indexPath.row)
        context.delete(task)
        saveContext()
    }
}
