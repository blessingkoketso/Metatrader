//+------------------------------------------------------------------+
//|                                                     AdxSignal.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Signals\AdxBase.mqh>
#include <Signals\Config\AdxSignalConfig.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class AdxSignal : public AdxBase
  {
public:
                     AdxSignal(AdxSignalConfig &config,AbstractSignal *aSubSignal=NULL);
   SignalResult     *Analyzer(string symbol,int shift);
   bool              IsSellSignal(string symbol,int shift);
   bool              IsBuySignal(string symbol,int shift);
   virtual bool      Validate(ValidationResult *v);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
AdxSignal::AdxSignal(AdxSignalConfig &config,AbstractSignal *aSubSignal=NULL):AdxBase(config,aSubSignal)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AdxSignal::Validate(ValidationResult *v)
  {
   AdxBase::Validate(v);

   return v.Result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SignalResult *AdxSignal::Analyzer(string symbol,int shift)
  {
   PriceRange pr=this.CalculateRangeByPriceLowHigh(symbol,shift);
   this.DrawIndicatorRectangle(symbol,shift,pr.high,pr.low);

   bool sellSignal=this.IsBearishCrossover(symbol,shift);
   bool buySignal=this.IsBullishCrossover(symbol,shift);

   MqlTick tick;

   if(SymbolInfoTick(symbol,tick) && this._compare.Xor(buySignal,sellSignal))
     {
      if(sellSignal)
        {
         this.Signal.isSet=true;
         this.Signal.time=tick.time;
         this.Signal.symbol=symbol;
         this.Signal.orderType=OP_SELL;
         this.Signal.price=tick.bid;
         this.Signal.stopLoss=0;
         this.Signal.takeProfit=0;
        }
      else if(buySignal)
        {
         this.Signal.isSet=true;
         this.Signal.orderType=OP_BUY;
         this.Signal.price=tick.ask;
         this.Signal.symbol=symbol;
         this.Signal.time=tick.time;
         this.Signal.stopLoss=0;
         this.Signal.takeProfit=0;
        }
     }

// signal confirmation
   if(!this.DoesSubsignalConfirm(symbol,shift))
     {
      this.Signal.Reset();
     }

   return this.Signal;
  }
//+------------------------------------------------------------------+
