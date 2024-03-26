#NoEnv

finamTradeWinTitle := "FinamTrade"
metaTraderWinTitle := "ahk_class " + "MetaQuotes::MetaTrader::4.00"

periods_h1_d      := ["h1", "d"]
periods_h1_h4_d_w := ["h1", "h4", "d", "w"]
periodIndex = 0

periodControl := {x: 531, y: 261}

periodsCoordsFinamTrade := {h1: {x: 890, y: 380}
    , h4: {x: 680, y: 425}
    , d:  {x: 540, y: 475}
    , w:  {x: 610, y: 475}}
delta := 40

periodsCoordsMetaTrader := {h1: {x: 540, y: 150}
    , h4: {x: 585, y: 150}
    , d:  {x: 630, y: 150}
    , w:  {x: 670, y: 150}}

class Trader
{
    name := "Trader"
    periodsCoords := {}
}

class FinamTrade extends Trader
{
    name := "FinamTrade"
    periodsCoords := periodsCoordsFinamTrade
}

class MetaTrader extends Trader
{
    name := "MetaTrader"
    periodsCoords := periodsCoordsMetaTrader
}

trader := new Trader()
finamTrade := new FinamTrade()
metaTrader := new MetaTrader()
MsgBox, % "finamTrade.periodsCoords.h1.x = " finamTrade.periodsCoords.h1.x
	. " metaTrader.periodsCoords.h1.x = " metaTrader.periodsCoords.h1.x

#If WinActive(finamTradeWinTitle) or WinActive(metaTraderWinTitle)

!Left::
    changePeriod(periods_h1_d, false)
return

!Right::
    changePeriod(periods_h1_d, true)
return

!+Left::
    changePeriod(periods_h1_h4_d_w, false)
return

!+Right::
    changePeriod(periods_h1_h4_d_w, true)
return

changePeriod(periods, encrease)
{
    initVars()
    changePeriodIndex(periods, encrease)
    clickPeriodControl()
    clickPeriod(periods)
    moveMouse()
}

initVars()
{
    global
    if (WinActive(finamTradeWinTitle))
    {
		initPeriodsCoords(periodsCoordsFinamTrade)
        shouldClickPeriodControl := true
        shouldMoveMouse := true
    }
    else if (WinActive(metaTraderWinTitle))
    {
		initPeriodsCoords(periodsCoordsMetaTrader)
        shouldClickPeriodControl := false
        shouldMoveMouse := false
    }
}

initPeriodsCoords(srcPeriodsCoords)
{
    global
    periodsCoords := {}
    for key, value in srcPeriodsCoords
    {
        periodsCoords[key] := value
    }
}

changePeriodIndex(periods, encrease)
{
    if (encrease == true)
    {
        encreasePeriodIndex(periods)
    }
    else
    {
        decreasePeriodIndex(periods)
    }
}

encreasePeriodIndex(periods)
{
    global
    periodIndex++
    if (periodIndex > periods.Length())
    {
        periodIndex := 1
    }
}

decreasePeriodIndex(periods)
{
    global
    periodIndex--
    if (periodIndex < 1)
    {
        periodIndex := periods.Length()
    }
}

clickPeriodControl()
{
    global
    if (!shouldClickPeriodControl)
    {
        return
    }
    x := periodControl.x
    y := periodControl.y
    Click %x% %y%
}

clickPeriod(periods)
{
    global
    x := periodsCoords[periods[periodIndex]].x
    y := periodsCoords[periods[periodIndex]].y
    Click %x% %y%
}

moveMouse()
{
    global
    if (!shouldMoveMouse)
    {
        return
    }
    MouseMove, periodControl.x - delta, periodControl.y - delta
}

; MsgBox, % "x = " x
