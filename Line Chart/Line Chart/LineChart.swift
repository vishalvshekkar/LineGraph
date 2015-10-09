//
//  LineChart.swift
//  Line Chart
//
//  Created by Vishal on 10/7/15.
//  Copyright © 2015 Vishal. All rights reserved.
//

import UIKit

@IBDesignable class LineChart: UIView {
    
    //MARK:- Color Properties
    @IBInspectable var graphBackgroundColor: UIColor = UIColor.clearColor() {
        didSet {
            self.backgroundColor = graphBackgroundColor
        }
    }
    @IBInspectable var startColor: UIColor = UIColor(red:0.27, green:0.7, blue:0.65, alpha:1.0)
    @IBInspectable var endColor: UIColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:0.3)
    @IBInspectable var graphLineColor: UIColor = UIColor.whiteColor()
    @IBInspectable var gridColor: UIColor = UIColor(red:0.24, green:0.24, blue:0.24, alpha:1)
    @IBInspectable var gridFontColor: UIColor = UIColor(red:0.36, green:0.36, blue:0.36, alpha:1)
    @IBInspectable var xLabelFontColor: UIColor = UIColor(white: 1.0, alpha: 1.0)
    
    //MARK: - Margins and Borders
    @IBInspectable var horizontalPadding: CGFloat = 0
    @IBInspectable var leftGraphMargin: CGFloat = 20
    @IBInspectable var rightGraphMargin: CGFloat {
        return graphPointDiameter/2
    }
    @IBInspectable var topGraphMargin: CGFloat {
        return (self.frame.height - bottomGraphMargin)/10
    }
    @IBInspectable var bottomGraphMargin: CGFloat = 40
    
    //MARK: - Thickness and Line Widths
    @IBInspectable var graphPointDiameter: CGFloat = 8.0
    @IBInspectable var graphLineWidth: CGFloat = 1.5
    @IBInspectable var gridLineWidth: CGFloat = 1.0
    @IBInspectable var graphIndicatorFont: UIFont = UIFont.systemFontOfSize(10.0)
    @IBInspectable var graphXLabelFont: UIFont = UIFont.systemFontOfSize(12)
    
    var dataPoints: [LineGraphDataPoint] = defaultDataPoints
    let maxValue: CGFloat = 100.0
    var maxDataPoint: CGFloat {
        var maxData: CGFloat = 0
        for items in dataPoints {
            if items.value >= maxData {
                maxData = items.value
            }
        }
        return maxData
    }
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Graphics and drawings
    
    override func drawRect(rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        let graphWidth = rect.width - 2 * horizontalPadding - rightGraphMargin - leftGraphMargin
        let graphHeight = rect.height - topGraphMargin - bottomGraphMargin

        let linePath = UIBezierPath()
        
        //top line
        let lineSpacing = graphHeight/10.0
        for count in 0...10 {
            linePath.moveToPoint(CGPoint(x: horizontalPadding, y: topGraphMargin + (CGFloat(count) * lineSpacing)))
            linePath.addLineToPoint(CGPoint(x: width - horizontalPadding, y: topGraphMargin + (CGFloat(count) * lineSpacing)))
            if count == 0 || count == 5 || count == 10 {
                let label = UILabel(frame: CGRect(x: horizontalPadding, y: topGraphMargin + (CGFloat(count - 1) * lineSpacing), width: leftGraphMargin, height: lineSpacing))
                self.addSubview(label)
                label.textColor = gridFontColor
                label.font = graphIndicatorFont
                label.minimumScaleFactor = 0.9
                label.adjustsFontSizeToFitWidth = true
                if count == 0 {
                    label.text = "100"
                }
                else if count == 5 {
                    label.text = "50  "
                }
                else {
                    label.text = "0   "
                }
            }
        }
        
        let color = gridColor
        color.setStroke()
        
        linePath.lineWidth = gridLineWidth
        linePath.stroke()
        
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations:[CGFloat] = [0.2, 1.0]
        
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x:0, y:self.bounds.height)
//        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, [])
        
        let margin: CGFloat = 10.0
        
        
        
        let columnXPoint = { (column: Int) -> CGFloat in
            let spacer = (graphWidth - self.graphPointDiameter)/CGFloat((self.dataPoints.count - 1))
            var x: CGFloat = 0
            if column == 0 {
                x = 0
            }
            else {
                x = CGFloat(column) * spacer
            }
            x += self.horizontalPadding + self.leftGraphMargin + self.graphPointDiameter/2
            return x
        }

        
        let columnYPoint = { (graphPoint: CGFloat) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) / CGFloat(self.maxValue) * graphHeight
            y = graphHeight + self.topGraphMargin - y // Flip the graph
            return y
        }
        
        
        //Adding Graph lines based on graph data
        graphLineColor.setFill()
        graphLineColor.setStroke()
        
        let graphPath = UIBezierPath()
        graphPath.moveToPoint(CGPoint(x:columnXPoint(0), y:columnYPoint(dataPoints[0].value)))
        for i in 1..<dataPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(dataPoints[i].value))
            graphPath.addLineToPoint(nextPoint)
        }
        
        //save the state of the context (commented out for now)
        CGContextSaveGState(context)
        
        //making a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //add lines to the copied path to complete the clip area
        clippingPath.addLineToPoint(CGPoint(
            x: columnXPoint(dataPoints.count - 1),
            y:height))
        clippingPath.addLineToPoint(CGPoint(
            x:columnXPoint(0),
            y:height))
        clippingPath.closePath()
        
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxDataPoint)
        startPoint = CGPoint(x:margin, y: highestYPoint)
        endPoint = CGPoint(x:margin, y: self.bounds.height - bottomGraphMargin)
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, [])
        CGContextRestoreGState(context)
        graphPath.lineWidth = graphLineWidth
        graphPath.stroke()
        
        for i in 0..<dataPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(dataPoints[i].value))
            let xLabelWidth: CGFloat = (graphWidth - self.graphPointDiameter)/CGFloat((self.dataPoints.count - 1)) //(horizontalPadding + rightGraphMargin)*2
            let xLabelHeight: CGFloat = bottomGraphMargin/2
            let xLabel = UILabel()
            xLabel.font = graphXLabelFont
            xLabel.minimumScaleFactor = 0.1
            xLabel.adjustsFontSizeToFitWidth = true
            xLabel.text = dataPoints[i].xLabel
            if i == dataPoints.count - 1 {
                let temporaryWidth = width - (point.x - xLabelWidth/2)
                if temporaryWidth <= xLabelWidth {
                    xLabel.frame = CGRect(x: (point.x - xLabelWidth/2), y: height - (bottomGraphMargin + xLabelHeight)/2, width: width - (point.x - xLabelWidth/2), height: xLabelHeight)
                }
                else {
                    xLabel.frame = CGRect(x: (point.x - xLabelWidth/2), y: height - (bottomGraphMargin + xLabelHeight)/2, width: xLabelWidth, height: xLabelHeight)
                }
                xLabel.textAlignment = .Center
            }
            else {
                xLabel.frame = CGRect(x: (point.x - xLabelWidth/2), y: height - (bottomGraphMargin + xLabelHeight)/2, width: xLabelWidth, height: xLabelHeight)
                xLabel.textAlignment = .Center
            }
            xLabel.textColor = xLabelFontColor
            point.x -= graphPointDiameter/2
            point.y -= graphPointDiameter/2
            self.addSubview(xLabel)
            let circle = UIBezierPath(ovalInRect: CGRect(origin: point, size: CGSize(width: graphPointDiameter, height: graphPointDiameter)))
            circle.fill()
        }
        
        
    }
    
    //MARK: - Awake from Nib
    override func awakeFromNib() {
        self.backgroundColor = graphBackgroundColor
    }

}

