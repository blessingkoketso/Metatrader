//+------------------------------------------------------------------+
//|                                                      AdxBase.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Signals\AbstractSignal.mqh>
#include <Signals\Config\AdxBaseConfig.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class AdxBase : public AbstractSignal
  {
protected:
   ENUM_APPLIED_PRICE _appliedPrice;
   double            _threshold;
public:
                     AdxBase(AdxBaseConfig &config,AbstractSignal *aSubSignal=NULL);
   virtual bool      DoesSignalMeetRequirements();
   virtual bool      Validate(ValidationResult *v);
   virtual AdxData   GetAdx(string symbol,int shift);
   virtual bool      IsBullish(string symbol,int shift);
   virtual bool      IsBullishCrossover(string symbol,int shift);
   virtual bool      IsBearish(string symbol,int shift);
   virtual bool      IsBearishCrossover(string symbol,int shift);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
AdxBase::AdxBase(AdxBaseConfig &config,AbstractSignal *aSubSignal=NULL):AbstractSignal(config,aSubSignal)
  {
   this._appliedPrice=config.AppliedPrice;
   this._threshold=config.Threshold;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AdxBase::Validate(ValidationResult *v)
  {
   AbstractSignal::Validate(v);

   if(this._compare.IsNotBetween(this._threshold,0.0,100.0))
     {
      v.Result=false;
      v.AddMessage("Threshold must be between 0 and 100.");
     }

   return v.Result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AdxBase::DoesSignalMeetRequirements()
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
AdxData AdxBase::GetAdx(string symbol,int shift)
  {
   return this.GetAdx(symbol,shift,this._appliedPrice);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AdxBase::IsBullish(string symbol,int shift)
  {
   AdxData adx=this.GetAdx(symbol,shift);
   return (this._compare.IsGreaterThan(adx.PlusDirection,adx.MinusDirection)
           && this._compare.IsGreaterThan(adx.PlusDirection,this._threshold)
           && this._compare.IsGreaterThan(adx.Main,this._threshold));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AdxBase::IsBullishCrossover(string symbol,int shift)
  {
   AdxData adx=this.GetAdx(symbol,shift+3);
   bool cross = (this._compare.IsLessThanOrEqualTo(adx.PlusDirection,this._threshold)
                 || this._compare.IsLessThanOrEqualTo(adx.Main,this._threshold));
   return (this.IsBullish(symbol,shift) && cross);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AdxBase::IsBearish(string symbol,int shift)
  {
   AdxData adx=this.GetAdx(symbol,shift);
   return (this._compare.IsGreaterThan(adx.MinusDirection,adx.PlusDirection)
           && this._compare.IsGreaterThan(adx.MinusDirection,this._threshold)
           && this._compare.IsGreaterThan(adx.Main,this._threshold));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AdxBase::IsBearishCrossover(string symbol,int shift)
  {
   AdxData adx=this.GetAdx(symbol,shift+3);
   bool cross =(this._compare.IsLessThanOrEqualTo(adx.MinusDirection,this._threshold)
                || this._compare.IsLessThanOrEqualTo(adx.Main,this._threshold));
   return (this.IsBearish(symbol,shift) && cross);
  }
//+------------------------------------------------------------------+
