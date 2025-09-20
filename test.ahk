#Requires AutoHotkey v2.0
#SingleInstance Force
cmdLine := 'cmd /k "echo 开始&& timeout /t 3 >nul && echo 完成"'   ; ← 改成你的命令
shell   := ComObject("WScript.Shell")
exec    := shell.Exec(cmdLine,A_WorkingDir)

; 实时读取子进程输出
output := ''
while exec.Status = 0 {               ; 0 = 仍在运行
    if !exec.StdOut.AtEndOfStream
        output .= exec.StdOut.ReadLine() "`n"
    Sleep(50)
}
; 收尾：把剩余输出读干净
while !exec.StdOut.AtEndOfStream
    output .= exec.StdOut.ReadLine() "`n"

exitCode := exec.ExitCode            ; 拿到退出码
ToolTip("命令已结束`n退出码: " exitCode, 200, 200)
SetTimer(() => ToolTip(), -1500)     ; 1.5 秒后自动消失