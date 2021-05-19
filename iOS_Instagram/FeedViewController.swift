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
                                                    // for each comment, get their author
        query.includeKeys(["author", "comments", "comments.author"])
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
        // posts.count + number of comments for ALL posts
        let post = posts[section]
        // if the left is nil ?? do [] default value
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []

        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            let user = post["author"] as! PFUser
            cell.usernameLabel.text = user.username
            cell.captionLabel.text = post["caption"] as! String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.postView.af_setImage(withURL: url)
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row-1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let post = posts[indexPath.section]
        
            // common object
        // PROPERTIES OF "Comments"
        // auto create the object
        let comment = PFObject(className: "Comments")
        comment["text"] = "Random comment"
        comment["post"] = post
        comment["author"] = PFUser.current()!
        
        // Relationship
        // have array of comments, and add the rest to array
        post.add(comment, forKey: "comments")
        
        //
        post.saveInBackground{(success, error) in
            if success {
                print("Comment saved")
            }else{
                print("error saving comment")
            }
        }
        
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
