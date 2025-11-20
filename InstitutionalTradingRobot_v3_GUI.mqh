//+------------------------------------------------------------------+
//| InstitutionalTradingRobot_v3_GUI.mqh                             |
//| Interactive GUI - Clickable Buttons & Controls                   |
//+------------------------------------------------------------------+

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

Button gui_buttons[25];
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
                      EnableTrading ? "MODE: AUTO TRADING ✓" : "MODE: INDICATOR ONLY",
                      EnableTrading, clrLime, clrOrange, "MODE");
    row++;

    row++; // Spacing

    // SECTION: INSTITUTIONAL FILTERS
    CreateBigLabel("GUI_Filters", x_start, y_start + row * (button_height + spacing),
                   "─── INSTITUTIONAL FILTERS ───", clrAqua, 12, false);
    row++;

    CreateToggleButton("BTN_VOLUME", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Volume Filter",
                      UseVolumeFilter, clrLime, clrRed, "VOLUME");
    row++;

    CreateToggleButton("BTN_SPREAD", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Spread Filter",
                      UseSpreadFilter, clrLime, clrRed, "SPREAD");
    row++;

    CreateToggleButton("BTN_SLIPPAGE", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Slippage Model",
                      UseSlippageModel, clrLime, clrRed, "SLIPPAGE");
    row++;

    CreateToggleButton("BTN_MTF", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Multi-Timeframe Confirm",
                      UseMTFConfirmation, clrLime, clrRed, "MTF");
    row++;

    CreateToggleButton("BTN_SESSION", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Session Filter",
                      UseSessionFilter, clrLime, clrRed, "SESSION");
    row++;

    CreateToggleButton("BTN_CORRELATION", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Correlation Filter",
                      UseCorrelationFilter, clrLime, clrRed, "CORRELATION");
    row++;

    CreateToggleButton("BTN_NEWS", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "News Filter",
                      UseNewsFilter, clrLime, clrRed, "NEWS");
    row++;

    CreateToggleButton("BTN_VOLATILITY", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Volatility Adaptation",
                      UseVolatilityAdaptation, clrLime, clrRed, "VOLATILITY");
    row++;

    CreateToggleButton("BTN_DYNAMIC_RISK", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Dynamic Risk",
                      UseDynamicRisk, clrLime, clrRed, "DYNAMIC_RISK");
    row++;

    CreateToggleButton("BTN_PATTERN_DECAY", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Pattern Decay",
                      UsePatternDecay, clrLime, clrRed, "PATTERN_DECAY");
    row++;

    row++; // Spacing

    // SECTION: SMART MONEY
    CreateBigLabel("GUI_SmartMoney", x_start, y_start + row * (button_height + spacing),
                   "─── SMART MONEY CONCEPTS ───", clrAqua, 12, false);
    row++;

    CreateToggleButton("BTN_LIQUIDITY", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Liquidity Sweep",
                      UseLiquiditySweep, clrLime, clrRed, "LIQUIDITY");
    row++;

    CreateToggleButton("BTN_RETAIL_TRAP", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Retail Trap Detection",
                      UseRetailTrap, clrLime, clrRed, "RETAIL_TRAP");
    row++;

    CreateToggleButton("BTN_OB_INVALID", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Order Block Invalidation",
                      UseOrderBlockInvalidation, clrLime, clrRed, "OB_INVALID");
    row++;

    CreateToggleButton("BTN_STRUCTURE", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Market Structure",
                      UseMarketStructure, clrLime, clrRed, "STRUCTURE");
    row++;

    row++; // Spacing

    // SECTION: MACHINE LEARNING
    CreateBigLabel("GUI_ML", x_start, y_start + row * (button_height + spacing),
                   "─── MACHINE LEARNING ───", clrAqua, 12, false);
    row++;

    CreateToggleButton("BTN_PATTERN_TRACK", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Pattern Performance Tracking",
                      UsePatternTracking, clrLime, clrRed, "PATTERN_TRACK");
    row++;

    CreateToggleButton("BTN_ADAPTATION", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Parameter Adaptation",
                      UseParameterAdaptation, clrLime, clrRed, "ADAPTATION");
    row++;

    CreateToggleButton("BTN_REGIME_STRATEGY", x_start, y_start + row * (button_height + spacing),
                      button_width, button_height,
                      "Regime Strategy",
                      UseRegimeStrategy, clrLime, clrRed, "REGIME_STRATEGY");
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
    if(button_count >= 25) return;

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

    // Create button object
    ObjectCreate(0, gui_buttons[button_count].name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_XSIZE, width);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_YSIZE, height);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_BGCOLOR,
                    initial_state ? col_on : col_off);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_BORDER_COLOR, clrWhite);
    ObjectSetInteger(0, gui_buttons[button_count].name, OBJPROP_WIDTH, 2);

    // Create text label on button
    string label_name = gui_buttons[button_count].name + "_TXT";
    ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
    ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, y + 8);
    ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetString(0, label_name, OBJPROP_FONT, "Arial Bold");
    ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 11);
    ObjectSetString(0, label_name, OBJPROP_TEXT,
                   text + (initial_state ? " [ON]" : " [OFF]"));
    ObjectSetInteger(0, label_name, OBJPROP_COLOR, clrWhite);

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
        color bg_color = gui_buttons[i].state ? gui_buttons[i].color_on : gui_buttons[i].color_off;
        ObjectSetInteger(0, gui_buttons[i].name, OBJPROP_BGCOLOR, bg_color);

        string label_name = gui_buttons[i].name + "_TXT";
        ObjectSetString(0, label_name, OBJPROP_TEXT,
                       gui_buttons[i].text + (gui_buttons[i].state ? " [ON]" : " [OFF]"));
    }
}

