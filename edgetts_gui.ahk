
#Include <JSON>
#SingleInstance Force
 ;函数体
if A_ScriptFullPath = A_LineFile {
     ; 主要运行函数体
}
; new task 添加脚本记忆主播功能 测试表现第一个主播就很好了
; 文件禁用特殊符号在文件名中的过滤，不考虑使用该方式进行
; 杀死已经运行的进程，以免测试时候按了多个进程不好关闭。
; 使用process关闭 打开的run进程 就在run进程hide后面的varef参数及是回调id
; ProcessExist 判断进程是否还存在然后再进行close即可。

; 尝试考虑是否加入菜单栏选项，以及在常用库中添加菜单选项预设库。

;开始进行自己的脚本编写
; 写一个文件名快速转化脚本用来引用
;代码写代码，快速写完某些测试开头等脚本，命名为规范操作。

; new task：命令行标准化，以便于后续增修预设

; 单行ini用命令以及初始化************************************************
; IniWrite(0, "set.ini", "setting", "model")
; IniWrite("", "set.ini", "model1")
; IniWrite("", "set.ini", "model2")
; IniWrite("", "set.ini", "model3")
; IniDelete("set.ini","setting","model")
; IniRead("set.ini", "", , "")
; *********************************************************************
edgetts_playstr :=
    (
        "欢迎体验 TTS 音质测试！123，do re mi，一二三，走起～        多音字测试：银行门口，他行色匆匆。        儿化音：这儿有份儿小吃，味儿倍儿棒！        轻声与停顿：好的，我们——稍等，马上回来。        连续语流：四是四，十是十，十四是十四，四十是四十。        数字+单位：2025年9月20日，气温24.5℃，风速3.2m/s。        英文缩写：USB、AI、TTS、NASA，读得清楚吗？        标点语气：真的？假的！哦……原来如此。        长句挑战：他指出，尽管当前全球经济复苏仍面临诸多不确定因素，但各国通过加强多边合作、推动绿色转型，有望实现更加包容和可持续的增长。        情绪模拟：（平静）今天天气不错。（兴奋）哇！彩虹！（悲伤）可惜，它转瞬即逝……        结尾测试：谢谢聆听，再见！Goodbye～
        "
    )
edgetts_processlist := []
; MsgBox edgetts_playstr
edgettsgui := Gui()
edgettsgui.SetFont("s" A_ScreenHeight/1080*14)
edgettsgui.MarginX := 3
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
edgettsgui.AddEdit("yp15 xp10 w400 h30", edgetts_playstr)
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
    ; MsgBox edgetts_map[]
}
edgettsgui.AddDropDownList("yp w200 choose1", edgetts_voicelist).OnEvent("Change", edgetts_droplistfun)
edgetts_droplistfun(*) {
    ControlSetText('edge-playback -t "' edgetts_playstr '" -v ' edgetts_map[ControlGetText("combobox1", "edgetts")], "edit3", "edgetts")
}
;上述控件的测试代码，照例隐藏
; MsgBox edgetts_voicelist.Length
edgettsgui.AddButton("yp w60 hp", "测试").OnEvent("Click", edgetts_play)
edgetts_play(*) {
    ; MsgBox edgetts_map[ControlGetText("combobox1", "edgetts")]
    Run('cmd /c edge-playback -t "' RegExReplace(ControlGetText("edit1", "edgetts"), "\R") '" -v ' edgetts_map[ControlGetText("combobox1", "edgetts")], , "hide", &proid)
    edgetts_processlist.Push(proid)
    ; Run('cmd /c edge-playback -t "你好 "')
}
edgettsgui.AddButton("yp hp w60", "转化").OnEvent("Click", edgetts_tts_single_main)
edgettsgui.AddCheckbox("yp hp", "srt") ;button4
edgettsgui.AddButton("yp hp", "预览").OnEvent("Click", edgetts_open_explore)
edgetts_open_explore(*) {
    if ControlGetText("edit1", "edgetts") != "" {
        try Run('explore ' ControlGetText("edit1", "edgetts"))
    } else
        Run('explore ') ;添加一个空格代表打开当前工作目录文件
}
edgetts_tts_single_main(*) {
    edge_edit_text := RegExReplace(ControlGetText("edit1", "edgetts"), "\R")
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
        Run('cmd /c edge-tts  -f ' edge_edit_text '.txt ' . '--write-subtitles ' filename '.srt -v ' edgetts_map[ControlGetText("combobox1", "edgetts")] '', , "hide", &proid)
    } else {
        Run('cmd /c edge-tts -t "' edge_edit_text '"' filename '.txt  --write-subtitles ' filename '.srt -v ' edgetts_map[ControlGetText("combobox1", "edgetts")], , "hide", &proid)
    }
    ; "edge-tts [-h] [-t TEXT] [-f FILE] [-v VOICE] [-l] [--rate RATE] [--volume VOLUME] [--pitch PITCH] [--write-media WRITE_MEDIA] [--write-subtitles WRITE_SUBTITLES] [--proxy PROXY]"
}


