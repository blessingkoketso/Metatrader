//+------------------------------------------------------------------+
//|                                                  TickMonitor.mqh |
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
class TickMonitor : public BaseMonitor
  {
private:

   string TickFlagToString(uint flurrrg)
     {
      string str;

      if((flurrrg  &TICK_FLAG_BID)==TICK_FLAG_BID)
        {
         str+="Bid Update. ";
        }
      if((flurrrg  &TICK_FLAG_ASK)==TICK_FLAG_ASK)
        {
         str+="Ask Update. ";
        }
      if((flurrrg  &TICK_FLAG_LAST)==TICK_FLAG_LAST)
        {
         str+="Last Deal Price Update. ";
        }
      if((flurrrg  &TICK_FLAG_VOLUME)==TICK_FLAG_VOLUME)
        {
         str+="Volume Update. ";
        }
      if((flurrrg  &TICK_FLAG_BUY)==TICK_FLAG_BUY)
        {
         str+="Buy Order Processed. ";
        }
      if((flurrrg  &TICK_FLAG_SELL)==TICK_FLAG_SELL)
        {
         str+="Sell Order Processed. ";
        }

      str=StringTrimRight(str);
      return str;
     };

public:

   void TickMonitor(string fileName="ticks.csv",bool appendReport=true):BaseMonitor(fileName,appendReport)
     {
      string columnNames[]=
        {
         "Date"
            ,"Time"
            ,"Symbol"
            ,"Ask"
            ,"Bid"
            ,"Volume"
            ,"Last Deal Price"
            ,"Flag"
            ,"Timestamp"
            ,"Timestamp Milliseconds"
        };
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
         this.SetDataItem("Ask",(string)tick.ask);
         this.SetDataItem("Bid",(string)tick.bid);
         this.SetDataItem("Volume",(string)tick.volume);
         this.SetDataItem("Last Deal Price",(string)tick.last);
         this.SetDataItem("Flag",this.TickFlagToString(tick.flags));
         this.SetDataItem("Timestamp",(string)tick.time);
         this.SetDataItem("Timestamp Milliseconds",(string)tick.time_msc);
         return true;
        }
      return false;
     };
  };
//+------------------------------------------------------------------+
