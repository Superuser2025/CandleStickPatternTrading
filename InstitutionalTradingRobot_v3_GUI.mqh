//+------------------------------------------------------------------+
//| InstitutionalTradingRobot_v3_GUI.mqh                             |
//| Interactive GUI - Clickable Buttons & Controls                   |
//+------------------------------------------------------------------+

// Forward declarations
void CreateToggleButton(string name, int x, int y, int width, int height, string text, bool initial_state, color col_on, color col_off, string setting_name);
void CreateBigLabel(string name, int x, int y, string text, color clr, int font_size, bool bold);
void UpdateAllButtons();
void UpdateSetting(string setting, bool value);
void CreateColorBox(int index, int x, int y, color clr);
void CreateLegendLabel(int index, int x, int y, string text, color clr, int font_size, bool bold);
void DrawButtonStatus();

// Button structure
struct Button
{
    string name;
    int x;
    int y;
    int width;
    int height;
    string text;
    bool state;         // true = ON, false = OFF
    color color_on;
    color color_off;
    string setting;     // Which setting this controls
};

Button gui_buttons[50];  // Enough for all buttons + future expansion
int button_count = 0;

//+------------------------------------------------------------------+
//| CREATE INTERACTIVE DASHBOARD WITH BUTTONS                        |
//+------------------------------------------------------------------+
void CreateInteractiveDashboard()
{
    int x_start = 20;
    int y_start = 50;
    int button_width = 280;
    int button_height = 35;
    int spacing = 5;
    int row = 0;

    button_count = 0;

    // Title
    CreateBigLabel("GUI_Title", x_start, y_start,
                   "═══ INSTITUTIONAL TRADING ROBOT v3.0 ═══",
                   clrWhite, 14, true);

    row++;
    y_start += 50;

    // MODE TOGGLE - BIG AND OBVIOUS
    CreateToggleButton("BTN_MODE", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      g_EnableTrading ? "MODE: AUTO TRADING ✓" : "MODE: INDICATOR ONLY",
                      g_EnableTrading, clrLime, clrOrange, "MODE");
    row++;

    row++; // Spacing

    // SECTION: INSTITUTIONAL FILTERS
    CreateBigLabel("GUI_Filters", x_start, y_start + row * (button_height + spacing),
                   "─── INSTITUTIONAL FILTERS ───", clrAqua, 12, false);
    row++;

    CreateToggleButton("BTN_VOLUME", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Volume Filter",
                      g_UseVolumeFilter, clrLime, clrRed, "VOLUME");
    row++;

    CreateToggleButton("BTN_SPREAD", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Spread Filter",
                      g_UseSpreadFilter, clrLime, clrRed, "SPREAD");
    row++;

    CreateToggleButton("BTN_SLIPPAGE", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Slippage Model",
                      g_UseSlippageModel, clrLime, clrRed, "SLIPPAGE");
    row++;

    CreateToggleButton("BTN_MTF", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Multi-Timeframe Confirm",
                      g_UseMTFConfirmation, clrLime, clrRed, "MTF");
    row++;

    CreateToggleButton("BTN_SESSION", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Session Filter",
                      g_UseSessionFilter, clrLime, clrRed, "SESSION");
    row++;

    CreateToggleButton("BTN_CORRELATION", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Correlation Filter",
                      g_UseCorrelationFilter, clrLime, clrRed, "CORRELATION");
    row++;

    CreateToggleButton("BTN_NEWS", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "News Filter",
                      g_UseNewsFilter, clrLime, clrRed, "NEWS");
    row++;

    CreateToggleButton("BTN_VOLATILITY", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Volatility Adaptation",
                      g_UseVolatilityAdaptation, clrLime, clrRed, "VOLATILITY");
    row++;

    CreateToggleButton("BTN_DYNAMIC_RISK", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Dynamic Risk",
                      g_UseDynamicRisk, clrLime, clrRed, "DYNAMIC_RISK");
    row++;

    CreateToggleButton("BTN_PATTERN_DECAY", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Pattern Decay",
                      g_UsePatternDecay, clrLime, clrRed, "PATTERN_DECAY");
    row++;

    row++; // Spacing

    // SECTION: SMART MONEY
    CreateBigLabel("GUI_SmartMoney", x_start, y_start + row * (button_height + spacing),
                   "─── SMART MONEY CONCEPTS ───", clrAqua, 12, false);
    row++;

    CreateToggleButton("BTN_LIQUIDITY", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Liquidity Sweep",
                      g_UseLiquiditySweep, clrLime, clrRed, "LIQUIDITY");
    row++;

    CreateToggleButton("BTN_RETAIL_TRAP", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Retail Trap Detection",
                      g_UseRetailTrap, clrLime, clrRed, "RETAIL_TRAP");
    row++;

    CreateToggleButton("BTN_OB_INVALID", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Order Block Invalidation",
                      g_UseOrderBlockInvalidation, clrLime, clrRed, "OB_INVALID");
    row++;

    CreateToggleButton("BTN_STRUCTURE", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Market Structure",
                      g_UseMarketStructure, clrLime, clrRed, "STRUCTURE");
    row++;

    row++; // Spacing

    // SECTION: MACHINE LEARNING
    CreateBigLabel("GUI_ML", x_start, y_start + row * (button_height + spacing),
                   "─── MACHINE LEARNING ───", clrAqua, 12, false);
    row++;

    CreateToggleButton("BTN_PATTERN_TRACK", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Pattern Performance Tracking",
                      g_UsePatternTracking, clrLime, clrRed, "PATTERN_TRACK");
    row++;

    CreateToggleButton("BTN_ADAPTATION", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Parameter Adaptation",
                      g_UseParameterAdaptation, clrLime, clrRed, "ADAPTATION");
    row++;

    CreateToggleButton("BTN_REGIME_STRATEGY", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Regime Strategy",
                      g_UseRegimeStrategy, clrLime, clrRed, "REGIME_STRATEGY");
    row++;

    row++; // Spacing

    // SECTION: VISUAL CONTROLS
    CreateBigLabel("GUI_Visuals", x_start, y_start + row * (button_height + spacing),
                   "─── CHART VISUALS ───", clrYellow, 12, false);
    row++;

    CreateToggleButton("BTN_SHOW_PATTERNS", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Pattern Boxes",
                      g_ShowPatternBoxes, clrLime, clrGray, "SHOW_PATTERNS");
    row++;

    CreateToggleButton("BTN_SHOW_LABELS", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Pattern Labels",
                      g_ShowPatternLabels, clrLime, clrGray, "SHOW_LABELS");
    row++;

    CreateToggleButton("BTN_SHOW_LIQ", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Liquidity Zones",
                      g_ShowLiquidityZones, clrLime, clrGray, "SHOW_LIQ");
    row++;

    CreateToggleButton("BTN_SHOW_FVG", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Fair Value Gaps",
                      g_ShowFVGZones, clrLime, clrGray, "SHOW_FVG");
    row++;

    CreateToggleButton("BTN_SHOW_OB", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Order Blocks",
                      g_ShowOrderBlocks, clrLime, clrGray, "SHOW_OB");
    row++;

    CreateToggleButton("BTN_SHOW_DASH", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Dashboard",
                      g_ShowDashboard, clrLime, clrGray, "SHOW_DASH");
    row++;

    CreateToggleButton("BTN_SHOW_COMM", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Commentary",
                      g_ShowCommentary, clrLime, clrGray, "SHOW_COMM");
    row++;

    CreateToggleButton("BTN_SHOW_LEGEND", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Color Legend",
                      g_ShowColorLegend, clrLime, clrGray, "SHOW_LEGEND");
    row++;

    // Update all button displays
    UpdateAllButtons();
}

