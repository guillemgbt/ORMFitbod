//
//  ExerciseStatsViewModel.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 13/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation
import SwiftCharts

class ExerciseStatsViewModel: NSObject {
    
    let exercise: Exercise
    
    let name = SimpleObservable<String>(value: "")
    let description1RM = SimpleObservable<String>(value: "")
    let value1RM = SimpleObservable<String>(value: "")
    let chartInfo = SimpleObservable<String>(value: "")
    let chart = SimpleObservable<Chart?>(value: nil)
    
    private var theme: Theme {
        get {
            ThemeManager.shared.current()
        }
    }
    
    init(exercise: Exercise) {
        self.exercise = exercise
        super.init()
        
        setInfoObservables()
    }
    
    deinit {
       //Check deinit for memory leaks prevention
       Utils.printDebug(sender: self, message: "deinit")
    }
    
    private func setInfoObservables() {
        self.name.accept(self.exercise.name)
        self.description1RM.accept("One Rep Max • lbs")
        self.value1RM.accept("\(Int(self.exercise.get1RM()))")
        self.chartInfo.accept("Scroll chart to see all records")
    }
    
    func prepareChartInBackground(bounds: CGRect) {
        DispatchQueue.global().async {
            self.prepareChart(bounds: bounds)
        }
    }
    
    func prepareChart(bounds: CGRect) {
        
        let xModel = prepareXModel()
        let yModel = prepareYModel()
        
        let chartFrame = createChartFrame(bounds)
        var chartSettings = ExerciseStatsViewModel.iPhoneChartSettingsWithPanZoom
        chartSettings.leading = 16
        chartSettings.trailing = 16

        chartSettings.zoomPan.maxZoomX = 2
        chartSettings.zoomPan.minZoomX = 2
        chartSettings.zoomPan.minZoomY = 1
        chartSettings.zoomPan.maxZoomY = 1
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let lineLayer = prepareLineLayer(xAxisLayer: xAxisLayer,
                                              yAxisLayer: yAxisLayer)
        
        let guidelinesLayerSettings = ChartGuideLinesLayerSettings(linesColor: theme.subtitleTextColor,
                                                                   linesWidth: 0.3)
        let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: guidelinesLayerSettings)
        
        //SwiftCharts instantiates view at the time of Chart initialisation.
        //Must be in main thread
        DispatchQueue.main.async {
            let chart = Chart(
                frame: chartFrame,
                innerFrame: innerFrame,
                settings: chartSettings,
                layers: [
                    xAxisLayer,
                    yAxisLayer,
                    guidelinesLayer,
                    lineLayer]
            )
            
            lineLayer.initScreenLines(chart)
                    
            self.chart.accept(chart)
        }
    }
    
    private func prepareYModel() -> ChartAxisModel {
        let (min1RM, max1RM) = oneRepMaxLimits()
        
        let yLabelSettings = ChartLabelSettings(font: labelFont(),
                                                fontColor: theme.subtitleTextColor)
    
        let yValues = stride(from: min1RM,
                             through: max1RM,
                             by: 10).map {ChartAxisValueDouble($0,
                                                               labelSettings: yLabelSettings)}
        
        
        let labelSettings = ChartLabelSettings(font: labelFont(),
                                               fontColor: theme.titleTextColor)

        return ChartAxisModel(axisValues: yValues,
                              axisTitleLabel: ChartAxisLabel(text: "1RM",
                                                             settings: labelSettings.defaultVertical()))

    }
    
    private func prepareXModel() -> ChartAxisModel {
        let (minDate, maxDate) = dateLimits()

        let xValues = createDateStride(from: minDate,
                                       to: maxDate).map({ createDateAxisValue($0) })
        let labelSettings = ChartLabelSettings(font: labelFont(),
                                               fontColor: theme.titleTextColor)
        return ChartAxisModel(axisValues: xValues,
                              axisTitleLabel: ChartAxisLabel(text: "Date",
                                                             settings: labelSettings))
    }
    
    private func prepareLineLayer(xAxisLayer: ChartAxisLayer, yAxisLayer: ChartAxisLayer) -> ChartPointsLineLayer<ChartPoint> {
        let records = exercise.getDailyRecords()
                
        let chartPoints = records.map({ self.createChartPoint(date: $0.date,
                                                              value: Double($0.get1RM()))})
        
        let lineModel = ChartLineModel(chartPoints: chartPoints,
                                       lineColor: theme.mainColor,
                                       lineWidth: 2,
                                       animDuration: 1,
                                       animDelay: 0)
        
        return ChartPointsLineLayer(xAxis: xAxisLayer.axis,
                                    yAxis: yAxisLayer.axis,
                                    lineModels: [lineModel],
                                    delayInit: true)
    }
    
    private func createChartFrame(_ containerBounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 20, width: containerBounds.size.width, height: containerBounds.size.height - 20)
    }
    
    private func labelFont() -> UIFont {
        UIFont.boldSystemFont(ofSize: 14)
    }
    
    private func createChartPoint(date: Date, value: Double) -> ChartPoint {
        return ChartPoint(x: createDateAxisValue(date),
                          y: ChartAxisValueDouble(value))
    }
    
    private func createDateAxisValue(_ date: Date) -> ChartAxisValue {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM dd yyyy"
        let labelSettings = ChartLabelSettings(font: labelFont(),
                                               fontColor: theme.subtitleTextColor,
                                               rotation: 90,
                                               rotationKeep: .top)
        return ChartAxisValueDate(date: date,
                                  formatter: displayFormatter,
                                  labelSettings: labelSettings)
    }
    
    private func createDateStride(from startDate: Date, to endDate: Date, dayStep: Int = 14) -> [Date] {
        var dateStride = [startDate]
        
        while let lastDate = dateStride.last, lastDate < endDate {
            var dateStep = DateComponents()
            dateStep.day = dayStep
            if let nextDate = Calendar.current.date(byAdding: dateStep, to: lastDate) {
                dateStride.append(nextDate)
            }
        }
        
        return dateStride
    }
    
    internal func oneRepMaxLimits() -> (Int, Int) {
        let max = Int(exercise.getDailyRecords().map({ $0.get1RM() }).max() ?? 0) + 10
        let min = Int(exercise.getDailyRecords().map({ $0.get1RM() }).min() ?? 10) - 10
        return (min, max)
    }
    
    internal func dateLimits() -> (Date, Date) {
        let minDate = exercise.getDailyRecords().map({ $0.date }).min() ?? Date()
        let maxDate = exercise.getDailyRecords().map({ $0.date }).max() ?? Date()
        return (minDate, maxDate)
    }
    
    
    fileprivate static var iPhoneChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
    
    fileprivate static var iPhoneChartSettingsWithPanZoom: ChartSettings {
        var chartSettings = iPhoneChartSettings
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        return chartSettings
    }

}
