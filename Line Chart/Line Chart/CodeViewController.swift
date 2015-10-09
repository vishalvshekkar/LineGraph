//
//  CodeViewController.swift
//  Line Chart
//
//  Created by Vishal on 10/8/15.
//  Copyright © 2015 Vishal. All rights reserved.
//

import UIKit

class CodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        let myGraph = LineChart(frame: CGRect(x: 20, y: 40, width: 350, height: 250))
        myGraph.dataPoints = [LineGraphDataPoint(xLabel: "Apr", value: 0), LineGraphDataPoint(xLabel: "May", value: 20), LineGraphDataPoint(xLabel: "Jun", value: 40), LineGraphDataPoint(xLabel: "Jul", value: 60), LineGraphDataPoint(xLabel: "Aug", value: 0), LineGraphDataPoint(xLabel: "Sep", value: 100), LineGraphDataPoint(xLabel: "Oct", value: 0)]
        view.addSubview(myGraph)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
