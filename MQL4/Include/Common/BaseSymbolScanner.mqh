//+------------------------------------------------------------------+
//|                                            BaseSymbolScanner.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Common\SymbolSet.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BaseSymbolScanner
  {
private:
protected:
   virtual void      PerSymbolAction(string symbol)=0;
public:
   SymbolSet        *symbolSet;
   void              BaseSymbolScanner(SymbolSet *aSymbolSet);
   virtual void      Scan();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaseSymbolScanner::BaseSymbolScanner(SymbolSet *aSymbolSet)
  {
   this.symbolSet=aSymbolSet;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseSymbolScanner::Scan()
  {
   int ct= this.symbolSet.Symbols.Count();
   int i = 0;
   string val;
   for(i=0;i<ct;i++)
     {
      if(this.symbolSet.Symbols.TryGetValue(i,val))
        {
         this.PerSymbolAction(val);
        }
     }
  }
//+------------------------------------------------------------------+
