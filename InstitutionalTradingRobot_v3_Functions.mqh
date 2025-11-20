//+------------------------------------------------------------------+
//| InstitutionalTradingRobot_v3_Functions.mqh                       |
//| Supporting Functions for Institutional Trading Robot v3.0        |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| FIX #2: SPREAD ANALYSIS                                          |
//+------------------------------------------------------------------+
void AnalyzeSpread()
{
    long spread_points = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
    double spread_pips = spread_points * _Point / 10.0;

    double atr_buffer[];
    ArraySetAsSeries(atr_buffer, true);
    if(CopyBuffer(h_ATR, 0, 0, 1, atr_buffer) <= 0)
    {
        spread_data.acceptable = false;
        return;
    }

    double atr = atr_buffer[0];
    double max_spread = atr * MaxSpreadPercent;
    double max_spread_pips = max_spread / _Point / 10.0;

    spread_data.current_pips = spread_pips;
    spread_data.max_allowed_pips = max_spread_pips;
    spread_data.acceptable = (spread_pips <= max_spread_pips);
}

//+------------------------------------------------------------------+
//| FIX #6: SESSION ANALYSIS                                         |
//+------------------------------------------------------------------+
void AnalyzeSession()
{
    MqlDateTime dt;
    TimeToStruct(TimeGMT(), dt);
    int hour = dt.hour;

    if(hour >= 0 && hour < 8)
    {
        current_session = SESSION_ASIAN;
        session_data.current_session = SESSION_ASIAN;
        session_data.session_name = "Asian";
        session_data.expected_volatility = 0.5;
        session_data.is_tradeable = TradeAsianSession;
    }
    else if(hour >= 8 && hour < 13)
    {
        current_session = SESSION_LONDON;
        session_data.current_session = SESSION_LONDON;
        session_data.session_name = "London";
        session_data.expected_volatility = 1.2;
        session_data.is_tradeable = TradeLondonSession;
    }
    else if(hour >= 13 && hour < 16)
    {
        current_session = SESSION_OVERLAP;
        session_data.current_session = SESSION_OVERLAP;
        session_data.session_name = "London-NY Overlap";
        session_data.expected_volatility = 1.5;
        session_data.is_tradeable = (TradeLondonSession && TradeNYSession);
    }
    else if(hour >= 16 && hour < 21)
    {
        current_session = SESSION_NY;
        session_data.current_session = SESSION_NY;
        session_data.session_name = "New York";
        session_data.expected_volatility = 1.1;
        session_data.is_tradeable = TradeNYSession;
    }
    else
    {
        current_session = SESSION_CLOSED;
        session_data.current_session = SESSION_CLOSED;
        session_data.session_name = "After Hours";
        session_data.expected_volatility = 0.3;
        session_data.is_tradeable = false;
    }
}

//+------------------------------------------------------------------+
//| FIX #8: ECONOMIC CALENDAR CHECK                                  |
//+------------------------------------------------------------------+
void CheckEconomicCalendar()
{
    news_count = 0;

    MqlCalendarValue values[];
    datetime from = TimeCurrent();
    datetime to = TimeCurrent() + NewsAvoidMinutes * 60;

    if(CalendarValueHistory(values, from, to) > 0)
    {
        for(int i = 0; i < ArraySize(values); i++)
        {
            MqlCalendarEvent event;
            if(CalendarEventById(values[i].event_id, event))
            {
                if(event.importance == CALENDAR_IMPORTANCE_HIGH)
                {
                    if(news_count < 20)
                    {
                        upcoming_news[news_count].event_time = values[i].time;
                        upcoming_news[news_count].event_name = event.name;
                        upcoming_news[news_count].importance = event.importance;
                        upcoming_news[news_count].is_near = true;

                        MqlCalendarCountry country;
                        CalendarCountryById(event.country_id, country);
                        upcoming_news[news_count].currency = country.currency;

                        news_count++;
                    }
                }
            }
        }
    }
}

