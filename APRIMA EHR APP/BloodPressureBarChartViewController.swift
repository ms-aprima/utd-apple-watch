//
//  BloodPressureBarChartViewController.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 4/21/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit
import Charts
import HealthKit

class BloodPressureBarChartViewController: UIViewController, ChartViewDelegate {

    // Chart stuff
    @IBOutlet weak var bar_chart_view: BarChartView!
    var dates = [String]()
    var systolic_values = [Double]()
    var diastolic_values = [Double]()
    
    // Used to refresh data
    var refresh_control = UIRefreshControl()
    let is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")
    
    // initialize a HealthKit object to pull data from
    let health_kit: HealthKit = HealthKit()
    
    // Array of heart rate samples pulled from HealhKit
    var blood_pressures = [HKSample]()
    
    let limit = 13
    
    // Refreshes the UI
    func refreshUI(){
        // Make sure the user authorized health kit before attempting to pull data
        if self.is_health_kit_enabled == true{
            let start_date = NSDate.distantPast()
            // Set up array of heart rate objects to use for displaying
            setUpBloodPressureObjects(start_date)
            if(self.dates.count > 0 && self.systolic_values.count > 0){
                self.setChart(self.dates, systolic_values: self.systolic_values, diastolic_dates: self.dates, diastolic_values: self.diastolic_values)
            }
        }
    }
    

    
    // Sets up the array of HeartRate objects to display as table cells
    func setUpBloodPressureObjects(start_date: NSDate){
        // First clear array to make sure it's empty
        self.dates.removeAll()
        self.systolic_values.removeAll()
        self.diastolic_values.removeAll()
        
        self.health_kit.getBloodPressure(self.limit, start_date: start_date){ heart_rates, error in
            self.blood_pressures = heart_rates
        }
        // Format date to make it readable
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        for b in self.blood_pressures as! [HKCorrelation]{
            let systolic_data = b.objectsForType(HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureSystolic)!).first as? HKQuantitySample
            let diastolic_data = b.objectsForType(HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureDiastolic)!).first as? HKQuantitySample
            
            let systolic_value = systolic_data!.quantity.doubleValueForUnit(HKUnit.millimeterOfMercuryUnit())
            let diastolic_value = diastolic_data!.quantity.doubleValueForUnit(HKUnit.millimeterOfMercuryUnit())
            
            self.dates.append(date_formatter.stringFromDate(b.endDate))
            self.systolic_values.append(systolic_value)
            self.diastolic_values.append(diastolic_value)
        }
    }
    
    
    func setChart(systolic_dates: [String], systolic_values: [Double], diastolic_dates: [String], diastolic_values: [Double]){
        self.bar_chart_view.noDataTextDescription = "No health data available."
        
        var systolic_data_entries: [BarChartDataEntry] = []
        var diastolic_data_entries: [BarChartDataEntry] = []
        
        // Set data points in chart
        for i in 0..<systolic_dates.count {
            let data_entry = BarChartDataEntry(value: systolic_values[i], xIndex: i)
            systolic_data_entries.append(data_entry)
        }
        for i in 0..<diastolic_dates.count {
            let data_entry = BarChartDataEntry(value: diastolic_values[i], xIndex: i)
            diastolic_data_entries.append(data_entry)
        }
        
        let systolic_chart_data_set = BarChartDataSet(yVals: systolic_data_entries, label: "Systolic")
        let diastolic_chart_data_set = BarChartDataSet(yVals: diastolic_data_entries, label: "Diastolic")
        self.bar_chart_view.descriptionText = ""
        // blue
        diastolic_chart_data_set.colors = [UIColor(red: 25.0/255, green: 150.0/255, blue: 197.0/255, alpha: 1)]
        // orange
        systolic_chart_data_set.colors = [UIColor(red: 255.0/255, green: 210.0/255, blue: 112.0/255, alpha: 1)]
        let chart_data = BarChartData(xVals: self.dates, dataSet: systolic_chart_data_set)
        chart_data.addDataSet(diastolic_chart_data_set)
        self.bar_chart_view.data = chart_data
        
        // Set other chart properties
       
        self.bar_chart_view.xAxis.labelFont = UIFont(name: "Helvetica Neue", size: 0.0)!
        self.bar_chart_view.rightAxis.enabled = false
        self.bar_chart_view.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        // Set up what happens when user selects a value inside the chart
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.bar_chart_view.delegate = self
        
        
        self.refreshUI()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        refreshUI()
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
