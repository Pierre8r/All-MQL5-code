//+------------------------------------------------------------------+
//|                                                ObjectsCustom.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "https://www.mql5.com"

#include "Types.mqh"
//+------------------------------------------------------------------+
//| Base Class CObjectCustom                                         |
//+------------------------------------------------------------------+
class CObjectCustom
  {
private:
   int               m_type;
protected:
                     CObjectCustom(int type){m_type=type;}
public:
                     CObjectCustom(){m_type=TYPE_OBJECT;}
   int Type(){return m_type;}
  };
//+------------------------------------------------------------------+
//| Class describing human beings.                                   |
//+------------------------------------------------------------------+
class CHuman : public CObjectCustom
  {
public:
                     CHuman() : CObjectCustom(TYPE_HUMAN){;}
   void Run(void){printf("Human run...");}
  };
//+------------------------------------------------------------------+
//| Class describing weather.                                        |
//+------------------------------------------------------------------+
class CWeather : public CObjectCustom
  {
public:
                     CWeather() : CObjectCustom(TYPE_WEATHER){;}
   double Temp(void){return 32.0;}
  };
//+------------------------------------------------------------------+
//| Class describing Expert Advisors.                                |
//+------------------------------------------------------------------+
class CExpert : public CObjectCustom
  {
public:
                     CExpert() : CObjectCustom(TYPE_EXPERT){;}
  };
//+------------------------------------------------------------------+
//| Class describing cars.                                           |
//+------------------------------------------------------------------+
class CCar : public CObjectCustom
  {
public:
                     CCar() : CObjectCustom(TYPE_CAR){;}
  };
//+------------------------------------------------------------------+
//| Class describing numbers.                                        |
//+------------------------------------------------------------------+
class CNumber : public CObjectCustom
  {
public:
                     CNumber() : CObjectCustom(TYPE_NUMBER){;}
  };
//+------------------------------------------------------------------+
//| Class describing price bars.                                     |
//+------------------------------------------------------------------+
class CBar : public CObjectCustom
  {
public:
                     CBar() : CObjectCustom(TYPE_BAR){;}
  };
//+------------------------------------------------------------------+
//| Class describing quotations.                                     |
//+------------------------------------------------------------------+
//class CQuotes : public CObjectCustom
//  {
//public:
//                     CQuotes() : CObjectCustom(TYPE_QUOTES){;}
//  };
//+------------------------------------------------------------------+
//| Class describing the MetaQuotes company.                         |
//+------------------------------------------------------------------+
class CMetaQuotes : public CObjectCustom
  {
public:
                     CMetaQuotes() : CObjectCustom(TYPE_MQ){;}
  };
//+------------------------------------------------------------------+
//| Class describing ships.                                          |
//+------------------------------------------------------------------+
class CShip : public CObjectCustom
  {
public:
                     CShip() : CObjectCustom(TYPE_SHIP){;}
  };
//+------------------------------------------------------------------+
