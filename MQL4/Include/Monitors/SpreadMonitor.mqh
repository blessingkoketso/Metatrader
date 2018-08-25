//+------------------------------------------------------------------+
//|                                                SpreadMonitor.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Monitors\BaseMonitor.mqh>
#include <MarketWatch\MarketWatch.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SpreadMonitor : public BaseMonitor
  {
public:
   void SpreadMonitor(string fileName="spreads.csv",bool appendReport=true):BaseMonitor(fileName,appendReport)
     {
      string columnNames[]={"Date","Time","Symbol","Spread"};
      this.SetColumnNames(columnNames);
     };

   bool SetData(string symbol)
     {
      MqlTick tick;
      if(MarketWatch::GetTick(symbol,tick))
        {
         this.SetDataItem("Date",StringFormat("%i/%i/%i",Year(),Month(),Day()));
         this.SetDataItem("Time",StringFormat("%i:%i:%i",Hour(),Minute(),Seconds()));
         this.SetDataItem("Symbol",symbol);
         this.SetDataItem("Spread",((string)MarketWatch::GetSpread(symbol)));
         return true;
        }
      return false;
     };
  };
//+------------------------------------------------------------------+
