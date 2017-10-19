//
//  AlbumListViewController.swift
//  RealmTest
//
//  Created by Pang on 2017. 10. 18..
//

import UIKit
import RealmSwift

class AlbumListViewController: UITableViewController, UISearchBarDelegate {

    private var realm: Realm!
    private var albums: Results<Album>!
    private var token: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Realm init
        do {
            realm = try Realm()
        } catch {
            print("\(error)")
        }
        // get Album objects
        albums = realm.objects(Album.self).sorted(byKeyPath: "saveDate", ascending: false)
        // add notification block
        token = albums.observe({ (change) in
            self.tableView.reloadData()
        })
    }
    @IBAction func addNewAlbum(_ sender: Any) {
         alertForAlbumTitle(albumToBeUpdated: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell", for: indexPath) as! AlbumTableViewCell
        if let imageData = albums[indexPath.row].photos.sorted(byKeyPath: "saveDate", ascending: false).first?.imageData {
            cell.photo.image = UIImage(data: imageData, scale: 0.1)
        }
        cell.title.text = albums[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Photos", sender: albums[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // realm delete
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (deleteAction, indexPath) in
            do {
                try self.realm.write {
                    self.realm.delete(self.albums[indexPath.row].photos)
                    self.realm.delete(self.albums[indexPath.row])
                }
            } catch {
                print("\(error)")
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (editAction, indexPath) in
            self.alertForAlbumTitle(albumToBeUpdated: self.albums[indexPath.row])
        }
        return [deleteAction, editAction]
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let photoCollectionView = segue.destination as! PhotoCollectionViewController
        photoCollectionView.selectedAlbum = sender as! Album
    }

    // Realm add and update
    func alertForAlbumTitle(albumToBeUpdated: Album?) {
        let alertController = UIAlertController(title: "Album", message: "Insert Album Title", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            if albumToBeUpdated != nil {
                textField.text = albumToBeUpdated?.title
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            let inputTitle = alertController.textFields?.first?.text
            if albumToBeUpdated != nil {
                // update album
                // use primary-key
                // let album = ["uuid": albumToBeUpdated?.uuid, "title": inputTitle]
                do {
                    try self.realm.write {
                        albumToBeUpdated?.title = inputTitle!
                        // when use primary-key
                        // self.startRealm.create(Album.self, value: album, update: true)
                    }
                } catch {
                    print("\(error)")
                }
            } else {
                // add new album
                let newAlbum = Album()
                newAlbum.title = inputTitle!
                do {
                    try self.realm.write {
                        self.realm.add(newAlbum)
                    }
                } catch {
                    print("\(error)")
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Realm Filter
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        albums = realm.objects(Album.self).filter("title contains[c] %@", searchText).sorted(byKeyPath: "saveDate", ascending: false)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