//+------------------------------------------------------------------+
//| CREATE TOGGLE BUTTON                                             |
//+------------------------------------------------------------------+
void CreateToggleButton(string name, int x, int y, int width, int height,
                       string text, bool initial_state,
                       color col_on, color col_off, string setting_name)
{
    if(button_count >= 50) return;  // Fixed limit

    // Store button data
    gui_buttons[button_count].name = prefix + name;
    gui_buttons[button_count].x = x;
    gui_buttons[button_count].y = y;
    gui_buttons[button_count].width = width;
    gui_buttons[button_count].height = height;
    gui_buttons[button_count].text = text;
    gui_buttons[button_count].state = initial_state;
    gui_buttons[button_count].color_on = col_on;
    gui_buttons[button_count].color_off = col_off;
    gui_buttons[button_count].setting = setting_name;

    // Create proper button object (OBJ_BUTTON has built-in text and click handling)
    ObjectCreate(0, gui_buttons[button_count].name, OBJ_BUTTON, 0, 0, 0);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_XSIZE, width);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_YSIZE, height);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_BGCOLOR,
                    initial_state ? col_on : col_off);
    // Set text color: Black for green buttons (ON), White for grey/off buttons
    color text_color = (initial_state && col_on == clrLime) ? clrBlack : clrWhite;
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_COLOR, text_color);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_BORDER_COLOR, clrWhite);
    ObjectSetString(0, gui_buttons[button_count].name, OBJPROP_FONT, "Arial Bold");
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_FONTSIZE, 10);
    ObjectSetString(0, gui_buttons[button_count].name, OBJPROP_TEXT,
                   text + (initial_state ? " [ON]" : " [OFF]"));
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_STATE, false);  // Not pressed
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_SELECTABLE, false);  // Not moveable
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_ZORDER, 10);  // On top

    button_count++;
}

