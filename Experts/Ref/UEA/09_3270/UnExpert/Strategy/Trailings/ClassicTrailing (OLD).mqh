//+------------------------------------------------------------------+
//|                                                    Trailings.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include <Object.mqh>
#define TRAILING_CLASSIC
#include "..\PositionMT5.mqh"

#ifdef SHOW_TRAILING_PARAMS
input string ClassicTrailingParams = "Values";  // Classic Trailing parameters:
input int StepModify = 20;
input int DeltaTrailing = 200;
#endif
//+------------------------------------------------------------------+
//| Parameters and variables of classic trailing stop, with which    |
//| ClassicTrailing function works.                                  |
//+------------------------------------------------------------------+
class CTrailingClassicParams : public CObject
{
public:
   double   StepModify;        // Step in points, after which the stop loss of a position should be changed
   double   DeltaTrailing;     // Delta between the current extreme and the trailing level that should be kept
   double   PrevExtremum;      // A service variable. The last extremum that was reached
   CTrailingClassicParams(void);
};
//+------------------------------------------------------------------+
//| The default constructor that adds external settings to the object|
//+------------------------------------------------------------------+
CTrailingClassicParams::CTrailingClassicParams(void)
{
   #ifdef SHOW_TRAILING_PARAMS
   this.StepModify = StepModify;
   this.DeltaTrailing = DeltaTrailing;
   #else
   StepModify = 20;
   DeltaTrailing = 200;
   #endif
}
//+------------------------------------------------------------------+
//| Classic trailing stop function                                   |
//+------------------------------------------------------------------+
bool TrailingClassic(CPosition* pos, CObject* object)
{
   return false;
}