//+------------------------------------------------------------------+
//| FIX #9: VOLATILITY REGIME ANALYSIS                               |
//+------------------------------------------------------------------+
void AnalyzeVolatilityRegime()
{
    double atr_buffer[];
    ArraySetAsSeries(atr_buffer, true);
    if(CopyBuffer(h_ATR, 0, 0, 100, atr_buffer) <= 0) return;

    double atr_current = atr_buffer[0];
    double atr_sum = 0;
    for(int i = 0; i < 100; i++)
        atr_sum += atr_buffer[i];
    double atr_avg = atr_sum / 100;

    double ratio = atr_current / atr_avg;

    volatility_data.atr_current = atr_current;
    volatility_data.atr_average = atr_avg;
    volatility_data.ratio = ratio;

    if(ratio < 0.7)
        current_volatility = VOL_LOW;
    else if(ratio > 1.5)
        current_volatility = VOL_HIGH;
    else
        current_volatility = VOL_NORMAL;

    volatility_data.regime = current_volatility;
}

//+------------------------------------------------------------------+
//| DETECT MARKET REGIME                                             |
//+------------------------------------------------------------------+
void DetectMarketRegime()
{
    double ema_buffer[];
    double atr_buffer[];
    ArraySetAsSeries(ema_buffer, true);
    ArraySetAsSeries(atr_buffer, true);

    if(CopyBuffer(h_EMA_200, 0, 0, 50, ema_buffer) <= 0) return;
    if(CopyBuffer(h_ATR, 0, 0, 20, atr_buffer) <= 0) return;

    // Calculate EMA slope
    double ema_slope = (ema_buffer[0] - ema_buffer[10]) / 10;

    // Calculate ATR ratio
    double atr_sum = 0;
    for(int i = 0; i < 10; i++)
        atr_sum += atr_buffer[i];
    double atr_avg = atr_sum / 10;
    double atr_ratio = atr_buffer[0] / atr_avg;

    // Detect regime
    if(MathAbs(ema_slope) > 0.0001 && atr_ratio > 0.8)
        current_regime = REGIME_TREND;
    else if(MathAbs(ema_slope) < 0.00005 && atr_ratio < 1.1)
        current_regime = REGIME_RANGE;
    else
        current_regime = REGIME_TRANSITION;
}

//+------------------------------------------------------------------+
//| DETERMINE MARKET BIAS                                            |
//+------------------------------------------------------------------+
void DetermineBias()
{
    double ema_buffer[];
    ArraySetAsSeries(ema_buffer, true);
    if(CopyBuffer(h_EMA_200, 0, 0, 3, ema_buffer) <= 0) return;

    double close_price = iClose(_Symbol, PreferredTimeframe, 1);

    if(current_regime == REGIME_TREND)
    {
        if(close_price > ema_buffer[0])
            current_bias = BIAS_BULLISH;
        else
            current_bias = BIAS_BEARISH;
    }
    else if(current_regime == REGIME_RANGE)
    {
        double range_high = GetRangeHigh(50);
        double range_low = GetRangeLow(50);
        double range_size = range_high - range_low;

        if(close_price < range_low + range_size * 0.2)
            current_bias = BIAS_BULLISH;
        else if(close_price > range_high - range_size * 0.2)
            current_bias = BIAS_BEARISH;
        else
            current_bias = BIAS_NEUTRAL;
    }
    else
    {
        current_bias = BIAS_NEUTRAL;
    }
}

//+------------------------------------------------------------------+
//| FIX #16: UPDATE MARKET STRUCTURE                                 |
//+------------------------------------------------------------------+
void UpdateMarketStructure()
{
    double swing_high = GetSwingHigh(20);
    double swing_low = GetSwingLow(20);

    // Bullish structure: Higher Highs and Higher Lows
    if(swing_high > market_structure.last_HH && swing_low > market_structure.last_HL)
    {
        market_structure.structure = "BULLISH (HH+HL)";
        market_structure.last_HH = swing_high;
        market_structure.last_HL = swing_low;
        market_structure.last_update = TimeCurrent();
    }
    // Bearish structure: Lower Highs and Lower Lows
    else if(swing_high < market_structure.last_LH && swing_low < market_structure.last_LL)
    {
        market_structure.structure = "BEARISH (LH+LL)";
        market_structure.last_LH = swing_high;
        market_structure.last_LL = swing_low;
        market_structure.last_update = TimeCurrent();
    }
    else
    {
        market_structure.structure = "CHOPPY";
    }
}

