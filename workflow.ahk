; 各种脚本转tts ocr转tts 网页转tts，合并文章转tts。
; 该工作流不支持代码tts，例如将工作流代码截图会报错。
; 对于是否支持高并发需要通过批量测试才知道，其对CPU的占用需要测试才能明白上限在哪。
; *************************ocr 转tts************************


; 自媒体常用播放声音:  -v zh-CN-YunxiNeural

#SingleInstance Force
#Include <JSON>
#Include <FindText>
#Include <CGdip>
#Include <wincapture\wincapture>
#Include <RapidOcr\RapidOcr>
#Include <map>

;函数体
if A_ScriptFullPath = A_LineFile {
    tts_workflow:=Gui()
    tts_workflow.Opt("-DPIScale")
    tts_workflow.MarginX:=5
    tts_workflow.MarginY:=5
    tts_workflow.SetFont("s" A_ScreenHeight/1080*14)
    tts_workflow.OnEvent("Escape",(*)=>ExitApp())
    tts_workflow.AddRadio("","粘贴板模式").Value:=1
    tts_workflow.AddRadio("","临时文件模式")
    tts_workflow.AddText("yp","格式复杂使用这个")
    ;连续radio视为一个排他组合框
    tts_workflow.AddRadio()

    ;其classnn编码也是button标识
    tts_workflow.Show("h" A_ScreenHeight*0.6 "w" A_ScreenWidth*0.6)
    ; 主要运行函数体
    ;  批量识别：

    ; 截图识别：使用sharex快捷截图然后加入temp进行读取
    ; 重写文件&剪切板读取 不需要监测剪切板变化也可以跑通程序。  
    ocr_clip(*) {
        ocr := RapidOcr()
        CGdip.Startup()
        try temptxt := ocr.ocr_from_bitmapdata(BitmapBuffer.loadGpBitmap(CGdip.Bitmap.FromClipboard()).info)
        CGdip.Shutdown()
        try temptxt := RegExReplace(RegExReplace(RegExReplace(temptxt, "(([.!?:;。！？，：；]))(\R)", "$1#PRESERVE#"), "\R"), "#PRESERVE#", ",")
        Run('cmd /k edge-playback -t"' temptxt '" -v zh-CN-XiaochenMultilingualNeural --rate="+20%"') ;使用rate增加减少播放速率 
        ;同理必然存在情感色彩参数调节，情感色彩只能通过Python调节，无法通过来进行。
        ; try A_Clipboard := ocr.ocr_from_bitmapdata(BitmapBuffer.loadGpBitmap(CGdip.Bitmap.FromClipboard()).info)
    }

}