//+------------------------------------------------------------------+
//| CREATE BIG LABEL                                                 |
//+------------------------------------------------------------------+
void CreateBigLabel(string name, int x, int y, string text,
                   color clr, int font_size, bool bold)
{
    string label_name = prefix + name;
    ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetString(0, label_name, OBJPROP_FONT, bold ? "Arial Bold" : "Arial");
    ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, font_size);
    ObjectSetString(0, label_name, OBJPROP_TEXT, text);
    ObjectSetInteger(0, label_name, OBJPROP_COLOR, clr);
}

//+------------------------------------------------------------------+
//| UPDATE ALL BUTTONS DISPLAY                                       |
//+------------------------------------------------------------------+
void UpdateAllButtons()
{
    for(int i = 0; i < button_count; i++)
    {
        // Update background color based on state
        color bg_color = gui_buttons[i].state ? gui_buttons[i].color_on : gui_buttons[i].color_off;
        ObjectSetInteger(0, gui_buttons[i].name, OBJPROP_BGCOLOR, bg_color);

        // Set text color: Black for green buttons (ON), White for grey/off buttons
        color text_color = (gui_buttons[i].state && gui_buttons[i].color_on == clrLime) ? clrBlack : clrWhite;
        ObjectSetInteger(0, gui_buttons[i].name, OBJPROP_COLOR, text_color);

        // Update button text with state indicator
        string button_text = gui_buttons[i].text + (gui_buttons[i].state ? " [ON]" : " [OFF]");
        ObjectSetString(0, gui_buttons[i].name, OBJPROP_TEXT, button_text);

        // Reset button pressed state
        ObjectSetInteger(0, gui_buttons[i].name, OBJPROP_STATE, false);
    }

    // Force chart redraw
    ChartRedraw();
}


