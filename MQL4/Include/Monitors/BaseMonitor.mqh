//+------------------------------------------------------------------+
//|                                                  BaseMonitor.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Common\CsvFileWriter.mqh>
#include <Generic\ArrayList.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BaseMonitor
  {
private:
   CsvFileWriter     _csvFile;
   CArrayList<string>_columnNames;
   CArrayList<string>_data;

   bool InitializeData()
     {
      this._data.Clear();
      this._data.TrimExcess();
      int i;
      int ct=this._columnNames.Count();
      string arr[];
      ArrayResize(arr,ct,0);
      for(i=0;i<ct;i++)
        {
         arr[i]="";
        }
      return this._data.AddRange(arr);
     };

   uint WriteHeaderRow()
     {
      if(this._csvFile.Size()==0 && this._columnNames.Count()>0)
        {
         string arr[];
         this._columnNames.CopyTo(arr,0);
         return this._csvFile.WriteRow(arr);
        }
      return 0;
     };

public:

   void BaseMonitor(string fileName,bool appendReport=true)
     {
      this._csvFile.Open(fileName,appendReport);
     };

   bool SetDataItem(string columnName,string data)
     {
      int i=this._columnNames.IndexOf(columnName);
      return this._data.TrySetValue(i,data);
     };

   bool ClearDataItem(string columnName,string data)
     {
      return this.SetDataItem(columnName,"");
     };

   bool ClearData()
     {
      bool out=true;
      int i;
      int ct=this._data.Count();
      for(i=0;i<ct;i++)
        {
         out=out && this._data.TrySetValue(i,"");
        }
      return out;
     };

   bool SetColumnNames(string &columnNames[])
     {
      this._columnNames.Clear();
      this._columnNames.TrimExcess();
      if(this._columnNames.AddRange(columnNames))
        {
         return (this.InitializeData() && this.WriteHeaderRow()>0);
        }
      return false;
     };

   uint WriteDataRow()
     {
      if(this._data.Count()>0)
        {
         string arr[];
         this._data.CopyTo(arr,0);
         this.ClearData();
         return this._csvFile.WriteRow(arr);
        }
      return 0;
     };
  };
//+------------------------------------------------------------------+
