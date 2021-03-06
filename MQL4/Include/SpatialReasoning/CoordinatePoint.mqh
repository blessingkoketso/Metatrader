//+------------------------------------------------------------------+
//|                                              CoordinatePoint.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <SpatialReasoning\Dimension.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct CoordinatePoint
  {
public:
   Dimension         X;
   Dimension         Y;

   void Set(double x,double y)
     {
      X.Set(x);
      Y.Set(y);
     }

   void Set(CoordinatePoint &p)
     {
      X.Set(p.X.Get());
      Y.Set(p.Y.Get());
     }

   void CoordinatePoint(CoordinatePoint &p)
     {
      this.Set(p);
     }

   void CoordinatePoint(double x,double y)
     {
      this.Set(x,y);
     }

   void CoordinatePoint()
     {
      this.Set(0,0);
     }

   CoordinatePoint operator+(CoordinatePoint &point)
     {
      CoordinatePoint o(this.X.Get()+point.X.Get(),this.Y.Get()+point.Y.Get());
      return o;
     }

   CoordinatePoint operator-(CoordinatePoint &point)
     {
      CoordinatePoint o(this.X.Get()-point.X.Get(),this.Y.Get()-point.Y.Get());
      return o;
     }

   CoordinatePoint operator*(CoordinatePoint &point)
     {
      CoordinatePoint o(this.X.Get()*point.X.Get(),this.Y.Get()*point.Y.Get());
      return o;
     }

   CoordinatePoint operator/(CoordinatePoint &point)
     {
      CoordinatePoint o(this.X.Get()/point.X.Get(),this.Y.Get()/point.Y.Get());
      return o;
     }
  };
//+------------------------------------------------------------------+