//+------------------------------------------------------------------+
//| UPDATE ACTUAL SETTING VARIABLE                                   |
//| NOTE: Updates shadow global variables (g_*) not input parameters |
//+------------------------------------------------------------------+
void UpdateSetting(string setting, bool value)
{
    if(setting == "MODE")
    {
        g_EnableTrading = value;
        if(value)
            AddComment("⚠ AUTO-TRADING ENABLED - EA will execute trades!", clrRed, PRIORITY_CRITICAL);
        else
            AddComment("✓ Switched to INDICATOR MODE - No trading", clrLime, PRIORITY_CRITICAL);
    }
    else if(setting == "VOLUME") g_UseVolumeFilter = value;
    else if(setting == "SPREAD") g_UseSpreadFilter = value;
    else if(setting == "SLIPPAGE") g_UseSlippageModel = value;
    else if(setting == "MTF") g_UseMTFConfirmation = value;
    else if(setting == "SESSION") g_UseSessionFilter = value;
    else if(setting == "CORRELATION") g_UseCorrelationFilter = value;
    else if(setting == "NEWS") g_UseNewsFilter = value;
    else if(setting == "VOLATILITY") g_UseVolatilityAdaptation = value;
    else if(setting == "DYNAMIC_RISK") g_UseDynamicRisk = value;
    else if(setting == "PATTERN_DECAY") g_UsePatternDecay = value;
    else if(setting == "LIQUIDITY") g_UseLiquiditySweep = value;
    else if(setting == "RETAIL_TRAP") g_UseRetailTrap = value;
    else if(setting == "OB_INVALID") g_UseOrderBlockInvalidation = value;
    else if(setting == "STRUCTURE") g_UseMarketStructure = value;
    else if(setting == "PATTERN_TRACK") g_UsePatternTracking = value;
    else if(setting == "ADAPTATION") g_UseParameterAdaptation = value;
    else if(setting == "REGIME_STRATEGY") g_UseRegimeStrategy = value;
    // Visual toggles
    else if(setting == "SHOW_PATTERNS") g_ShowPatternBoxes = value;
    else if(setting == "SHOW_LABELS") g_ShowPatternLabels = value;
    else if(setting == "SHOW_LIQ") g_ShowLiquidityZones = value;
    else if(setting == "SHOW_FVG") g_ShowFVGZones = value;
    else if(setting == "SHOW_OB") g_ShowOrderBlocks = value;
    else if(setting == "SHOW_DASH") g_ShowDashboard = value;
    else if(setting == "SHOW_COMM") g_ShowCommentary = value;
    else if(setting == "SHOW_LEGEND") g_ShowColorLegend = value;
}

