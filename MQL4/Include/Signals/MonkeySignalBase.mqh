//+------------------------------------------------------------------+
//|                                             MonkeySignalBase.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Common\OrderManager.mqh>
#include <Common\Comparators.mqh>
#include <Signals\AbstractSignal.mqh>
#include <Signals\Config\MonkeySignalConfig.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MonkeySignalBase : public AbstractSignal
  {
protected:
   bool              _hedgeExitsToggler;
   double            _atrExitsMultiplier;
   virtual PriceRange CalculateRange(string symbol,int shift);
   virtual void      SetBuySignal(string symbol,int shift,MqlTick &tick,bool setTp);
   virtual void      SetSellSignal(string symbol,int shift,MqlTick &tick,bool setTp);
   virtual void      SetSellExits(string symbol,int shift,MqlTick &tick);
   virtual void      SetBuyExits(string symbol,int shift,MqlTick &tick);
   virtual void      SetExits(string symbol,int shift,MqlTick &tick);

public:
                     MonkeySignalBase(MonkeySignalConfig &config,AbstractSignal *aSubSignal=NULL);
   virtual bool      DoesSignalMeetRequirements();
   virtual bool      Validate(ValidationResult *v);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MonkeySignalBase::MonkeySignalBase(MonkeySignalConfig &config,AbstractSignal *aSubSignal=NULL):AbstractSignal(config,aSubSignal)
  {
   this._hedgeExitsToggler=false;
   this._atrExitsMultiplier=config.AtrExitsMultiplier;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MonkeySignalBase::Validate(ValidationResult *v)
  {
   AbstractSignal::Validate(v);
   return v.Result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MonkeySignalBase::DoesSignalMeetRequirements()
  {
   if(!(AbstractSignal::DoesSignalMeetRequirements()))
     {
      return false;
     }

   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PriceRange MonkeySignalBase::CalculateRange(string symbol,int shift)
  {
   PriceRange pr;
   double atr=(this.GetAtr(symbol,shift)*this._atrExitsMultiplier);

   pr=this.CalculateRangeByPriceLowHigh(symbol,shift);
   pr.high=pr.high+atr;
   pr.low=pr.low-atr;

   return pr;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MonkeySignalBase::SetBuySignal(string symbol,int shift,MqlTick &tick,bool setTp)
  {
   PriceRange pr=this.CalculateRange(symbol,shift);

   double tp=0;
   if(setTp)
     {
      tp=pr.high;
     }

   this.Signal.isSet=true;
   this.Signal.time=tick.time;
   this.Signal.symbol=symbol;
   this.Signal.orderType=OP_BUY;
   this.Signal.price=tick.ask;
   this.Signal.stopLoss=pr.low;
   this.Signal.takeProfit=tp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MonkeySignalBase::SetSellSignal(string symbol,int shift,MqlTick &tick,bool setTp)
  {
   PriceRange pr=this.CalculateRange(symbol,shift);

   double tp=0;
   if(setTp)
     {
      tp=pr.low;
     }

   this.Signal.isSet=true;
   this.Signal.time=tick.time;
   this.Signal.symbol=symbol;
   this.Signal.orderType=OP_SELL;
   this.Signal.price=tick.bid;
   this.Signal.stopLoss=pr.high;
   this.Signal.takeProfit=tp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MonkeySignalBase::SetBuyExits(string symbol,int shift,MqlTick &tick)
  {
   PriceRange pr=this.CalculateRange(symbol,shift);
   double sl=pr.low;
   double tp=OrderManager::PairHighestTakeProfit(symbol,OP_BUY);

   this.Signal.isSet=true;
   this.Signal.time=tick.time;
   this.Signal.symbol=symbol;
   this.Signal.orderType=OP_BUY;
   this.Signal.price=tick.ask;
   this.Signal.stopLoss=sl;
   this.Signal.takeProfit=tp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MonkeySignalBase::SetSellExits(string symbol,int shift,MqlTick &tick)
  {
   PriceRange pr=this.CalculateRange(symbol,shift);
   double sl=pr.high;
   double tp=OrderManager::PairLowestTakeProfit(symbol,OP_SELL);

   this.Signal.isSet=true;
   this.Signal.time=tick.time;
   this.Signal.symbol=symbol;
   this.Signal.orderType=OP_SELL;
   this.Signal.price=tick.bid;
   this.Signal.stopLoss=sl;
   this.Signal.takeProfit=tp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MonkeySignalBase::SetExits(string symbol,int shift,MqlTick &tick)
  {
   int hasBuys=0<OrderManager::PairOpenPositionCount(OP_BUY,symbol);
   int hasSells=0<OrderManager::PairOpenPositionCount(OP_SELL,symbol);

   if(Comparators::Xor(hasBuys,hasSells))
     {
      if(hasBuys)
        {
         this.SetBuyExits(symbol,shift,tick);
        }
      if(hasSells)
        {
         this.SetSellExits(symbol,shift,tick);
        }
     }
   else if(Comparators::And(hasBuys,hasSells))
     {
      this._hedgeExitsToggler=(!this._hedgeExitsToggler);
      if(this._hedgeExitsToggler)
        {
         this.SetBuyExits(symbol,shift,tick);
        }
      else
        {
         this.SetSellExits(symbol,shift,tick);
        }
     }
  }
//+------------------------------------------------------------------+
