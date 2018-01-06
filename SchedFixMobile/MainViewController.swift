//
//  ViewController.swift
//  SchedFixMobile
//
//  Created by Paul Colusso on 9/11/16.
//  Copyright © 2016 Paul Colusso. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    let em = EventFixManager.sharedInstance
    //@IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(MainViewController.refreshTriggered(sender:)), for: UIControlEvents.valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !em.eventFixer.isAuthorised() {
            em.eventFixer.requestAuthorisation(completion: {_,_  in})
        }
        refresh()
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func refresh() {
        tableView.reloadData()
    }
    
    @IBAction func fixAction(_ sender: UIBarButtonItem) {
        em.eventFixer.fixEvents()
        refresh()
    }
    
    @objc func refreshTriggered(sender: UIRefreshControl) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
            self.refresh()
            sender.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return em.eventFixer.listEvents().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        cell.textLabel?.text = em.eventFixer.listEvents()[indexPath.row]
        return cell
    }
}