//+------------------------------------------------------------------+
//| DRAW REAL-TIME ANALYSIS PANEL (Structured Display)               |
//+------------------------------------------------------------------+
void DrawBigCommentary()
{
    string box_name = prefix + "Commentary_Box";

    if(!g_ShowCommentary)
    {
        // Hide analysis panel
        ObjectDelete(0, box_name);
        for(int i = 0; i < 50; i++)
        {
            ObjectDelete(0, prefix + "RTA_" + IntegerToString(i));
        }
        return;
    }

    int x = 750;   // Right side
    int y = 50;    // Top of chart
    int width = 550;
    int line_height = 22;

    // Background box - BIGGER to show all structured info
    if(ObjectFind(0, box_name) < 0)
    {
        ObjectCreate(0, box_name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
        ObjectSetInteger(0, box_name, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(0, box_name, OBJPROP_YDISTANCE, y);
        ObjectSetInteger(0, box_name, OBJPROP_XSIZE, width);
        ObjectSetInteger(0, box_name, OBJPROP_YSIZE, 400);  // Tall enough for all info
        ObjectSetInteger(0, box_name, OBJPROP_BGCOLOR, C'20,25,35');
        ObjectSetInteger(0, box_name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
        ObjectSetInteger(0, box_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, box_name, OBJPROP_BACK, true);
    }

    // Title
    string title_name = prefix + "Commentary_Title";
    if(ObjectFind(0, title_name) < 0)
    {
        ObjectCreate(0, title_name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, title_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetString(0, title_name, OBJPROP_FONT, "Arial Bold");
        ObjectSetInteger(0, title_name, OBJPROP_FONTSIZE, 13);
    }
    ObjectSetInteger(0, title_name, OBJPROP_XDISTANCE, x + 10);
    ObjectSetInteger(0, title_name, OBJPROP_YDISTANCE, y + 8);
    ObjectSetString(0, title_name, OBJPROP_TEXT, "═══ REAL-TIME ANALYSIS ═══");
    ObjectSetInteger(0, title_name, OBJPROP_COLOR, clrYellow);

    int row = 0;
    int base_y = y + 35;

    // Order Blocks Info
    int active_ob = 0;
    for(int i = 0; i < ob_count; i++)
        if(!order_blocks[i].invalidated) active_ob++;

    string label_name = prefix + "RTA_" + IntegerToString(row);
    if(ObjectFind(0, label_name) < 0)
    {
        ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetString(0, label_name, OBJPROP_FONT, "Arial");
        ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 11);
    }
    ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
    ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, base_y + row * line_height);
    ObjectSetString(0, label_name, OBJPROP_TEXT, "Order Blocks: " + IntegerToString(active_ob) + " active");
    ObjectSetInteger(0, label_name, OBJPROP_COLOR, clrAqua);
    row++;
    row++; // Extra spacing

    // Phase 3: Pattern Detection Header
    label_name = prefix + "RTA_" + IntegerToString(row);
    if(ObjectFind(0, label_name) < 0)
    {
        ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetString(0, label_name, OBJPROP_FONT, "Arial");
        ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 11);
    }
    ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
    ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, base_y + row * line_height);
    ObjectSetString(0, label_name, OBJPROP_TEXT, "─── Phase 3: Pattern Detection ───");
    ObjectSetInteger(0, label_name, OBJPROP_COLOR, clrCyan);
    row++;

    // H4 Pattern (Main Timeframe)
    label_name = prefix + "RTA_" + IntegerToString(row);
    if(ObjectFind(0, label_name) < 0)
    {
        ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetString(0, label_name, OBJPROP_FONT, "Arial");
        ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 11);
    }
    ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
    ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, base_y + row * line_height);
    if(has_active_pattern)
    {
        string h4_arrow = active_pattern.is_bullish ? "↑" : "↓";
        ObjectSetString(0, label_name, OBJPROP_TEXT,
                       "H4: " + active_pattern.name + " " + h4_arrow + " [" +
                       IntegerToString(active_pattern.strength) + "★]");
        ObjectSetInteger(0, label_name, OBJPROP_COLOR, active_pattern.is_bullish ? clrLime : clrRed);
    }
    else
    {
        ObjectSetString(0, label_name, OBJPROP_TEXT, "H4: No pattern detected");
        ObjectSetInteger(0, label_name, OBJPROP_COLOR, clrGray);
    }
    row++;

    // H1 Pattern
    label_name = prefix + "RTA_" + IntegerToString(row);
    if(ObjectFind(0, label_name) < 0)
    {
        ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetString(0, label_name, OBJPROP_FONT, "Arial");
        ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 11);
    }
    ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
    ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, base_y + row * line_height);
    if(has_active_pattern_h1)
    {
        string h1_arrow = active_pattern_h1.is_bullish ? "↑" : "↓";
        ObjectSetString(0, label_name, OBJPROP_TEXT,
                       "H1: " + active_pattern_h1.name + " " + h1_arrow + " [" +
                       IntegerToString(active_pattern_h1.strength) + "★]");
        ObjectSetInteger(0, label_name, OBJPROP_COLOR, active_pattern_h1.is_bullish ? clrLime : clrRed);
    }
    else
    {
        ObjectSetString(0, label_name, OBJPROP_TEXT, "H1: No pattern detected");
        ObjectSetInteger(0, label_name, OBJPROP_COLOR, clrGray);
    }
    row++;

    // M15 Pattern
    label_name = prefix + "RTA_" + IntegerToString(row);
    if(ObjectFind(0, label_name) < 0)
    {
        ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetString(0, label_name, OBJPROP_FONT, "Arial");
        ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 11);
    }
    ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
    ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, base_y + row * line_height);
    if(has_active_pattern_m15)
    {
        string m15_arrow = active_pattern_m15.is_bullish ? "↑" : "↓";
        ObjectSetString(0, label_name, OBJPROP_TEXT,
                       "M15: " + active_pattern_m15.name + " " + m15_arrow + " [" +
                       IntegerToString(active_pattern_m15.strength) + "★]");
        ObjectSetInteger(0, label_name, OBJPROP_COLOR, active_pattern_m15.is_bullish ? clrLime : clrRed);
    }
    else
    {
        ObjectSetString(0, label_name, OBJPROP_TEXT, "M15: No pattern detected");
        ObjectSetInteger(0, label_name, OBJPROP_COLOR, clrGray);
    }
    row++;
    row++; // Spacing

    // Confluence Score (if pattern exists)
    if(has_active_pattern)
    {
        label_name = prefix + "RTA_" + IntegerToString(row);
        if(ObjectFind(0, label_name) < 0)
        {
            ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
            ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetString(0, label_name, OBJPROP_FONT, "Arial");
            ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 11);
        }
        ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
        ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, base_y + row * line_height);
        ObjectSetString(0, label_name, OBJPROP_TEXT,
                       "Confluence: " + IntegerToString(last_decision.confluence_score) +
                       "/" + IntegerToString(dynamic_confluence_required));
        ObjectSetInteger(0, label_name, OBJPROP_COLOR,
                        last_decision.confluence_score >= dynamic_confluence_required ? clrLime : clrOrange);
        row++;
        row++; // Spacing

        // Decision
        label_name = prefix + "RTA_" + IntegerToString(row);
        if(ObjectFind(0, label_name) < 0)
        {
            ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
            ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetString(0, label_name, OBJPROP_FONT, "Arial");
            ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 11);
        }
        ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
        ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, base_y + row * line_height);

        string decision_text = "";
        color decision_color = clrWhite;
        switch(last_decision.decision)
        {
            case DECISION_ENTER:
                decision_text = "✓ DECISION: ENTER TRADE";
                decision_color = clrLime;
                break;
            case DECISION_SKIP:
                decision_text = "⛔ DECISION: SKIP TRADE";
                decision_color = clrRed;
                break;
            case DECISION_WAIT:
                decision_text = "⏸ DECISION: WAIT";
                decision_color = clrYellow;
                break;
        }
        ObjectSetString(0, label_name, OBJPROP_TEXT, decision_text);
        ObjectSetInteger(0, label_name, OBJPROP_COLOR, decision_color);
        row++;
    }
    else
    {
        label_name = prefix + "RTA_" + IntegerToString(row);
        if(ObjectFind(0, label_name) < 0)
        {
            ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
            ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetString(0, label_name, OBJPROP_FONT, "Arial");
            ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 10);
        }
        ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
        ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, base_y + row * line_height);
        ObjectSetString(0, label_name, OBJPROP_TEXT, "No valid patterns detected - Waiting...");
        ObjectSetInteger(0, label_name, OBJPROP_COLOR, clrGray);
        row++;
    }

    row++; // Spacing

    // Current Advice - Show last commentary line with "ADVICE:"
    string advice_text = "";
    color advice_color = clrYellow;
    for(int i = commentary_count - 1; i >= 0; i--)
    {
        if(StringFind(commentary_buffer[i].text, "ADVICE:") >= 0)
        {
            advice_text = commentary_buffer[i].text;
            advice_color = commentary_buffer[i].text_color;
            break;
        }
    }
    if(advice_text == "")
        advice_text = "ADVICE: Patience is key - Wait for high-quality setups";

    label_name = prefix + "RTA_" + IntegerToString(row);
    if(ObjectFind(0, label_name) < 0)
    {
        ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetString(0, label_name, OBJPROP_FONT, "Arial");
        ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 10);
    }
    ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
    ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, base_y + row * line_height);
    ObjectSetString(0, label_name, OBJPROP_TEXT, advice_text);
    ObjectSetInteger(0, label_name, OBJPROP_COLOR, advice_color);
}