//+------------------------------------------------------------------+
//| MAP LIQUIDITY ZONES                                              |
//+------------------------------------------------------------------+
void MapLiquidityZones()
{
    liquidity_count = 0;
    int lookback = 20;

    for(int i = lookback; i < 100 && liquidity_count < 100; i++)
    {
        double high = iHigh(_Symbol, PreferredTimeframe, i);
        double low = iLow(_Symbol, PreferredTimeframe, i);
        datetime time = iTime(_Symbol, PreferredTimeframe, i);

        // Check for swing high
        bool is_swing_high = true;
        for(int j = 1; j <= lookback; j++)
        {
            if(i-j < 0 || i+j >= Bars(_Symbol, PreferredTimeframe))
            {
                is_swing_high = false;
                break;
            }
            if(iHigh(_Symbol, PreferredTimeframe, i-j) >= high ||
               iHigh(_Symbol, PreferredTimeframe, i+j) >= high)
            {
                is_swing_high = false;
                break;
            }
        }

        if(is_swing_high)
        {
            liquidity_zones[liquidity_count].price = high;
            liquidity_zones[liquidity_count].is_high = true;
            liquidity_zones[liquidity_count].time = time;
            liquidity_zones[liquidity_count].touch_count = 0;
            liquidity_zones[liquidity_count].swept = false;
            liquidity_count++;
        }

        // Check for swing low
        bool is_swing_low = true;
        for(int j = 1; j <= lookback; j++)
        {
            if(i-j < 0 || i+j >= Bars(_Symbol, PreferredTimeframe))
            {
                is_swing_low = false;
                break;
            }
            if(iLow(_Symbol, PreferredTimeframe, i-j) <= low ||
               iLow(_Symbol, PreferredTimeframe, i+j) <= low)
            {
                is_swing_low = false;
                break;
            }
        }

        if(is_swing_low && liquidity_count < 100)
        {
            liquidity_zones[liquidity_count].price = low;
            liquidity_zones[liquidity_count].is_high = false;
            liquidity_zones[liquidity_count].time = time;
            liquidity_zones[liquidity_count].touch_count = 0;
            liquidity_zones[liquidity_count].swept = false;
            liquidity_count++;
        }
    }
}

//+------------------------------------------------------------------+
//| DETECT FAIR VALUE GAPS                                           |
//+------------------------------------------------------------------+
void DetectFairValueGaps()
{
    fvg_count = 0;
    double min_gap = 5 * _Point * 10;

    for(int i = 1; i < 50 && fvg_count < 50; i++)
    {
        double high1 = iHigh(_Symbol, PreferredTimeframe, i+1);
        double low1 = iLow(_Symbol, PreferredTimeframe, i+1);
        double high3 = iHigh(_Symbol, PreferredTimeframe, i-1);
        double low3 = iLow(_Symbol, PreferredTimeframe, i-1);

        // Bullish FVG
        if(low3 > high1 && (low3 - high1) >= min_gap)
        {
            fvg_zones[fvg_count].top = low3;
            fvg_zones[fvg_count].bottom = high1;
            fvg_zones[fvg_count].time = iTime(_Symbol, PreferredTimeframe, i);
            fvg_zones[fvg_count].is_bullish = true;
            fvg_zones[fvg_count].filled = false;
            fvg_zones[fvg_count].fill_percentage = 0;
            fvg_count++;
        }

        // Bearish FVG
        if(high3 < low1 && (low1 - high3) >= min_gap && fvg_count < 50)
        {
            fvg_zones[fvg_count].top = low1;
            fvg_zones[fvg_count].bottom = high3;
            fvg_zones[fvg_count].time = iTime(_Symbol, PreferredTimeframe, i);
            fvg_zones[fvg_count].is_bullish = false;
            fvg_zones[fvg_count].filled = false;
            fvg_zones[fvg_count].fill_percentage = 0;
            fvg_count++;
        }
    }
}

