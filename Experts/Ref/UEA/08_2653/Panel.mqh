//+------------------------------------------------------------------+
//|                                                        Panel.mqh |
//|                                 Copyright 2017, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include <Panel\ElChart.mqh>

class CPercentPanel : public CElChart
{
private:
   CArrayObj  m_fields;
   CArrayObj  m_values;
public:
   
   CPercentPanel(void);
   void SetLine(int index, string field, string value);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPercentPanel::CPercentPanel(void) : CElChart(OBJ_RECTANGLE_LABEL)
{
   Width(200);
   Height(200);
}
//+------------------------------------------------------------------+
//| Sets a line                                                      |
//+------------------------------------------------------------------+
void CPercentPanel::SetLine(int index,string field,string value)
{
   if(m_fields.Total() <= index)
   {
      CElChart* sfield = new CElChart(OBJ_LABEL);
      sfield.XCoord(XCoord()+10);
      sfield.YCoord(YCoord()+21*index+10);
      sfield.Text(field);
      m_fields.Add(sfield);
      m_elements.Add(sfield);
      
      CElChart* svalue = new CElChart(OBJ_LABEL);
      svalue.YCoord(YCoord()+21*index+10);
      svalue.XCoord(XCoord()+132);
      svalue.Text(value);
      svalue.TextColor(clrGreen);
      m_values.Add(svalue);
      m_elements.Add(svalue);
      if(IsShowed())
      {
         sfield.Show();
         svalue.Show();
      }
      Height(m_fields.Total()*20 + m_fields.Total()*2 + 10);
   }
   else
   {
      CElChart* el = m_fields.At(index);
      el.Text(field);
      el = m_values.At(index);
      el.Text(value);
   }
   ChartRedraw();
}