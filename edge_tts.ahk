; 准备工作:
; 1、 pip isntall edge-tts 之后把下载的脚本加入系统环境变量使用，
; 2、 推荐使用Anaconda进行下载，只需要把script文件夹加入脚本未来再有新的脚本就不需要每次手动加入环境变量了
; ahk运行示例：Run('cmd /c edge-tts --text "大家好" --write-media ' A_Now '.mp3' )
edgettsgui := Gui()
edgettsgui.Opt("-DPIScale")
edgettsgui.SetFont("s14")
edgettsgui.OnEvent("Escape", edge_exit)
edge_exit(*) {
    ExitApp()
}
; ***************************前端区************************
edgettsgui.AddEdit("w400")
edgettsgui.AddButton("yp w120", "go")
edgettsgui.AddText("yp w60", "配音：")
edgettsgui.AddDropDownList("yp w100", [1, 2, 3, 4])
; edgettsgui.add
edgettsgui.OnEvent("DropFiles", Gui_DropFiles)

Gui_DropFiles(GuiObj, GuiCtrlObj, FileArray, X, Y) {
    for i in FileArray
        if FileExist(i) = "D"
            MsgBox "Ok" ;除了文件外大部分为A
        else
            MsgBox FileExist(i)
}

edgettsgui.Show("h600 w1000")