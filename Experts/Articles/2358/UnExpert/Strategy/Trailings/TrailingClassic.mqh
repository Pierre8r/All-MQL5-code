//+------------------------------------------------------------------+
//|                                              TrailingClassic.mqh |
//|                                 Copyright 2016, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include "Trailing.mqh"
//+------------------------------------------------------------------+
//| Integrate trailing stop parameters in the list of parameters of  |
//| the Expert Advisor                                               |
//+------------------------------------------------------------------+
#ifdef SHOW_TRAILING_CLASSIC_PARAMS
input double PointsModify=0.00100;
input double StepModify=0.00005;
#endif
//+------------------------------------------------------------------+
//| A classical trailing stop                                        |
//+------------------------------------------------------------------+
class CTrailingClassic : public CTrailing
  {
private:
   double            m_diff_extremum;  // The distance in points from a reached extreme to the position's stop-loss
   double            m_step_modify;    // The minimum number of points to modify stop loss
   double            FindExtremum(CPosition *pos);
public:
                     CTrailingClassic(void);
   void              SetDiffExtremum(double points);
   double            GetDiffExtremum(void);
   void              SetStepModify(double points_step);
   double            GetStepModify(void);
   virtual bool      Modify(void);
   virtual CTrailing *Copy(void);
  };
//+------------------------------------------------------------------+
//| Constructor. Initializes default parameters                      |
//+------------------------------------------------------------------+
CTrailingClassic::CTrailingClassic(void) : m_diff_extremum(0.0),
                                           m_step_modify(0.0)
  {
#ifdef SHOW_TRAILING_CLASSIC_PARAMS
   m_diff_extremum=PointsModify;
   m_step_modify=StepModify;
#endif
  }
//+------------------------------------------------------------------+
//| Returns a copy of the instance                                   |
//+------------------------------------------------------------------+  
CTrailing *CTrailingClassic::Copy(void)
  {
   CTrailingClassic *tral=new CTrailingClassic();
   tral.SetDiffExtremum(m_diff_extremum);
   tral.SetStepModify(m_step_modify);
   tral.SetPosition(m_position);
   return tral;
  }
//+------------------------------------------------------------------+
//| Sets the number of points from a reached extremum                |
//+------------------------------------------------------------------+
void CTrailingClassic::SetDiffExtremum(double points)
  {
   m_diff_extremum=points;
  }
//+------------------------------------------------------------------+
//| Sets the value of a minimal modification in points               |
//+------------------------------------------------------------------+
void CTrailingClassic::SetStepModify(double points_step)
  {
   m_step_modify=points_step;
  }
//+------------------------------------------------------------------+
//| Returns the number of points from a reached extremum             |
//+------------------------------------------------------------------+
double CTrailingClassic::GetDiffExtremum(void)
  {
   return m_diff_extremum;
  }
//+------------------------------------------------------------------+
//| Returns the value of a minimal modification in points            |
//+------------------------------------------------------------------+
double CTrailingClassic::GetStepModify(void)
  {
   return m_step_modify;
  }
//+------------------------------------------------------------------+
//| Modifies trailing stop in accordance with logic of a classical   |
//| trailing stop                                                    |
//+------------------------------------------------------------------+
bool CTrailingClassic::Modify(void)
  {

   if(CheckPointer(m_position)==POINTER_INVALID)
     {
      string text="Invalid position for current trailing-stop. Set position with 'SetPosition' method";
      CMessage *msg=new CMessage(MESSAGE_WARNING,__FUNCTION__,text);
      Log.AddMessage(msg);
      return false;
     }
   if(m_diff_extremum<=0.0)
     {
      string text="Set points trailing-stop with 'SetDiffExtremum' method";
      CMessage *msg=new CMessage(MESSAGE_WARNING,__FUNCTION__,text);
      Log.AddMessage(msg);
      return false;
     }
   double extremum=FindExtremum(m_position);
   if(extremum == 0.0)return false;
   double n_sl = 0.0;
   if(m_position.Direction()==POSITION_TYPE_BUY)
      n_sl=extremum-m_diff_extremum;
   else
      n_sl=extremum+m_diff_extremum;
   if(n_sl!=m_position.StopLossValue())
      return m_position.StopLossValue(n_sl);
   return false;
  }
//+------------------------------------------------------------------+
//| Returns the extreme price reached while holding the              |
//| position. For a long position, it will return the highest        |
//| reached price. For a short one - the lowest price that was       |
//| reached.                                                         |
//+------------------------------------------------------------------+
double CTrailingClassic::FindExtremum(CPosition *pos)
  {
   double prices[];
   if(pos.Direction()==POSITION_TYPE_BUY)
     {
      if(CopyHigh(pos.Symbol(),PERIOD_M1,pos.TimeOpen(),TimeCurrent(),prices)>1)
         return prices[ArrayMaximum(prices)];
     }
   else
     {
      if(CopyLow(pos.Symbol(),PERIOD_M1,pos.TimeOpen(),TimeCurrent(),prices)>1)
         return prices[ArrayMinimum(prices)];
     }
   return 0.0;
  }
//+------------------------------------------------------------------+
