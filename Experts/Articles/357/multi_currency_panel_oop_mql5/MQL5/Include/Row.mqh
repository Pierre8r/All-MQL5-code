//+------------------------------------------------------------------+
//|                                                         CRow.mqh |
//|                                                 Marcin Konieczny |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Marcin Konieczny"

#include <Object.mqh>
//+------------------------------------------------------------------+
//| CRow class                                                       |
//+------------------------------------------------------------------+
//| Base class for creating custom table rows                        |
//| one or more methods of CRow should be overriden                  |
//| when creating own table rows                                     |
//+------------------------------------------------------------------+
class CRow : public CObject
  {
public:
   //--- default initialization method
   virtual void Init(string &symb[],ENUM_TIMEFRAMES &tfs[]) { }

   //--- default method for obtaining string value to display in the table cell
   virtual string GetValue(string symbol,ENUM_TIMEFRAMES tf) { return("-"); }

   //--- default method for obtaining color for table cell
   virtual color GetColor(string symbol,ENUM_TIMEFRAMES tf) { return(clrWhite); }
   
   //--- default method for obtaining row name
   virtual string GetName() { return("-"); }

   //--- default method for obtaining font for table cell
   virtual string GetFont(string symbol,ENUM_TIMEFRAMES tf) { return("Arial"); }
  };
//+------------------------------------------------------------------+
