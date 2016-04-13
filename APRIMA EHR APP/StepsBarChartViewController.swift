//
//  StepsBarChartViewController.swift
//  APRIMA EHR APP
//
//  Created by macOS on 4/10/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import Foundation
import UIKit
import Charts
import HealthKit


class StepsBarChartViewController: UIViewController, UINavigationControllerDelegate {
    let health_kit: HealthKit = HealthKit()
    let is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")
    
    @IBOutlet weak var barChartView: BarChartView!
    var steps = [HKSample]()
    var dates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshUI()
        
        
        // Do any additional setup
        //after loading the view.
    }
    

    
    override func viewWillAppear(animated: Bool) {
        refreshUI()
    }
    
    func setupChart(){
        health_kit.getSteps(25, start_date:NSDate.distantPast()){results, error in
            self.steps = results
        }
        
        var stepCount = [Double]()
        dates = [String]()
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        for s in self.steps as! [HKQuantitySample]{
            stepCount.append(s.quantity.doubleValueForUnit(HKUnit.countUnit()))
            self.dates.append(date_formatter.stringFromDate(s.endDate))
        }
        print(steps.count)
        if(steps.count > 0){
            setChart(dates, values: stepCount)
        }
        
    }
    
    func refreshUI(){
        if self.is_health_kit_enabled == true{
            
            setupChart()
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Steps")
        let chartData = BarChartData(xVals: dates, dataSet: chartDataSet)
        barChartView.data = chartData
        
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