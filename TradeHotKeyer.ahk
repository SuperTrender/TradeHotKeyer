#NoEnv

periods_h1_d      := ["h1", "d"]
periods_h1_h4_d_w := ["h1", "h4", "d", "w"]

finamTradeWinTitle := "FinamTrade"
metaTraderWinTitle := "ahk_class " + "MetaQuotes::MetaTrader::4.00"

periodIndexFinamTrade := 0
periodControlCoordsFinamTrade := {x: 580, y: 270}
periodsCoordsFinamTrade := {h1: {x: 970, y: 400}
    , h4: {x: 750, y: 450}
    , d:  {x: 590, y: 500}
    , w:  {x: 660, y: 500}}
deltaFinamTrade := 40
mouseMoveCoordsFinamTrade := {x: periodControlCoordsFinamTrade.x - deltaFinamTrade
    , y: periodControlCoordsFinamTrade.y - deltaFinamTrade}
scrollInstrumentsCoordsUpFinamTrade := {x: 520, y: 250}
scrollInstrumentsCoordsDownFinamTrade := {x: 520, y: 1100}

periodIndexMetaTrader := 0
periodControlCoordsMetaTrader := {x: 200, y: 50}
periodsCoordsMetaTrader := {h1: {x: 540, y: 150}
    , h4: {x: 585, y: 150}
    , d:  {x: 630, y: 150}
    , w:  {x: 670, y: 150}}
mouseMoveCoordsMetaTrader := {x: 430, y: 50}

#If WinActive(finamTradeWinTitle)

^Up::
SetSystemCursor()
    x := scrollInstrumentsCoordsUpFinamTrade.x
    y := scrollInstrumentsCoordsUpFinamTrade.y
    Click %x% %y%
RestoreCursors()
return

^Down::
SetSystemCursor()
    x := scrollInstrumentsCoordsDownFinamTrade.x
    y := scrollInstrumentsCoordsDownFinamTrade.y
    Click %x% %y%
RestoreCursors()
return

#If WinExist(finamTradeWinTitle)

!1::
    WinActivate
    choosePeriod(1)
return

!2::
    WinActivate
    choosePeriod(2)
return

!3::
    WinActivate
    choosePeriod(3)
return

!4::
    WinActivate
    choosePeriod(4)
return

!Left::
    WinActivate
    trader := new FinamTrade(periodIndexFinamTrade, periods_h1_d, false)
    periodIndexFinamTrade := trader.changePeriod()
return

!Right::
    WinActivate
    trader := new FinamTrade(periodIndexFinamTrade, periods_h1_d, true)
    periodIndexFinamTrade := trader.changePeriod()
return

#If WinExist(metaTraderWinTitle)

^+Left::
    WinActivate
    trader := new MetaTrader(periodIndexMetaTrader, periods_h1_d, false)
    periodIndexMetaTrader := trader.changePeriod()
return

^+Right::
    WinActivate
    trader := new MetaTrader(periodIndexMetaTrader, periods_h1_d, true)
    periodIndexMetaTrader := trader.changePeriod()
return

#If WinActive(finamTradeWinTitle) or WinActive(metaTraderWinTitle)

!+Left::
    changePeriod(periods_h1_h4_d_w, false)
return

!+Right::
    changePeriod(periods_h1_h4_d_w, true)
return

choosePeriod(periodIndex)
{
    global
    if (WinActive(finamTradeWinTitle))
    {
        trader := new FinamTrade(periodIndex, periods_h1_h4_d_w, true)
        periodIndexFinamTrade := trader.choosePeriod()
    }
    else if (WinActive(metaTraderWinTitle))
    {
        trader := new MetaTrader(periodIndex, periods_h1_h4_d_w, true)
        periodIndexMetaTrader := trader.choosePeriod()
    }
}

changePeriod(periods, encrease)
{
    global
    if (WinActive(finamTradeWinTitle))
    {
        trader := new FinamTrade(periodIndexFinamTrade, periods, encrease)
        periodIndexFinamTrade := trader.changePeriod()
    }
    else if (WinActive(metaTraderWinTitle))
    {
        trader := new MetaTrader(periodIndexMetaTrader, periods, encrease)
        periodIndexMetaTrader := trader.changePeriod()
    }
}

class Trader
{
    shouldClickPeriodControl := true

    __New(periodIndex, periods, encrease)
    {
        this.periodIndex := periodIndex
        this.periods := periods
        this.encrease := encrease
    }

    choosePeriod()
    {
        showCursor(false)
        this.clickPeriodControl()
        this.clickPeriod()
        this.moveMouse()
        showCursor(true)
        return this.periodIndex
    }

    changePeriod()
    {
        showCursor(false)
;       SetSystemCursor()
        this.changePeriodIndex()
        this.clickPeriodControl()
        this.clickPeriod()
        this.moveMouse()
        showCursor(true)
;       RestoreCursors()
        return this.periodIndex
    }

    changePeriodIndex()
    {
        if (this.encrease)
        {
            this.encreasePeriodIndex()
        }
        else
        {
            this.decreasePeriodIndex()
        }
    }

    encreasePeriodIndex()
    {
        this.periodIndex++
        if (this.periodIndex > this.periods.length())
        {
            this.periodIndex := 1
        }
    }

    decreasePeriodIndex()
    {
        this.periodIndex--
        if (this.periodIndex < 1)
        {
            this.periodIndex := this.periods.length()
        }
    }

    clickPeriodControl()
    {
        if (!this.shouldClickPeriodControl)
        {
            return
        }
        x := this.periodControlCoords.x
        y := this.periodControlCoords.y
        Click %x% %y%
    }

