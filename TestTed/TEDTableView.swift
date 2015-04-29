//
//  TEDTableViewController.swift
//  TestTed
//
//  Created by Ernest L.S. on 29.04.15.
//  Copyright (c) 2015 ErLS & Y. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class TEDTableView: UIViewController, UITableViewDataSource, UITableViewDelegate, ParserTEDDelegate, UIAlertViewDelegate {
	
	var parserTed: ParserTED!
	var selectedVideoURL: NSURL!

	@IBOutlet var tableTeds: UITableView!
	@IBOutlet weak var refreshBtn: UIBarButtonItem!
	@IBOutlet weak var reloadView: UIView!
	
	// MARK: -  Live
	
    override func viewDidLoad() {
        super.viewDidLoad()
		parserTed = ParserTED()
		parserTed!.delegate = self
		startLoadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
	
	override func viewDidAppear(animated: Bool) {

	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return parserTed.talksData.count
    }

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellTed", forIndexPath: indexPath) as! UITableViewCell

		let cellData = parserTed.talksData.objectAtIndex(indexPath.row) as! Talk
        cell.textLabel?.text = cellData.owner
		cell.detailTextLabel?.text = cellData.title
		cell.imageView?.image = cellData.image

        return cell
    }

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let cellData = parserTed.talksData.objectAtIndex(indexPath.row) as! Talk
		selectedVideoURL = cellData.video
		
		let avPlayerStory = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
		var avPlayer = avPlayerStory.instantiateViewControllerWithIdentifier("TEDPlayer") as! PlayerViewController
		avPlayer.player = AVPlayer(URL: selectedVideoURL)
		self.presentViewController(avPlayer, animated: true, completion: nil)
		avPlayer.player.play()
	}
	
	
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//		let destination = segue.destinationViewController as! AVPlayerViewController
//		destination.player = AVPlayer(URL: selectedVideoURL)
//    }
	
	@IBAction func reloadRSS(){
		refreshBtn.enabled = false
		parserTed.talksData.removeAllObjects()
		tableTeds.reloadData()
		reloadView.hidden = false
		var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("startLoadData"), userInfo: nil, repeats: false)
	}
	
	@IBAction func startLoadData(){
		parserTed?.startConnection("http://www.ted.com/themes/rss/id")
	}
	
	func endLoadData(){
		if !reloadView.hidden {
			reloadView.hidden = true
		}
		tableTeds.reloadData()
		refreshBtn.enabled = true
	}
	
	//MARK: - ParserTEDDelegate
	
	func parserDidEnd() {
		endLoadData()
	}
	
	func parseError() {
		UIAlertView(title: "Внимание", message: "Ошибка при загрузке данных. \n Проверьте подключение к Интернет.", delegate: nil, cancelButtonTitle: "Ok").show()
		endLoadData()
	}
	
	//MARK: - UIAlertViewDelegate
	
//	func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
//		if buttonIndex == 0{
//			endLoadData()
//		}
//	}
	
}