; ********************批量处理****************************


edgettsgui.AddGroupBox("xs  w900 h330")
edgettsgui.AddEdit("yp20 xp10 w820 h300 Border ReadOnly -VScroll")
edgettsgui.AddButton("yp w60 h40", "批量处理").OnEvent("Click", edgetts_tts_mutual_main)


edgetts_tts_mutual_main(*) {
    if ControlGetText("edit2", "edgetts") {
        for i in StrSplit(ControlGetText("edit2", "edgetts"), "`n") {

        }

    }
    ; 检测编辑框是否可只读 使用readonly可以只读，依然可以复制选中内容
    ; 判断进程状态码，判断edit编辑框运行行，
    judge_status(cmdLine) {
        cmdLine ; ← 改成你的命令
        shell := ComObject("WScript.Shell")
        exec := shell.Exec(cmdLine)

        ; 实时读取子进程输出
        ; output := ''
        while exec.Status = 0 {               ; 0 = 仍在运行
            ; if !exec.StdOut.AtEndOfStream
            ; output .= exec.StdOut.ReadLine() "`n"
            ; Sleep(50)
        }
        ; 收尾：把剩余输出读干净
        ; while !exec.StdOut.AtEndOfStream
        ; output .= exec.StdOut.ReadLine() "`n"

        ; exitCode := exec.ExitCode            ; 拿到退出码
        ; ToolTip("命令已结束`n退出码: " exitCode, 200, 200)
        ; SetTimer(() => ToolTip(), -1500)     ; 1.5 秒后自动消失
    }
}

edgettsgui.AddButton("xp w60 hp", "预览文件").OnEvent("Click", edgetts_mutal_open_explore)
edgetts_mutal_open_explore(*) {
    ControlGetText("edit2", "edgetts")
}
edgettsgui.AddButton("xp w60 ", "关闭播放进程").OnEvent("click", edgetts_kill_process)
edgetts_kill_process(*) {
    ; edgetts_processlist := []
    global edgetts_processlist
    for i in edgetts_processlist {
        if ProcessExist(i) {
            ; MsgBox i
            ; ProcessClose(i)
            ; taskkill /PID <进程ID> /F
            Run('*RunAs cmd.exe /c "taskkill /PID ' i ' /F"')
            ; 同前，二者都无法关闭已经打开的播放进程，推测是使用了另外一个播放进程，所以当前进程无法被终止。
            ; Run('*RunAs ' 'cmd.exe "taskkill /PID /F"')
        }
    }
    ; edgetts_processlist := []
}
; **************************************模板*********************
edgettsgui.AddGroupBox("yp-100 xp70 w70 h320")
edgettsgui.AddDDL("yp15 xp5  w60 choose1", ["设1", "设2", "设3"]).OnEvent("Change", edgetts_models)
edgetts_models(*) {
    IniWrite(1, "set.ini", "setting", "model")
    switch ControlGetText("combobox2", "edgetts") {
        case "设1":
            IniWrite(1, "set.ini", "setting", "model")
            ; MsgBox "Ok"

        case "设2":
            IniWrite(2, "set.ini", "setting", "model")
            ; MsgBox "Ok2"
        case "设3":
            IniWrite(3, "set.ini", "setting", "model")
            ; MsgBox "Ok3"

        default: MsgBox "Okd"
    }
}
edgettsgui.AddButton("xp yp245 w60 ", "存为当前预设").OnEvent("Click", edgetts_save_model)
edgetts_save_model(*) {
    ; 切分当前命令行或者解析当前可以被读取进入命令行的东西，比如说编辑框3，将它保存为预设，使用，所以预设中应该以显示命令行为主。
}
; ******************************************************************

; ****************************命令行*****************************
edgettsgui.AddGroupBox("xs w950 h100")
;预警，tts测试用长文本！！！！！！！！！！
edgettsgui.AddEdit("xp10 yp15 w800  vscroll h80 ReadOnly", edgetts_playstr)
edgettsgui.AddText("w60 yp30 hp xp810    0x1 ", "使用命令行") ;照例0x220是垂直居中的意思。
edgettsgui.AddButton("w60 yp-30 xp60  hp", "运行").OnEvent() ;需要能够返回错误信息。


edgettsgui.Show("h600 w1000")
^q:: edgetts_exit()
f1:: {
    ahktts_help_txt := "
    (
    快捷键操作：`n Escape & ctrl+q ：退出脚本
    本项目开源地址：https://github.com/lkh2bloom/ahktts
        "12346test"
)"
    ToolTip ahktts_help_txt
    ; SetTimer(, , -1)
    Sleep 500
    ToolTip
}