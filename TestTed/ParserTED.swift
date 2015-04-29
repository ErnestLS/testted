//
//  ViewController.swift
//  TedChildren
//
//  Created by Ernest L.S. on 27.04.15.
//  Copyright (c) 2015 ErLS & Y. All rights reserved.
//

import UIKit

protocol ParserTEDDelegate
{
	 func parserDidEnd()
	 func parseError()
}

class ParserTED: NSObject, NSURLConnectionDelegate, NSXMLParserDelegate {
	var delegate: ParserTEDDelegate?
	
	var talksData = NSMutableArray()
	var mediaData = false
	var talkDATA = Talk()
	var stringData = String()
	
	
	func startConnection( path: String){
		let url = NSURL(string: path)
		var parser: NSXMLParser  = NSXMLParser(contentsOfURL: url)!
		parser.delegate = self
		parser.shouldProcessNamespaces = true
		parser.shouldReportNamespacePrefixes = true
		parser.shouldResolveExternalEntities = false
		let success = parser.parse()
		
	}
	
	// MARK: - NSXMLParserDelegate
	
	func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
		//		println("Element - \(qName)")
		if qName! == "item"{
			talkDATA = Talk()
		}
		else{
			let dic = attributeDict as NSDictionary
			switch  qName! {
			case "enclosure":
				let videoURL = NSURL(string: dic.valueForKey("url") as! String)
				talkDATA.video = videoURL!
				break
			case "media:thumbnail":
				let imageURL = NSURL(string: dic.valueForKey("url") as! String)
				let imageData = NSData(contentsOfURL: imageURL!)
				talkDATA.image = imageData != nil ? UIImage(data: imageData!) : UIImage(named: "unknown.jpg")
				break
			default: break
			}
		}
	}
	
	func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		switch  qName! {
		case"item":
			talksData.addObject(talkDATA)
			break
		case "title":
			//			println("Title - \(stringData)")
			talkDATA.owner = stringData
			break
		case "description":
			//			println("Description - \(stringData)")
			talkDATA.title = stringData
			break
		default: break
		}
	}
	
	func parser(parser: NSXMLParser, foundCharacters string: String?) {
		stringData = string!
	}
	
	func parserDidStartDocument(parser: NSXMLParser) {
//		println("ПАРСИНГ начат!")
	}

	func parserDidEndDocument(parser: NSXMLParser) {
//		println("ПАРСИНГ завершен!")
		for var c = 0; c < talksData.count; ++c{
			let d = talksData.objectAtIndex(c) as! Talk
		}
		delegate!.parserDidEnd()
	}
	
	func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
		println(parseError)
		delegate!.parseError()
	}
	
}