//+------------------------------------------------------------------+
//| DETECT ORDER BLOCKS                                              |
//+------------------------------------------------------------------+
void DetectOrderBlocks()
{
    ob_count = 0;

    for(int i = 2; i < 100 && ob_count < 50; i++)
    {
        double close_prev = iClose(_Symbol, PreferredTimeframe, i);
        double open_prev = iOpen(_Symbol, PreferredTimeframe, i);
        double close_curr = iClose(_Symbol, PreferredTimeframe, i-1);

        // Bullish Order Block
        if(close_prev < open_prev && close_curr > close_prev)
        {
            order_blocks[ob_count].top = MathMax(open_prev, close_prev);
            order_blocks[ob_count].bottom = MathMin(open_prev, close_prev);
            order_blocks[ob_count].time = iTime(_Symbol, PreferredTimeframe, i);
            order_blocks[ob_count].is_bullish = true;
            order_blocks[ob_count].test_count = 0;
            order_blocks[ob_count].invalidated = false;
            ob_count++;
        }

        // Bearish Order Block
        if(close_prev > open_prev && close_curr < close_prev && ob_count < 50)
        {
            order_blocks[ob_count].top = MathMax(open_prev, close_prev);
            order_blocks[ob_count].bottom = MathMin(open_prev, close_prev);
            order_blocks[ob_count].time = iTime(_Symbol, PreferredTimeframe, i);
            order_blocks[ob_count].is_bullish = false;
            order_blocks[ob_count].test_count = 0;
            order_blocks[ob_count].invalidated = false;
            ob_count++;
        }
    }

    // FIX #15: Update Order Block Invalidation
    if(UseOrderBlockInvalidation)
        UpdateOrderBlockInvalidation();
}

//+------------------------------------------------------------------+
//| FIX #15: ORDER BLOCK INVALIDATION                                |
//+------------------------------------------------------------------+
void UpdateOrderBlockInvalidation()
{
    double current_price = iClose(_Symbol, PreferredTimeframe, 0);

    for(int i = 0; i < ob_count; i++)
    {
        if(order_blocks[i].invalidated) continue;

        // Check if price is testing the OB
        if(current_price >= order_blocks[i].bottom && current_price <= order_blocks[i].top)
        {
            order_blocks[i].test_count++;
            order_blocks[i].last_test_time = TimeCurrent();

            if(order_blocks[i].test_count >= MaxOBTests)
            {
                order_blocks[i].invalidated = true;
                AddComment("Order Block INVALIDATED (max tests reached)", clrRed, PRIORITY_IMPORTANT);
            }
        }
    }
}

//+------------------------------------------------------------------+
//| FIX #1: VOLUME ANALYSIS                                          |
//+------------------------------------------------------------------+
void AnalyzeVolume()
{
    long current_vol = iVolume(_Symbol, PreferredTimeframe, 1);

    double vol_ma_buffer[];
    ArraySetAsSeries(vol_ma_buffer, true);
    if(CopyBuffer(h_Volume_MA, 0, 0, 20, vol_ma_buffer) <= 0)
    {
        volume_data.above_threshold = false;
        return;
    }

    double avg_vol = vol_ma_buffer[0];

    volume_data.current_volume = (double)current_vol;
    volume_data.average_volume = avg_vol;
    volume_data.volume_ratio = current_vol / avg_vol;
    volume_data.above_threshold = (volume_data.volume_ratio >= MinVolumeMultiplier);
    volume_data.spike_detected = (volume_data.volume_ratio >= 2.0);
}

//+------------------------------------------------------------------+
//| FIX #5: MULTI-TIMEFRAME CONFIRMATION                             |
//+------------------------------------------------------------------+
bool CheckMultiTimeframeAlignment()
{
    double ema_higher_buffer[];
    ArraySetAsSeries(ema_higher_buffer, true);
    if(CopyBuffer(h_EMA_Higher, 0, 0, 1, ema_higher_buffer) <= 0)
        return false;

    ENUM_TIMEFRAMES higher_tf = GetHigherTimeframe(PreferredTimeframe);
    double price_higher = iClose(_Symbol, higher_tf, 0);

    bool higher_bullish = (price_higher > ema_higher_buffer[0]);
    bool higher_bearish = (price_higher < ema_higher_buffer[0]);

    // Check alignment with pattern direction
    if(active_pattern.is_bullish && higher_bearish) return false;
    if(!active_pattern.is_bullish && higher_bullish) return false;

    return true;
}

