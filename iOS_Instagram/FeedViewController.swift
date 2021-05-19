//
//  FeedViewController.swift
//  iOS_Instagram
//
//  Created by Sophia Lui on 5/7/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        // refresh again
        super.viewDidAppear(animated)
        
        // Activate query
        // creating the clsas
        let query = PFQuery(className: "Posts")
        
        // include key
        query.includeKey("author")
        query.limit = 20; // last 20
        query.findObjectsInBackground{ (posts, error) in
            // store data
            if posts != nil{
                // refresh
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
        
        
    }
    // These two are required for data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[indexPath.row]
   
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        
        cell.captionLabel.text = post["caption"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.postView.af_setImage(withURL: url)
        return cell
    }
    
    @IBAction func onLogoutBtn(_ sender: Any) {
        PFUser.logOut() // clear parse cache
        
        //switch back to login screen
        // grab storyboard/parse xml
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewConrtroller")
        
        //let delegate = UIApplication.shared.delegate as! SceneDelegate
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate
          else {
            return
          }
        
        delegate.window?.rootViewController = loginViewController
    
    
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
