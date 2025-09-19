#Include <JSON>
; 添加脚本记忆主播功能
; 文件禁用特殊符号在文件名中的过滤
edgettsgui := Gui()
edgettsgui.SetFont("s14")
edgettsgui.MarginX := 2
edgettsgui.MarginY := 5
edgettsgui.Opt("+OwnDialogs")
edgettsgui.OnEvent("Escape", edgetts_exit)
edgetts_exit(*) {
    ExitApp()
}
edgettsgui.OnEvent("DropFiles", edge_dropf)
edge_filelist := []
edge_dropf(GuiObj, GuiCtrlObj, FileArray, X, Y) {
    temp := ""
    if FileArray.Length > 1 {
        for i in FileArray {
            ; MsgBox FileArray.Length
            try if StrSplit(i, ".")[2] = "txt" or StrSplit(i, ".")[2] = "md"
                temp .= i . "`r`n" ;注意edit中使用的换行符方式与常规方式有所不同
            edge_filelist.Push(i)
            ; MsgBox StrSplit(i, ".")[2]
        }
        ; MsgBox temp
        ControlSetText(temp, "edit2", "edgetts")

    } else {
        try if StrSplit(FileArray[1], ".")[2] = "txt" or StrSplit(i, ".")[2] = "md"
            temp .= FileArray[1]
        ControlSetText(temp, "edit1", "edgetts")
    }
}
edgettsgui.AddGroupBox("w930 h50")
edgettsgui.AddEdit("yp15 xp10 w400", "拖入文件")
edgettsgui.AddButton("yp w20 h25  ", "…").OnEvent("Click", edgetts_fileopen)
edgetts_fileopen(*) {
    tempfilename := FileSelect(, , "浏览文件", "TEXT(*.txt)")
    if tempfilename
        ControlSetText(tempfilename, "edit1", "edgetts")
}
edgetts_voicelist := []
edgetts_command_voicelist := []
edgetts_map := Map()
edgevoicjson := FileRead("voice.json", "utf-8")
for i in JSON.parse(edgevoicjson) {
    edgetts_voicelist.push((i["gender"] = "Male" ? i["voice"] . "-" . "(男)" : i["voice"] . "-" . "(女)"))
    edgetts_command_voicelist.Push(i["style"])
    edgetts_map[(i["gender"] = "Male" ? i["voice"] . "-" . "(男)" : i["voice"] . "-" . "(女)")] := i["style"]
    ; MsgBox edgetts_commandvoicelist[1]
}
edgettsgui.AddDropDownList("yp w200 choose1", edgetts_voicelist)
; .OnEvent("Change",(*)=>MsgBox(ControlGetText("combobox1","edgetts"))) 上述控件的测试代码，照例隐藏
; MsgBox edgetts_voicelist.Length
edgettsgui.AddButton("yp w60 hp", "测试").OnEvent("Click", edgetts_play)
edgetts_play(*) {
    ; MsgBox ControlGetText("combobox1","edgetts")
    Run('cmd /c edge-playback -t "' ControlGetText("edit1", "edgetts") '" -v ' edgetts_map[ControlGetText("combobox1", "edgetts")], , "hide")
}
edgettsgui.AddButton("yp hp w60", "转化").OnEvent("Click", edgetts_tts_single_main)
edgettsgui.AddCheckbox("yp hp", "srt") ;button4
edgettsgui.AddButton("yp hp", "预览").OnEvent("Click", edgetts_open_explore)
edgetts_open_explore(*) {
    if ControlGetText("edit1","edgetts")!=""{
        try Run('explore ' ControlGetText("edit1" ,"edgetts"))
    } else
        Run('explore ') ;添加一个空格代表打开当前工作目录文件
}
edgetts_tts_single_main(*) {
    edge_edit_text := ControlGetText("edit1", "edgetts")
    if ControlGetChecked("button3", "edgetts")
        edge_writ_srt_string := " " . edge_edit_text
    if InStr(edge_edit_text, ".txt") {
        filename := InStr(StrSplit(edge_edit_text, ".txt")[1], "/") ? StrSplit(StrSplit(edge_edit_text, ".txt")[1], "/")[-1] : StrSplit(edge_edit_text, ".txt")[1]
        ; MsgBox filename
        ; 测试目前斜杠和txt不在文件名中显示，利于后续命名方便
    } else {
        if StrLen(edge_edit_text) < 20 {
            filename := edge_edit_text
        } else {
            filename := SubStr(edge_edit_text, 1, 20) . "……"
        }
    }
    if InStr(edge_edit_text, ".txt") {
        ; MsgBox "ok"
        Run("cmd /k edge-tts " "-f " edge_edit_text ".txt " . "--write-subtitles " filename ".srt")
    } else {
        Run('cmd /k edge-tts -t "' edge_edit_text '"' filename ".txt " "--write-subtitles " filename ".srt")
    }
    ; "edge-tts [-h] [-t TEXT] [-f FILE] [-v VOICE] [-l] [--rate RATE] [--volume VOLUME] [--pitch PITCH] [--write-media WRITE_MEDIA] [--write-subtitles WRITE_SUBTITLES] [--proxy PROXY]"
}


; ********************批量处理****************************


edgettsgui.AddGroupBox("xs  w900 h330")
edgettsgui.AddEdit("yp20 xp10 w820 h300 Border")
edgettsgui.AddButton("yp w60 h40", "批量处理").OnEvent("Click", edgetts_tts_mutual_main)


edgetts_tts_mutual_main(*) {
    
}
edgettsgui.AddButton("xp w60 hp","预览文件").OnEvent("Click",edgetts_mutal_open_explore)
edgetts_mutal_open_explore(*){
    ControlGetText("edit2","edgetts")
    
}
edgettsgui.Show("h600 w1000")

^q::edgetts_exit()