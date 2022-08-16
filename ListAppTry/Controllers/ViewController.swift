//
//  ViewController.swift
//  ListAppTry
//
//  Created by Yasin Baş on 16.08.2022.
//

import UIKit

import CoreData

class ViewController: UIViewController  {
    
    var alertController = UIAlertController()
    @IBOutlet weak var tableView:UITableView!
    
    var data  = [NSManagedObject]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource =  self
        fetch()
        
        
        
        
        
        
    }
    
    
    
    
    
    @IBAction func didRemoveBarButtonItemTapped (_ sender:UIBarButtonItem){
        
        
        
        presentAlert(title: "Uyarı !",
                     message: "Listedeki bütün elemanarı silmek istediğinizden emin misiniz ?",
                     defaultButtonTitle: "Ok",
                     canleButtonTitle: "İptal") { _ in
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
                       
                       let managedObjectContext = appDelegate?.persistentContainer.viewContext
                       
                       for item in self.data {
                           managedObjectContext?.delete(item)
                       }
                       
                       try? managedObjectContext?.save()
                       
                       self.fetch()
            
        }
    }
    @IBAction func didAddBarButtonItemTapped(_ sender:UIBarButtonItem){
        
        presentAddAlert()
        
        
        
    }
    
    
    func presentAddAlert (){
        
        presentAlert(title: "Yeni Eleman Ekle",
                     message: nil,
                     defaultButtonTitle:"Ekle",
                     canleButtonTitle: "Vazgeç",
                     isTextFieldAvaliable:true,
                     defaultButtonHandler: { _ in
            let text = self.alertController.textFields?.first?.text
            
            if text != "" {
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                
                let managedObjectContext = appDelegate?.persistentContainer.viewContext
                
                
                let entity = NSEntityDescription.entity(forEntityName: "ListItem",
                                                        in: managedObjectContext!)
                
                let ListItem = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
                
                
                //                let listItem = NSManagedObject(entity: entity!,
                //                                               insertInto: managedObjectContext)
                
                ListItem.setValue(text, forKey: "title")
                
                try? managedObjectContext?.save()
                
                
                
                self.fetch()
            } else {
                self.presentWarningAlert()
                
            }
        })
    }
    
    
    func presentWarningAlert (){
        
        
        presentAlert(title: "Uyarı !",
                     message: "Liste elemanı boş olamaz.",
                     canleButtonTitle: "Tamam")
    }
    
    
    func presentAlert (title:String? ,
                       message:String?,
                       preferredStyle:UIAlertController.Style = .alert ,
                       defaultButtonTitle:String? = nil,
                       canleButtonTitle:String?,
                       isTextFieldAvaliable:Bool = false ,
                       defaultButtonHandler :((UIAlertAction)-> Void)? = nil
                       
    )  {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: preferredStyle)
        
        
        
        if defaultButtonTitle != nil {
            let defaultButton = UIAlertAction(title: defaultButtonTitle,
                                              style: .default,
                                              handler: defaultButtonHandler)
            alertController.addAction(defaultButton)
            
        }
        
        
        
        
        let canelButton = UIAlertAction (title: canleButtonTitle,
                                         style: .cancel)
        
        
        if isTextFieldAvaliable {
            alertController.addTextField()
        }
        
        
        
        alertController.addAction(canelButton)
        present(alertController, animated: true)
    }
    
    func fetch(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        
        let fethcRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        
        data = try! managedObjectContext!.fetch(fethcRequest)
        tableView.reloadData()
    }
    
    
}

extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        
        let listItem = data [indexPath.row]
        
        cell.textLabel?.text = listItem.value(forKey: "title") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "Sil") { _, _, _ in
            //            self.data.remove(at: indexPath.row)
            
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            
            managedObjectContext?.delete(self.data[indexPath.row])
            
            
            try? managedObjectContext?.save()
            
            
            self.fetch()
        }
        deleteAction.backgroundColor = .systemRed
        
        
        let editAciton = UIContextualAction(style: .normal,
                                            title: "Düzenle") { _, _, _ in
            self.presentAlert(title: "Elemanı Düzenle",
                              message: nil,
                              defaultButtonTitle:"Düzenle",
                              canleButtonTitle: "Vazgeç",
                              isTextFieldAvaliable:true,
                              defaultButtonHandler: { _ in
                let text = self.alertController.textFields?.first?.text
                
                if text != "" {
                    //  self.data[indexPath.row] = text!
                    
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    
                    
                    let managedObjectContext = appDelegate?.persistentContainer.viewContext
                    
                    self.data[indexPath.row].setValue(text, forKey: "title")
                    
                    if managedObjectContext!.hasChanges{
                        try? managedObjectContext?.save()
                    }
                    
                    self.tableView.reloadData()
                } else {
                    self.presentWarningAlert()
                    
                }
            })
            
        }
        
        
        
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction,editAciton])
        return config
    }
}
