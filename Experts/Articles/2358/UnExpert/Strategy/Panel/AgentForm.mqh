//+------------------------------------------------------------------+
//|                                                    AgentForm.mqh |
//|           Copyright 2016, Vasiliy Sokolov, St-Petersburg, Russia |
//|                                https://www.mql5.com/en/users/c-4 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Vasiliy Sokolov."
#property link      "https://www.mql5.com/en/users/c-4"
#include "Node.mqh"
#include "ElChart.mqh"
#include "ElDropDownList.mqh"

#define REGIM_BUY_AND_SELL "BuyAndSell"
#define REGIM_BUY_ONLY     "BuyOnly"
#define REGIM_SELL_ONLY    "SellOnly"
#define REGIM_WAIT         "Wait"
#define REGIM_STOP         "Stop"
#define REGIM_NO_NEW_ENTRY "NoNewEntry"
//+------------------------------------------------------------------+
//| Agent management form                                            |
//+------------------------------------------------------------------+
class CAgentForm : public CElChart
  {
private:
   CElChart          LabelAgent;
   CElChart          LabelRegim;

   void              ConfigForm(void);
   void              ConfigAgentLabel();
   void              ConfigListAgents();
   void              ConfigLabelRegim();
   void              ConfigListRegim();
   void              ConfigBuyBtn();
   void              ConfigSellBtn();
   void              ConfigStopBtn();
   void              ConfigVolume();
   void              ConfigUpVol();
   void              ConfigDnVol();
public:
   CElDropDownList   ListAgents;
   CElDropDownList   ListRegim;
   CElChart          Volume;
   CElButton         BuyButton;
   CElButton         SellButton;
   CElButton         UpVol;
   CElButton         DnVol;
                     CAgentForm(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAgentForm::CAgentForm(void) : CElChart(OBJ_RECTANGLE_LABEL),
                               LabelAgent(OBJ_EDIT),
                               LabelRegim(OBJ_EDIT),
                               Volume(OBJ_EDIT)
  {
   ConfigForm();
   ConfigAgentLabel();
   ConfigListAgents();
   ConfigLabelRegim();
   ConfigListRegim();
   ConfigBuyBtn();
   ConfigSellBtn();
   ConfigVolume();
   ConfigUpVol();
   ConfigDnVol();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAgentForm::ConfigForm(void)
  {
   BackgroundColor(clrWhiteSmoke);
   Width(280);
   Height(125);
   YCoord(20);
   XCoord(10);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAgentForm::ConfigAgentLabel(void)
  {
   LabelAgent.XCoord(20);
   LabelAgent.YCoord(40);
   LabelAgent.Text("Agent:");
   LabelAgent.BorderColor(BackgroundColor());
   LabelAgent.BackgroundColor(BackgroundColor());
   m_elements.Add(GetPointer(LabelAgent));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAgentForm::ConfigListAgents(void)
  {
   ListAgents.XCoord(80);
   ListAgents.YCoord(40);
   ListAgents.Width(200);
   m_elements.Add(GetPointer(ListAgents));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAgentForm::ConfigLabelRegim(void)
  {
   LabelRegim.XCoord(20);
   LabelRegim.YCoord(65);
   LabelRegim.Text("Regim:");
   LabelRegim.BorderColor(BackgroundColor());
   LabelRegim.BackgroundColor(BackgroundColor());
   m_elements.Add(GetPointer(LabelRegim));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAgentForm::ConfigListRegim(void)
  {
   ListRegim.XCoord(80);
   ListRegim.YCoord(65);
   ListRegim.Width(200);
   m_elements.Add(GetPointer(ListRegim));

   ListRegim.AddElement(REGIM_BUY_AND_SELL);
   ListRegim.AddElement(REGIM_BUY_ONLY);
   ListRegim.AddElement(REGIM_SELL_ONLY);
   ListRegim.AddElement(REGIM_WAIT);
   ListRegim.AddElement(REGIM_STOP);
   ListRegim.AddElement(REGIM_NO_NEW_ENTRY);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAgentForm::ConfigBuyBtn(void)
  {
   BuyButton.XCoord(25);
   BuyButton.YCoord(110);
   BuyButton.Width(80);
   BuyButton.Text("BUY");
   BuyButton.BackgroundColor(clrLightSkyBlue);
   m_elements.Add(GetPointer(BuyButton));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAgentForm::ConfigSellBtn(void)
  {
   SellButton.XCoord(200);
   SellButton.YCoord(110);
   SellButton.Width(80);
   SellButton.Text("SELL");
   SellButton.BackgroundColor(clrPink);
   m_elements.Add(GetPointer(SellButton));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAgentForm::ConfigVolume(void)
  {
   Volume.XCoord(112);
   Volume.YCoord(110);
   Volume.Width(81);
   Volume.Text("1.0");
   Volume.Align(ALIGN_CENTER);
   Volume.BackgroundColor(clrWhite);
   Volume.ReadOnly(false);
   Volume.Tooltip("Volume");
   m_elements.Add(GetPointer(Volume));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAgentForm::ConfigUpVol(void)
  {
   UpVol.XCoord(175);
   UpVol.YCoord(112);
   UpVol.Width(16);
   UpVol.Height(16);
   UpVol.TextFont("Webdings");
   UpVol.Text(CharToString(0x35));
   m_elements.Add(GetPointer(UpVol));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAgentForm::ConfigDnVol(void)
  {
   DnVol.XCoord(114);
   DnVol.YCoord(112);
   DnVol.Width(16);
   DnVol.Height(16);
   DnVol.TextFont("Webdings");
   DnVol.Text(CharToString(0x36));
   m_elements.Add(GetPointer(DnVol));
  }
//+------------------------------------------------------------------+