//+------------------------------------------------------------------+
//| FIX #7: PORTFOLIO CORRELATION CHECK                              |
//+------------------------------------------------------------------+
bool CheckPortfolioCorrelation()
{
    string base_currency = StringSubstr(_Symbol, 0, 3);
    string quote_currency = StringSubstr(_Symbol, 3, 3);

    double net_exposure = 0;

    for(int i = 0; i < PositionsTotal(); i++)
    {
        if(position.SelectByIndex(i))
        {
            if(position.Magic() != MagicNumber) continue;

            string pos_symbol = position.Symbol();
            string pos_base = StringSubstr(pos_symbol, 0, 3);
            string pos_quote = StringSubstr(pos_symbol, 3, 3);

            double lots = position.Volume();
            int direction = (position.Type() == POSITION_TYPE_BUY) ? 1 : -1;

            // Check correlation
            if(pos_base == base_currency || pos_quote == quote_currency ||
               pos_base == quote_currency || pos_quote == base_currency)
            {
                net_exposure += lots * direction;
            }
        }
    }

    // Reject if over-exposed
    if(MathAbs(net_exposure) > MaxCorrelationExposure * 10)
        return false;

    return true;
}

//+------------------------------------------------------------------+
//| FIX #13: LIQUIDITY SWEEP DETECTION                               |
//+------------------------------------------------------------------+
bool CheckLiquiditySweep(bool is_buy_pattern)
{
    double current_high = iHigh(_Symbol, PreferredTimeframe, 1);
    double current_low = iLow(_Symbol, PreferredTimeframe, 1);
    double current_close = iClose(_Symbol, PreferredTimeframe, 1);

    if(is_buy_pattern)
    {
        // Look for sweep below previous low
        for(int i = 0; i < liquidity_count; i++)
        {
            if(!liquidity_zones[i].is_high)
            {
                double prev_low = liquidity_zones[i].price;
                // Sweep = went below then closed above
                if(current_low < prev_low && current_close > prev_low)
                {
                    liquidity_zones[i].swept = true;
                    return true;
                }
            }
        }
    }
    else
    {
        // Look for sweep above previous high
        for(int i = 0; i < liquidity_count; i++)
        {
            if(liquidity_zones[i].is_high)
            {
                double prev_high = liquidity_zones[i].price;
                // Sweep = went above then closed below
                if(current_high > prev_high && current_close < prev_high)
                {
                    liquidity_zones[i].swept = true;
                    return true;
                }
            }
        }
    }

    return false;
}

//+------------------------------------------------------------------+
//| FIX #14: RETAIL TRAP DETECTION                                   |
//+------------------------------------------------------------------+
bool DetectRetailTrap()
{
    double high1 = iHigh(_Symbol, PreferredTimeframe, 1);
    double close1 = iClose(_Symbol, PreferredTimeframe, 1);

    // Find nearest resistance
    double resistance = 0;
    for(int i = 0; i < liquidity_count; i++)
    {
        if(liquidity_zones[i].is_high && liquidity_zones[i].price > close1)
        {
            if(resistance == 0 || liquidity_zones[i].price < resistance)
                resistance = liquidity_zones[i].price;
        }
    }

    if(resistance == 0) return false;

    // Fake breakout: breaks above but closes below with high volume
    if(high1 > resistance && close1 < resistance && volume_data.volume_ratio > 2.0)
        return true;

    return false;
}

//+------------------------------------------------------------------+
//| HELPER FUNCTIONS                                                  |
//+------------------------------------------------------------------+
double GetSwingHigh(int lookback)
{
    double high = 0;
    for(int i = 1; i <= lookback; i++)
    {
        double h = iHigh(_Symbol, PreferredTimeframe, i);
        if(h > high) high = h;
    }
    return high;
}

double GetSwingLow(int lookback)
{
    double low = DBL_MAX;
    for(int i = 1; i <= lookback; i++)
    {
        double l = iLow(_Symbol, PreferredTimeframe, i);
        if(l < low) low = l;
    }
    return low;
}

double GetRangeHigh(int lookback)
{
    double high = 0;
    for(int i = 1; i < lookback; i++)
    {
        double h = iHigh(_Symbol, PreferredTimeframe, i);
        if(h > high) high = h;
    }
    return high;
}

double GetRangeLow(int lookback)
{
    double low = DBL_MAX;
    for(int i = 1; i < lookback; i++)
    {
        double l = iLow(_Symbol, PreferredTimeframe, i);
        if(l < low) low = l;
    }
    return low;
}

//+------------------------------------------------------------------+
