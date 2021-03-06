//+------------------------------------------------------------------+
//|                                               ElDropDownList.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "http://www.mql5.com"

#include <Object.mqh>
#include <Arrays\ArrayObj.mqh>
#include <Dictionary.mqh>
#include "Node.mqh"
#include "ElChart.mqh"
#include "ElButton.mqh"
#include "Events\Event.mqh"
#include "Events\EventChartObjClick.mqh"
#include "Events\EventChartMouseMove.mqh"

#define UP_ARROW CharToString(0x35)
#define DN_ARROW CharToString(0x36)
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMenu : public CObject
  {
public:
   string            Text;
                     CMenu(string text){Text=text;}
  };
//+------------------------------------------------------------------+
//| Graphic element "Drop-down List"                                 |
//+------------------------------------------------------------------+
class CElDropDownList : public CElChart
  {
private:
   CElButton         m_btn_list;        // The button that drops down the list
   CElChart          m_fon;             // The background of the list
   CDictionary       m_list;            // List of elements
   CElChart*         m_selected;        // Selected element
   void              Showed(bool showed);
   void              OnObjClick(CEventChartObjClick *objClick);
   void              OnMouseMove(CEventChartMouseMove *mouseMove);
protected:
   virtual void      OnXCoordChange(void);
   virtual void      OnYCoordChange(void);
   virtual void      OnWidthChange(void);
   virtual void      OnHeightChange(void);
public:
                     CElDropDownList(void);
   void              AddElement(string text);
   void              SelectElementByName(string name);
   virtual void      Event(CEvent *event);
  };
//+------------------------------------------------------------------+
//| Positions the object being created                               |
//+------------------------------------------------------------------+
CElDropDownList::CElDropDownList(void) : CElChart(OBJ_EDIT),m_fon(OBJ_RECTANGLE_LABEL)
  {
   m_btn_list.BorderType(BORDER_RAISED);
   m_btn_list.BackgroundColor(clrWhiteSmoke);
   m_btn_list.TextFont("Webdings");
   m_btn_list.TextSize(9);
   m_btn_list.Text(CharToString(0x36));
   m_elements.Add(GetPointer(m_btn_list));
  }
//+------------------------------------------------------------------+
//| Adds a new menu item.                                    |
//+------------------------------------------------------------------+
void CElDropDownList::AddElement(string text)
  {
   if(m_list.ContainsKey(text))return;
   CElChart *elMenu=new CElChart(OBJ_EDIT);
   elMenu.XCoord(XCoord()+1);
   elMenu.YCoord(m_fon.YCoord()+20*m_list.Total()+1);
   elMenu.Height(20);
   elMenu.Width(Width()-2);
   elMenu.Text(text);
   elMenu.BorderColor(elMenu.BackgroundColor());
   m_list.AddObject(elMenu.Name(), elMenu);
   m_fon.Height(20*m_list.Total()+2);
  }
//+------------------------------------------------------------------+
//| Selects an element based on the name parameter                   |
//+------------------------------------------------------------------+
void CElDropDownList::SelectElementByName(string name)
  {
   FOREACH_DICT(m_list)
     {
      CElChart* elMenu = node;
      if(elMenu.Text() == name)
        {
         m_selected=elMenu;
         Text(m_selected.Text());
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| Intercept events and react to them.                              |
//+------------------------------------------------------------------+
void CElDropDownList::Event(CEvent *event)
  {
   CNode::Event(event);
   if(event.EventType()==EVENT_CHART_OBJECT_CLICK)
      OnObjClick(event);
   if(event.EventType()==EVENT_CHART_MOUSE_MOVE)
      OnMouseMove(event);

  }
//+------------------------------------------------------------------+
//| Processes mouse click                                            |
//+------------------------------------------------------------------+
void CElDropDownList::OnObjClick(CEventChartObjClick *objClick)
  {
   if(m_list.ContainsKey(objClick.ObjectName()))
     {
      m_btn_list.Text(DN_ARROW);
      m_btn_list.State(PUSH_OFF);
      Showed(false);
      m_selected=m_list.GetObjectByKey(objClick.ObjectName());
      Text(m_selected.Text());
      EventChartCustom(ChartID(),EVENT_CHART_LIST_CHANGED,0.0,0.0,Name());
      return;
     }
   if(objClick.ObjectName() != m_btn_list.Name())return;
   if(m_btn_list.State()==PUSH_ON)
     {
      m_btn_list.Text(UP_ARROW);
      Showed(true);
     }
   else
     {
      m_btn_list.Text(DN_ARROW);
      Showed(false);
     }
  }
//+------------------------------------------------------------------+
//| Processes mouse movement                                         |
//+------------------------------------------------------------------+
void CElDropDownList::OnMouseMove(CEventChartMouseMove *mouseMove)
  {
   if(!m_fon.IsShowed())return;
//Determine if the mouse pointer is on the list of elements
   bool isX=mouseMove.XCoord()>=m_fon.XCoord() && 
            mouseMove.XCoord()<=m_fon.XCoord()+m_fon.Width();
   bool isY=mouseMove.YCoord()>=m_fon.YCoord() && 
            mouseMove.YCoord()<=m_fon.YCoord()+m_fon.Height();
   bool isMain=isX && isY;
   if(!isMain)return;
//If it is, determine the line to highlight
   long pips = mouseMove.YCoord() - m_fon.YCoord();
   int index = (int)MathFloor(pips/20.0);
   if(m_list.Total() <= index)return;
   int i=0;
   for(CElChart *node=m_list.GetFirstNode(); node!=NULL; node=m_list.GetNextNode(),i++)
     {
      if(i==index)
         node.BackgroundColor(clrWhiteSmoke);
      else
         node.BackgroundColor(clrWhite);
     }
  }
//+------------------------------------------------------------------+
//| Shows all pop up elements                                        |
//+------------------------------------------------------------------+
void CElDropDownList::Showed(bool showed)
  {
   if(showed)
      m_fon.Show();
   else
      m_fon.Hide();
   FOREACH_DICT(m_list)
     {
      CElChart *el=node;
      if(showed)
         el.Show();
      else
         el.Hide();
     }
  }
//+------------------------------------------------------------------+
//| After changing the binding of x, change child elements           |
//+------------------------------------------------------------------+
void CElDropDownList::OnXCoordChange(void)
  {
   m_btn_list.XCoord(XCoord()+Width()-18);
   m_fon.XCoord(XCoord());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CElDropDownList::OnYCoordChange(void)
  {
   m_btn_list.YCoord(YCoord()+2);
   m_fon.YCoord(YCoord()+Height()+1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CElDropDownList::OnHeightChange(void)
  {
   m_btn_list.Height(Height()-4);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CElDropDownList::OnWidthChange(void)
  {
   m_btn_list.Width(Height()-4);
   m_fon.Width(Width());
  }
//+------------------------------------------------------------------+
