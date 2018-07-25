//+------------------------------------------------------------------+
//|                                                 ExtremeBreak.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <ChartObjects\ChartObjectsShapes.mqh>
#include <Common\Comparators.mqh>
#include <Signals\AbstractSignal.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ExtremeBreak : public AbstractSignal
  {
private:
   Comparators       _compare;
   int               _period;
   double            _low;
   double            _high;
   int               _minimumPointsDistance;
   CChartObjectRectangle s;
public:
                     ExtremeBreak(int period,ENUM_TIMEFRAMES timeframe,int shift=2,int minimumPointsTpSl=50);
   bool              Validate(ValidationResult *v);
   SignalResult     *Analyze(string symbol,int shift);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ExtremeBreak::ExtremeBreak(int period,ENUM_TIMEFRAMES timeframe,int shift=2,int minimumPointsTpSl=50)
  {
   this._period=period;
   this.Timeframe(timeframe);
   this.Shift(shift);
   this._minimumPointsDistance=minimumPointsTpSl;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ExtremeBreak::Validate(ValidationResult *v)
  {
   v.Result=true;

   if(!this._compare.IsNotBelow(this._period,1))
     {
      v.Result=false;
      v.AddMessage("Period must be 1 or greater.");
     }

   if(!this._compare.IsNotBelow(this.Shift(),0))
     {
      v.Result=false;
      v.AddMessage("Shift must be 0 or greater.");
     }

   return v.Result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SignalResult *ExtremeBreak::Analyze(string symbol,int shift)
  {
   this.Signal.Reset();
   this._low  = iLow(symbol, this.Timeframe(), iLowest(symbol,this.Timeframe(),MODE_LOW,this._period,shift));
   this._high = iHigh(symbol, this.Timeframe(), iHighest(symbol,this.Timeframe(),MODE_HIGH,this._period,shift));

   long chartId=MarketWatch::GetChartId(symbol,this.Timeframe());
   if(s.Attach(chartId,this.ID(),0,2))
     {
      s.SetPoint(0,Time[shift+this._period],this._high);
      s.SetPoint(1,Time[shift],this._low);
     }
   else
     {
      s.Create(chartId,this.ID(),0,Time[shift+this._period],this._high,Time[shift],this._low);
      s.Color(clrAquamarine);
      s.Background(false);
     }

   ChartRedraw(chartId);

   double point=MarketInfo(symbol,MODE_POINT);
   double minimumPoints=(double)this._minimumPointsDistance;

   MqlTick tick;
   bool gotTick=SymbolInfoTick(symbol,tick);

   if(gotTick)
     {
      if(tick.bid<this._low)
        {
         this.Signal.isSet=true;
         this.Signal.time=tick.time;
         this.Signal.symbol=symbol;
         this.Signal.orderType=OP_SELL;
         this.Signal.price=tick.bid;
         this.Signal.stopLoss=this._high;
         this.Signal.takeProfit=tick.bid-(this._high-tick.bid);
        }
      if(tick.ask>this._high)
        {
         this.Signal.isSet=true;
         this.Signal.orderType=OP_BUY;
         this.Signal.price=tick.ask;
         this.Signal.symbol=symbol;
         this.Signal.time=tick.time;
         this.Signal.stopLoss=this._low;
         this.Signal.takeProfit=(tick.ask+(tick.ask-this._low));
        }
      if(this.Signal.isSet)
        {
         if(MathAbs(this.Signal.price-this.Signal.takeProfit)/point<minimumPoints)
           {
            this.Signal.Reset();
           }
         if(MathAbs(this.Signal.price-this.Signal.stopLoss)/point<minimumPoints)
           {
            this.Signal.Reset();
           }
        }
     }
   return this.Signal;
  }
//+------------------------------------------------------------------+
