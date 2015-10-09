//
//  LineChartConstants.swift
//  Line Chart
//
//  Created by Vishal on 10/8/15.
//  Copyright © 2015 Vishal. All rights reserved.
//

import Foundation
import UIKit

let defaultDataPoints = [LineGraphDataPoint(xLabel: "Apr", value: 90), LineGraphDataPoint(xLabel: "May", value: 80), LineGraphDataPoint(xLabel: "Jun", value: 100), LineGraphDataPoint(xLabel: "Jul", value: 97), LineGraphDataPoint(xLabel: "Aug", value: 90), LineGraphDataPoint(xLabel: "Sep", value: 95), LineGraphDataPoint(xLabel: "Oct", value: 88)]

struct LineGraphDataPoint {
    var xLabel: String
    var value: CGFloat
    
    init(xLabel: String, value: CGFloat) {
        self.xLabel = xLabel
        if value > 100 {
            self.value = 100
        }
        else if value < 0 {
            self.value = 0
        }
        else {
            self.value = value
        }
    }
}

struct LineGraphDataSet {
    var lineData = [LineGraphDataPoint]()
    
    init(lineData: [LineGraphDataPoint]) {
        self.lineData = lineData
    }
    
    func maxDataPoint() -> LineGraphDataPoint {
        var maxDataPoint: LineGraphDataPoint = LineGraphDataPoint(xLabel: "", value: 0.0)
        for dataPoint in self.lineData {
            if dataPoint.value >= maxDataPoint.value {
                maxDataPoint = dataPoint
            }
        }
        return maxDataPoint
    }
}