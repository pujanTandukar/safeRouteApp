//
//  TableViewModalController.swift
//  SafeRoute
//
//  Created by Pujan Tandukar on 4/18/19.
//  Copyright © 2019 Pujan Tandukar. All rights reserved.
//

import UIKit

struct cellData {
    let text: String!
//    let image: UIImage!
}

class TableViewModalController: UITableViewController {
    
    var arrayOfData = [cellData]()
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        arrayOfData = [ cellData(text: "One", image: #imageLiteral(resourceName: "andy-vladimir-gorsky-loganfineartsdotcom")), cellData(text: "Two", image: #imageLiteral(resourceName: "andy-vladimir-gorsky-loganfineartsdotcom")), cellData(text: "Three", image: #imageLiteral(resourceName: "andy-vladimir-gorsky-loganfineartsdotcom"))]
        
        arrayOfData = [ cellData(text: "One"), cellData(text: "Two"), cellData(text: "Three")]
        
        view.layer.cornerRadius = 10
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ModalViewController.panGesture))
        view.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animating the bottom sheet appearance
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 200
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
    }
    
    // Add blur and vibrancy effects
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)
    }
    
    // Gesture behaviour
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        let velocity = recognizer.velocity(in: self.view)
        
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView - 200, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
            }, completion: nil)
        }
    }
    
    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.textLabel?.text = arrayOfData[indexPath.row].text
//        cell.labelView.text = arrayOfData[indexPath.row].text
//        cell.imageView?.image = arrayOfData[indexPath.row].image

        // Configure the cell...

//        return cell as UITableViewCell
        return cell as UITableViewCell
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
