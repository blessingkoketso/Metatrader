//+------------------------------------------------------------------+
//|                                                 SignalResult.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property description "Signal Analysis Result."
#property strict
#include <Generic\HashMap.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SignalResult
  {
public:
   bool              isSet;
   datetime          time;
   string            symbol;
   ENUM_ORDER_TYPE   orderType;
   double            price;
   double            takeProfit;
   double            stopLoss;
   CHashMap<string,string>data;
   void              SignalResult();
   void              Reset();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SignalResult::SignalResult()
  {
   this.Reset();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SignalResult::Reset()
  {
   this.isSet=false;
   this.time=NULL;
   this.symbol=NULL;
   this.orderType=NULL;
   this.price=0;
   this.takeProfit=0;
   this.stopLoss=0;
   this.data.Clear();
  }
//+------------------------------------------------------------------+