//+------------------------------------------------------------------+
//| DRAW COLOR LEGEND - Explains what each color means               |
//+------------------------------------------------------------------+
void DrawColorLegend()
{
    string legend_name = prefix + "Legend_BG";

    if(!g_ShowColorLegend)
    {
        // Hide legend
        ObjectDelete(0, legend_name);
        for(int i = 0; i < 20; i++)
        {
            ObjectDelete(0, prefix + "Legend_" + IntegerToString(i));
            ObjectDelete(0, prefix + "LegendBox_" + IntegerToString(i));
        }
        return;
    }

    int x = 20;
    int y = 10;   // Distance from bottom (using CORNER_LEFT_LOWER)
    int width = 280;
    int line_height = 22;

    // Background box
    if(ObjectFind(0, legend_name) < 0)
    {
        ObjectCreate(0, legend_name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
        ObjectSetInteger(0, legend_name, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(0, legend_name, OBJPROP_YDISTANCE, y);
        ObjectSetInteger(0, legend_name, OBJPROP_XSIZE, width);
        ObjectSetInteger(0, legend_name, OBJPROP_YSIZE, 280);
        ObjectSetInteger(0, legend_name, OBJPROP_BGCOLOR, C'20,20,30');
        ObjectSetInteger(0, legend_name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
        ObjectSetInteger(0, legend_name, OBJPROP_CORNER, CORNER_LEFT_LOWER);  // Changed to LOWER
        ObjectSetInteger(0, legend_name, OBJPROP_BACK, false);
    }

    // Build from bottom up - higher row numbers = higher on screen
    int base_y = y + 10;

    // Order Blocks (bottom of legend)
    int row = 1;
    CreateColorBox(8, x+10, base_y + row*line_height, clrCrimson);
    CreateLegendLabel(8, x+30, base_y + row*line_height, "Bearish Order Block", clrCrimson, 10, false);
    row++;

    CreateColorBox(7, x+10, base_y + row*line_height, C'0,100,0');
    CreateLegendLabel(7, x+30, base_y + row*line_height, "Bullish Order Block", C'0,200,0', 10, false);
    row++;

    row++;  // Spacing

    // Fair Value Gaps
    CreateColorBox(6, x+10, base_y + row*line_height, clrLightPink);
    CreateLegendLabel(6, x+30, base_y + row*line_height, "Bearish FVG (Gap Down)", clrLightPink, 10, false);
    row++;

    CreateColorBox(5, x+10, base_y + row*line_height, clrLightGreen);
    CreateLegendLabel(5, x+30, base_y + row*line_height, "Bullish FVG (Gap Up)", clrLightGreen, 10, false);
    row++;

    row++;  // Spacing

    // Liquidity zones
    CreateColorBox(4, x+10, base_y + row*line_height, clrBlue);
    CreateLegendLabel(4, x+30, base_y + row*line_height, "Liquidity Low (Buy Side)", clrDodgerBlue, 10, false);
    row++;

    CreateColorBox(3, x+10, base_y + row*line_height, clrRed);
    CreateLegendLabel(3, x+30, base_y + row*line_height, "Liquidity High (Sell Side)", clrGold, 10, false);
    row++;

    row++;  // Spacing

    // Pattern colors
    CreateColorBox(2, x+10, base_y + row*line_height, clrRed);
    CreateLegendLabel(2, x+30, base_y + row*line_height, "Bearish Pattern", clrRed, 10, false);
    row++;

    CreateColorBox(1, x+10, base_y + row*line_height, clrLime);
    CreateLegendLabel(1, x+30, base_y + row*line_height, "Bullish Pattern", clrLime, 10, false);
    row++;

    // Title (at top)
    CreateLegendLabel(0, x+10, base_y + row*line_height + 8, "═══ COLOR LEGEND ═══", clrWhite, 11, true);
}

//+------------------------------------------------------------------+
//| CREATE COLOR BOX (Small colored square for legend)               |
//+------------------------------------------------------------------+
void CreateColorBox(int index, int x, int y, color clr)
{
    string name = prefix + "LegendBox_" + IntegerToString(index);

    if(ObjectFind(0, name) < 0)
    {
        ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
        ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);  // Changed to LOWER
    }

    ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(0, name, OBJPROP_XSIZE, 15);
    ObjectSetInteger(0, name, OBJPROP_YSIZE, 15);
    ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clr);
    ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
}

//+------------------------------------------------------------------+
//| CREATE LEGEND LABEL                                              |
//+------------------------------------------------------------------+
void CreateLegendLabel(int index, int x, int y, string text, color clr, int font_size, bool bold)
{
    string name = prefix + "Legend_" + IntegerToString(index);

    if(ObjectFind(0, name) < 0)
    {
        ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);  // Changed to LOWER
        ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);  // Changed to LOWER
        ObjectSetString(0, name, OBJPROP_FONT, bold ? "Arial Bold" : "Arial");
        ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
    }

    ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
    ObjectSetString(0, name, OBJPROP_TEXT, text);
    ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
}

