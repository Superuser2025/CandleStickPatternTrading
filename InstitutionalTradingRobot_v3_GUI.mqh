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
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_COLOR, clrWhite);
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
//| DRAW BIG READABLE COMMENTARY                                     |
//+------------------------------------------------------------------+
void DrawBigCommentary()
{
    string box_name = prefix + "Commentary_Box";

    if(!g_ShowCommentary)
    {
        // Hide commentary
        ObjectDelete(0, box_name);
        for(int i = 0; i < 100; i++)
        {
            ObjectDelete(0, prefix + "C_" + IntegerToString(i));
        }
        return;
    }

    int x = 320;  // Right side of buttons
    int y = 90;   // MOVED DOWN to avoid overlap with title
    int width = 800;
    int line_height = 26;  // BIGGER line height for readability
    int max_lines = 30;

    // Background box
    if(ObjectFind(0, box_name) < 0)
    {
        ObjectCreate(0, box_name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
        ObjectSetInteger(0, box_name, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(0, box_name, OBJPROP_YDISTANCE, y);
        ObjectSetInteger(0, box_name, OBJPROP_XSIZE, width);
        ObjectSetInteger(0, box_name, OBJPROP_YSIZE, max_lines * line_height);
        ObjectSetInteger(0, box_name, OBJPROP_BGCOLOR, C'20,20,30');
        ObjectSetInteger(0, box_name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
        ObjectSetInteger(0, box_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, box_name, OBJPROP_BACK, true);
    }

    // Title
    string title_name = prefix + "Commentary_Title";
    if(ObjectFind(0, title_name) < 0)
    {
        ObjectCreate(0, title_name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, title_name, OBJPROP_XDISTANCE, x + 10);
        ObjectSetInteger(0, title_name, OBJPROP_YDISTANCE, y + 5);
        ObjectSetInteger(0, title_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetString(0, title_name, OBJPROP_FONT, "Arial Bold");
        ObjectSetInteger(0, title_name, OBJPROP_FONTSIZE, 14);
        ObjectSetString(0, title_name, OBJPROP_TEXT, "═══ REAL-TIME ANALYSIS ═══");
        ObjectSetInteger(0, title_name, OBJPROP_COLOR, clrWhite);
    }

    // Draw commentary lines - BIGGER FONT
    int start_index = MathMax(0, commentary_count - max_lines);

    for(int i = start_index; i < commentary_count; i++)
    {
        string label_name = prefix + "Comment_" + IntegerToString(i);

        if(ObjectFind(0, label_name) < 0)
        {
            ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
            ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetInteger(0, label_name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
            ObjectSetString(0, label_name, OBJPROP_FONT, "Consolas");
            ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 13);  // BIGGER: increased to 13 for better readability
        }

        ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
        ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, y + 35 + (i - start_index) * line_height);
        ObjectSetString(0, label_name, OBJPROP_TEXT, commentary_buffer[i].text);
        ObjectSetInteger(0, label_name, OBJPROP_COLOR, commentary_buffer[i].text_color);
    }
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
