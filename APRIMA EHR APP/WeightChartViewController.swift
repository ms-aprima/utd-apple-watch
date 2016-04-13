//
//  WeightChartViewController.swift
//  APRIMA EHR APP
//
//  Created by Timmy on 4/11/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit
import Charts

class WeightChartViewController: UIViewController {

    @IBOutlet weak var weightLineChartView: LineChartView!
    var months: [String]!
    
    let start_date = NSUserDefaults.standardUserDefaults().objectForKey("new_start_date") as! NSDate
    let limit = 25
    
    func setChart(dataPoints: [String], values: [Double])
    {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count
        {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        weightLineChartView.data = lineChartData
        
        weightLineChartView.noDataText = "There is no data to pull from. "
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //weightLineChartView.noDataTextDescription = "Please input data into healthkit "
        // Do any additional setup after loading the view.
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", ]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0, ]
        
        setChart(months, values: unitsSold)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
