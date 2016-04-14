//
//  WeightChartViewController.swift
//  APRIMA EHR APP
//
//  Created by Timmy on 4/11/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit
import Charts
import HealthKit

class WeightChartViewController: UIViewController {
    
    let health_kit: HealthKit = HealthKit()
    let is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")


    @IBOutlet weak var weightLineChartView: LineChartView!
    var weights = [HKSample]()
    var dates = [String]()
    
    let limit = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshUI()
        
        
        // Do any additional setup
        //after loading the view.
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        refreshUI()
    }
    

    func setupChart(start_date: NSDate){
        health_kit.getWeight2(self.limit, start_date: start_date){results, error in
            self.weights = results
            print("worked")
            print(results.count)
        }
        let weightUnit:HKUnit = HKUnit(fromString: "lb")
        var weightVal = [Double]()
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        for s in self.weights as! [HKQuantitySample]{
            weightVal.append(s.quantity.doubleValueForUnit(weightUnit))
            self.dates.append(date_formatter.stringFromDate(s.endDate))
        }
        print(weights.count)
        if(weights.count > 0){
            setChart(dates, values: weightVal)
        }
        
    }
    
    func refreshUI(){
        if self.is_health_kit_enabled == true{
            let start_date = NSDate.distantPast()

            setupChart(start_date)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        weightLineChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [ChartDataEntry] = []

        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Weight (lb)")
        let chartData = LineChartData(xVals: dates, dataSet: chartDataSet)
        weightLineChartView.data = chartData
        
        // Set other chart properties
        weightLineChartView.descriptionText = ""
        chartDataSet.colors = [UIColor(red: 25.0/255, green: 150.0/255, blue: 197.0/255, alpha: 1)]
        self.weightLineChartView.xAxis.labelFont = UIFont(name: "Helvetica Neue", size: 0.0)!
        self.weightLineChartView.rightAxis.enabled = false
        self.weightLineChartView.xAxis.labelPosition = .Bottom
        self.weightLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
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