//+------------------------------------------------------------------+
//| HANDLE BUTTON CLICK                                              |
//+------------------------------------------------------------------+
void HandleButtonClick(int x, int y)
{
    for(int i = 0; i < button_count; i++)
    {
        if(x >= gui_buttons[i].x && x <= gui_buttons[i].x + gui_buttons[i].width &&
           y >= gui_buttons[i].y && y <= gui_buttons[i].y + gui_buttons[i].height)
        {
            // Toggle button state
            gui_buttons[i].state = !gui_buttons[i].state;

            // Update the actual setting
            UpdateSetting(gui_buttons[i].setting, gui_buttons[i].state);

            // Visual feedback
            UpdateAllButtons();

            // Log the change
            Print(">>> SETTING CHANGED: ", gui_buttons[i].setting, " = ",
                 gui_buttons[i].state ? "ON" : "OFF");

            AddComment("✓ " + gui_buttons[i].text + " switched " +
                      (gui_buttons[i].state ? "ON" : "OFF"),
                      gui_buttons[i].state ? clrLime : clrOrange,
                      PRIORITY_CRITICAL);

            break;
        }
    }
}

//+------------------------------------------------------------------+
//| UPDATE ACTUAL SETTING VARIABLE                                   |
//+------------------------------------------------------------------+
void UpdateSetting(string setting, bool value)
{
    if(setting == "MODE")
    {
        EnableTrading = value;
        if(value)
            AddComment("⚠ AUTO-TRADING ENABLED - EA will execute trades!", clrRed, PRIORITY_CRITICAL);
        else
            AddComment("✓ Switched to INDICATOR MODE - No trading", clrLime, PRIORITY_CRITICAL);
    }
    else if(setting == "VOLUME") UseVolumeFilter = value;
    else if(setting == "SPREAD") UseSpreadFilter = value;
    else if(setting == "SLIPPAGE") UseSlippageModel = value;
    else if(setting == "MTF") UseMTFConfirmation = value;
    else if(setting == "SESSION") UseSessionFilter = value;
    else if(setting == "CORRELATION") UseCorrelationFilter = value;
    else if(setting == "NEWS") UseNewsFilter = value;
    else if(setting == "VOLATILITY") UseVolatilityAdaptation = value;
    else if(setting == "DYNAMIC_RISK") UseDynamicRisk = value;
    else if(setting == "PATTERN_DECAY") UsePatternDecay = value;
    else if(setting == "LIQUIDITY") UseLiquiditySweep = value;
    else if(setting == "RETAIL_TRAP") UseRetailTrap = value;
    else if(setting == "OB_INVALID") UseOrderBlockInvalidation = value;
    else if(setting == "STRUCTURE") UseMarketStructure = value;
    else if(setting == "PATTERN_TRACK") UsePatternTracking = value;
    else if(setting == "ADAPTATION") UseParameterAdaptation = value;
    else if(setting == "REGIME_STRATEGY") UseRegimeStrategy = value;
}

//+------------------------------------------------------------------+
//| DRAW BIG READABLE COMMENTARY                                     |
//+------------------------------------------------------------------+
void DrawBigCommentary()
{
    int x = 320;  // Right side of buttons
    int y = 50;
    int width = 800;
    int line_height = 24;  // BIGGER line height
    int max_lines = 30;

    // Background box
    string box_name = prefix + "Commentary_Box";
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
            ObjectSetInteger(0, label_name, OBJPROP_FONTSIZE, 11);  // BIGGER: was 8, now 11
        }

        ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, x + 10);
        ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, y + 35 + (i - start_index) * line_height);
        ObjectSetString(0, label_name, OBJPROP_TEXT, commentary_buffer[i].text);
        ObjectSetInteger(0, label_name, OBJPROP_COLOR, commentary_buffer[i].text_color);
    }
}

//+------------------------------------------------------------------+
