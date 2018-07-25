//+------------------------------------------------------------------+
//|                                               AbstractSignal.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <ChartObjects\ChartObjectsShapes.mqh>
#include <Common\ValidationResult.mqh>
#include <Signals\SignalResult.mqh>
#include <MarketWatch\MarketWatch.mqh>
#include <Generic\LinkedList.mqh>
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class AbstractSignal
  {
private:
   static int        _idCount;
   string            _id;
   ENUM_TIMEFRAMES   _timeframe;
   int               _shift;
public:
   ENUM_TIMEFRAMES   Timeframe();
   void              Timeframe(ENUM_TIMEFRAMES timeframe);
   int               Shift();
   void              Shift(int shift);
   SignalResult     *Signal;
   string            ID();
   void              AbstractSignal();
   void             ~AbstractSignal();
   virtual bool      Validate(ValidationResult *validationResult)=0;
   virtual bool      Validate();
   virtual SignalResult *Analyze(string symbol);
   virtual SignalResult *Analyze(string symbol,int shift)=0;
  };
static int AbstractSignal::_idCount=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AbstractSignal::AbstractSignal()
  {
   this._id=StringConcatenate("Signal",AbstractSignal::_idCount);
   AbstractSignal::_idCount+=1;
   this.Signal=new SignalResult();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AbstractSignal::~AbstractSignal()
  {
   delete this.Signal;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int AbstractSignal::Shift()
  {
   return this._shift;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AbstractSignal::Shift(int shift)
  {
   this._shift=shift;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES AbstractSignal::Timeframe()
  {
   return this._timeframe;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AbstractSignal::Timeframe(ENUM_TIMEFRAMES timeframe)
  {
   if(timeframe==PERIOD_CURRENT)
     {
      this._timeframe=ChartPeriod();
     }
   else
     {
      this._timeframe=timeframe;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string AbstractSignal::ID()
  {
   return this._id;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AbstractSignal::Validate()
  {
   ValidationResult *v=new ValidationResult();
   bool out=this.Validate(v);
   delete v;
   return out;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SignalResult *AbstractSignal::Analyze(string symbol)
  {
   MarketWatch::LoadSymbolHistory(symbol,this._timeframe,true);
   MarketWatch::OpenChartIfMissing(symbol,this._timeframe);
   this.Analyze(symbol,this._shift);
   return this.Signal;
  }
//+------------------------------------------------------------------+