//+------------------------------------------------------------------+
//| DRAW BUTTON STATUS (Near MARKET STATUS as requested)             |
//+------------------------------------------------------------------+
void DrawButtonStatus()
{
    string box_name = prefix + "ButtonStatus_Box";

    // Button status displayed BELOW at MARKET STATUS level as user requested
    int x = 320;   // Aligned with commentary
    int y = 160;   // MOVED DOWN - below Real-Time Analysis, above chart main area
    int width = 800;
    int line_height = 22;  // Compact spacing
    int max_lines = 3;     // Only show last 3 button changes to keep it compact

    // Background box - Compact and clean
    if(ObjectFind(0, box_name) < 0)
    {
        ObjectCreate(0, box_name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
        ObjectSetInteger(0, box_name, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(0, box_name, OBJPROP_YDISTANCE, y);
        ObjectSetInteger(0, box_name, OBJPROP_XSIZE, width);
        ObjectSetInteger(0, box_name, OBJPROP_YSIZE, 35 + max_lines * line_height);
        ObjectSetInteger(0, box_name, OBJPROP_BGCOLOR, C'15,15,25');  // Darker to distinguish from commentary
        ObjectSetInteger(0, box_name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
        ObjectSetInteger(0, box_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, box_name, OBJPROP_BACK, true);
    }

    // Title
    string title_name = prefix + "ButtonStatus_Title";
    if(ObjectFind(0, title_name) < 0)
    {
        ObjectCreate(0, title_name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, title_name, OBJPROP_XDISTANCE, x + 10);
        ObjectSetInteger(0, title_name, OBJPROP_YDISTANCE, y + 6);
        ObjectSetInteger(0, title_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetString(0, title_name, OBJPROP_FONT, "Arial Bold");
        ObjectSetInteger(0, title_name, OBJPROP_FONTSIZE, 11);
        ObjectSetString(0, title_name, OBJPROP_TEXT, "══ BUTTON STATUS ══");
        ObjectSetInteger(0, title_name, OBJPROP_COLOR, clrCyan);
    }

    // Clear old button status labels
    for(int i = 0; i < 10; i++)
    {
        string label_name = prefix + "ButtonStatus_" + IntegerToString(i);
        ObjectDelete(0, label_name);
    }

    // Draw button status lines - show last few button changes
    int start_index = MathMax(0, button_status_count - max_lines);

    for(int i = start_index; i < button_status_count; i++)
    {
        string label_name = prefix + "ButtonStatus_" + IntegerToString(i);

        ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, label_name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
        ObjectSetString(0, label_name, OBJPROP_FONT, "Arial");
        ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 10);

        ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
        ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, y + 28 + (i - start_index) * line_height);
        ObjectSetString(0, label_name, OBJPROP_TEXT, button_status_buffer[i].text);
        ObjectSetInteger(0, label_name, OBJPROP_COLOR, button_status_buffer[i].text_color);
    }

    // Show message if no button changes yet
    if(button_status_count == 0)
    {
        string label_name = prefix + "ButtonStatus_0";
        ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetString(0, label_name, OBJPROP_FONT, "Arial");
        ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 10);
        ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
        ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, y + 28);
        ObjectSetString(0, label_name, OBJPROP_TEXT, "Ready - Click buttons to configure filters...");
        ObjectSetInteger(0, label_name, OBJPROP_COLOR, clrGray);
    }
}

//+------------------------------------------------------------------+