    clickPeriod()
    {
        x := this.periodsCoords[this.periods[this.periodIndex]].x
        y := this.periodsCoords[this.periods[this.periodIndex]].y
        Click %x% %y%
    }

    moveMouse()
    {
        x := this.mouseMoveCoords.x
        y := this.mouseMoveCoords.y
        MouseMove, x, y
    }
}

class FinamTrade extends Trader
{
    periodControlCoords := periodControlCoordsFinamTrade
    periodsCoords := periodsCoordsFinamTrade
    mouseMoveCoords := mouseMoveCoordsFinamTrade

    __New(periodIndex, periods, encrease)
    {
        base.__New(periodIndex, periods, encrease)
    }
}

class MetaTrader extends Trader
{
    periodControlCoords := periodControlCoordsMetaTrader
    periodsCoords := periodsCoordsMetaTrader
    mouseMoveCoords := mouseMoveCoordsMetaTrader

    __New(periodIndex, periods, encrease)
    {
        global
        base.__New(periodIndex, periods, encrease)
        this.extendedPeriods := this.periods.length() == periods_h1_h4_d_w.length()
        this.shouldClickPeriodControl := this.extendedPeriods
    }

    clickPeriod()
    {
        global
        if (this.extendedPeriods)
        {
            repeat := this.periodIndex + 3
            Send, % "{Down 7}{Enter}{Down " repeat "}{Enter}"
        }
        else
        {
            base.clickPeriod()
        }
    }
}

/**
https://www.autohotkey.com/boards/viewtopic.php?t=6167
*/
showCursor(show) {
    if (show)
    {
       BlockInput MouseMoveOff
       DllCall("ShowCursor", int, 1)
    } 
    else 
    {
       MouseGetPos, , , hwnd
       Gui Cursor:+Owner%hwnd%
       BlockInput MouseMove
       DllCall("ShowCursor", int, 0)
    }
}

SetSystemCursor( Cursor = "", cx = 0, cy = 0 )
{
    BlankCursor := 0, SystemCursor := 0, FileCursor := 0 ; init
    
    SystemCursors = 32512IDC_ARROW,32513IDC_IBEAM,32514IDC_WAIT,32515IDC_CROSS
    ,32516IDC_UPARROW,32640IDC_SIZE,32641IDC_ICON,32642IDC_SIZENWSE
    ,32643IDC_SIZENESW,32644IDC_SIZEWE,32645IDC_SIZENS,32646IDC_SIZEALL
    ,32648IDC_NO,32649IDC_HAND,32650IDC_APPSTARTING,32651IDC_HELP
    
    If Cursor = ; empty, so create blank cursor 
    {
        VarSetCapacity( AndMask, 32*4, 0xFF ), VarSetCapacity( XorMask, 32*4, 0 )
        BlankCursor = 1 ; flag for later
    }
    Else If SubStr( Cursor,1,4 ) = "IDC_" ; load system cursor
    {
        Loop, Parse, SystemCursors, `,
        {
            CursorName := SubStr( A_Loopfield, 6, 15 ) ; get the cursor name, no trailing space with substr
            CursorID := SubStr( A_Loopfield, 1, 5 ) ; get the cursor id
            SystemCursor = 1
            If ( CursorName = Cursor )
            {
                CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )   
                Break                   
            }
        }   
        If CursorHandle = ; invalid cursor name given
        {
            Msgbox,, SetCursor, Error: Invalid cursor name
            CursorHandle = Error
        }
    }   
    Else If FileExist( Cursor )
    {
        SplitPath, Cursor,,, Ext ; auto-detect type
        If Ext = ico 
            uType := 0x1    
        Else If Ext in cur,ani
            uType := 0x2        
        Else ; invalid file ext
        {
            Msgbox,, SetCursor, Error: Invalid file type
            CursorHandle = Error
        }       
        FileCursor = 1
    }
    Else
    {   
        Msgbox,, SetCursor, Error: Invalid file path or cursor name
        CursorHandle = Error ; raise for later
    }
    If CursorHandle != Error 
    {
        Loop, Parse, SystemCursors, `,
        {
            If BlankCursor = 1 
            {
                Type = BlankCursor
                %Type%%A_Index% := DllCall( "CreateCursor"
                , Uint,0, Int,0, Int,0, Int,32, Int,32, Uint,&AndMask, Uint,&XorMask )
                CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
                DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
            }           
            Else If SystemCursor = 1
            {
                Type = SystemCursor
                CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )   
                %Type%%A_Index% := DllCall( "CopyImage"
                , Uint,CursorHandle, Uint,0x2, Int,cx, Int,cy, Uint,0 )     
                CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
                DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
            }
            Else If FileCursor = 1
            {
                Type = FileCursor
                %Type%%A_Index% := DllCall( "LoadImageA"
                , UInt,0, Str,Cursor, UInt,uType, Int,cx, Int,cy, UInt,0x10 ) 
                DllCall( "SetSystemCursor", Uint,%Type%%A_Index%, Int,SubStr( A_Loopfield, 1, 5 ) )         
            }          
        }
    }   
}

RestoreCursors()
{
    SPI_SETCURSORS := 0x57
    DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
}

; MsgBox, % "ErrorLevel = " ErrorLevel
/*
try
{
}
catch e
{
    lastError := DllCall("GetLastError", "int")
    MsgBox % "lastError = " lastError
    MsgBox % "Message = " e.Message " What = " e.What " Extra = " e.Extra " Line = " e.Line
}
*/
