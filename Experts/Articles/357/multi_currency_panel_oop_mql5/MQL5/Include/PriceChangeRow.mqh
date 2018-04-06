//+------------------------------------------------------------------+
//|                                               PriceChangeRow.mqh |
//|                                                 Marcin Konieczny |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Marcin Konieczny"

#include <Row.mqh>
//+------------------------------------------------------------------+
//| CPriceChangeRow class                                            |
//+------------------------------------------------------------------+
class CPriceChangeRow : public CRow
  {
private:
   bool              percentChange;
   bool              useArrows;

public:
   //--- constructor
                     CPriceChangeRow(bool arrows,bool percent=false);

   //--- overrides default GetName() method from CRow
   virtual string    GetName();

   //--- overrides default GetFont() method from CRow
   virtual string    GetFont(string symbol,ENUM_TIMEFRAMES tf);

   //--- overrides default GetValue(..) method from CRow
   virtual string    GetValue(string symbol,ENUM_TIMEFRAMES tf);

   //--- overrides default GetColor(..) method from CRow
   virtual color     GetColor(string symbol,ENUM_TIMEFRAMES tf);

  };
//+------------------------------------------------------------------+
//| CPriceChangeRow class constructor                                |
//+------------------------------------------------------------------+
CPriceChangeRow::CPriceChangeRow(bool arrows,bool percent=false)
  {
   percentChange=percent;
   useArrows=arrows;
  }
//+------------------------------------------------------------------+
//| Overrides default GetName() method from CRow                     |
//+------------------------------------------------------------------+
 string CPriceChangeRow::GetName()
  {
   return("PriceChg");
  }
//+------------------------------------------------------------------+
//| Overrides default GetFont() method from CRow                     |
//+------------------------------------------------------------------+
string CPriceChangeRow::GetFont(string symbol,ENUM_TIMEFRAMES tf)
  {
//--- we use Wingdings font to draw arrows (up/down)
   if(useArrows)
      return("Wingdings");
   else
      return("Arial");
  }
//+------------------------------------------------------------------+
//| Overrides default GetValue(..) method from CRow                  |
//+------------------------------------------------------------------+
string CPriceChangeRow::GetValue(string symbol,ENUM_TIMEFRAMES tf)
  {
   double close[1];
   double open[1];

//--- gets open and close of current bar
   if(CopyClose(symbol,tf,0, 1, close) < 0) return(" ");
   if(CopyOpen(symbol, tf, 0, 1, open) < 0) return(" ");

//--- current bar price change
   double change=close[0]-open[0];

   if(useArrows)
     {
      if(change > 0) return(CharToString(233)); // returns up arrow code
      if(change < 0) return(CharToString(234)); // returns down arrow code
      return(" ");
        }else{
      if(percentChange)
        {
         //--- calculates percent change
         return(DoubleToString(change/open[0]*100.0,3)+"%");
           }else{
         return(DoubleToString(change,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS)));
        }
     }
  }
//+------------------------------------------------------------------+
//| Overrides default GetColor(..) method from CRow                  |
//+------------------------------------------------------------------+
color CPriceChangeRow::GetColor(string symbol,ENUM_TIMEFRAMES tf)
  {
   double close[1];
   double open[1];

//--- gets open and close of current bar
   if(CopyClose(symbol,tf,0, 1, close) < 0) return(clrWhite);
   if(CopyOpen(symbol, tf, 0, 1, open) < 0) return(clrWhite);

   if(close[0] > open[0]) return(clrLime);
   if(close[0] < open[0]) return(clrRed);
   return(clrWhite);
  }
//+------------------------------------------------------------------+
