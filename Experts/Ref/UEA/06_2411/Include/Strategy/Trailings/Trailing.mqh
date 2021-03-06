//+------------------------------------------------------------------+
//|                                                     Trailing.mqh |
//|                                 Copyright 2016, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include <Object.mqh>
#include "..\PositionMT5.mqh"
#include "..\Logs.mqh"
class CPosition;
//+------------------------------------------------------------------+
//| The base class of a trailing stop                                |
//+------------------------------------------------------------------+
class CTrailing : public CObject
  {
protected:
   CPosition         *m_position;     // The position, which trailing stop you want to modify.
   CLog              *Log;
public:
                      CTrailing(void);
   void               SetPosition(CPosition *position);
   CPosition         *GetPosition(void);
   virtual bool       Modify(void);
   virtual CTrailing* Copy(void);
  };
//+------------------------------------------------------------------+
//| Constructor. Receives a logger module                            |
//+------------------------------------------------------------------+
CTrailing::CTrailing(void)
  {
   Log=CLog::GetLog();
  }
//+------------------------------------------------------------------+
//| Trailing stop modification method, which should be               |
//| overridden in the derived trailing class                         |
//+------------------------------------------------------------------+
bool CTrailing::Modify(void)
  {
   return false;
  }
//+------------------------------------------------------------------+
//| Returns a copy of the instance                                   |
//+------------------------------------------------------------------+  
CTrailing* CTrailing::Copy(void)
{
   return new CTrailing();
}
//+------------------------------------------------------------------+
//| Sets a position, the stop loss of which should be modified       |
//+------------------------------------------------------------------+
void CTrailing::SetPosition(CPosition *position)
  {
   m_position=position;
  }
//+------------------------------------------------------------------+
//| Returns a position, the stop loss of which should be modified    |
//+------------------------------------------------------------------+
CPosition *CTrailing::GetPosition(void)
  {
   return m_position;
  }
//+------------------------------------------------------------------+
