//+------------------------------------------------------------------+
//|                                                ObjectsCustom.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| Base class CObjectCustom                                         |
//+------------------------------------------------------------------+
class CObjectCustom
  {
public:

   void CObjectCustom()
     {
      printf("Object #"+(string)(count++)+" - "+typename(this));
     }
private:
   static int        count;
  };
static int CObjectCustom::count=0;
//+------------------------------------------------------------------+
//| Class describing human beings.                                   |
//+------------------------------------------------------------------+
class CHuman : public CObjectCustom
  {
  };
//+------------------------------------------------------------------+
//| Class describing weather.                                        |
//+------------------------------------------------------------------+
class CWeather : public CObjectCustom
  {
  };
//+------------------------------------------------------------------+
//| Class describing Expert Advisors.                                |
//+------------------------------------------------------------------+
class CExpert : public CObjectCustom
  {
  };
//+------------------------------------------------------------------+
//| Class describing cars.                                           |
//+------------------------------------------------------------------+
class CCar : public CObjectCustom
  {
  };
//+------------------------------------------------------------------+
//| Class describing numbers.                                        |
//+------------------------------------------------------------------+
class CNumber : public CObjectCustom
  {
  };
//+------------------------------------------------------------------+
//| Class describing price bars.                                     |
//+------------------------------------------------------------------+
class CBar : public CObjectCustom
  {
  };
//+------------------------------------------------------------------+
//| Class describing quotations.                                     |
//+------------------------------------------------------------------+
class CQuotes : public CObjectCustom
  {
  };
//+------------------------------------------------------------------+
//| Class describing the MetaQuotes company.                         |
//+------------------------------------------------------------------+
class CMetaQuotes : public CObjectCustom
  {
  };
//+------------------------------------------------------------------+
//| Class describing ships.                                          |
//+------------------------------------------------------------------+
class CShip : public CObjectCustom
  {
  };
//+------------------------------------------------------------------+
