//
//  EventViewController.swift
//  Tower Raiders
//
//  Created by Joseph Van Heurck on 27/4/18.
//  Copyright © 2018 Joseph Van Heurck. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    var eventType: placeEvent?
    
    @IBOutlet weak var Lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if eventType == .treasure {
            Lbl.text = "Treasure Event"
        }
        else if eventType == .end {
            Lbl.text = "END"
        }
        else {
            eventType = .none
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
