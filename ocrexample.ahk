#Include <RapidOcr\RapidOcr>
#Include <wincapture\wincapture>
#Include <CGdip>
OnClipboardChange(ocrfun, 1)
ocrfun(*) {
    CGdip.Startup()
    ocr := RapidOcr()
    try temptxt := ocr.ocr_from_bitmapdata(BitmapBuffer.loadGpBitmap(CGdip.Bitmap.FromClipboard()).info)
    CGdip.Shutdown()
    MsgBox  RegExReplace(RegExReplace(RegExReplace(temptxt, "([.!?:;。！？，：；])(\R)", "$1#PRESERVE#"), "\R"), "#PRESERVE#", "`n")
    MsgBox temptxt
}

; text :=
;     (
;         "
; 这是一个例子。
; 这是新的一行，但前面没有标点
; 这里应该连在一起。
; 但这一行前面有句号，应该保留换行
; "
;     )

; ; 正则表达式处理
; ; 保留标点后的换行，其他换行删除
; result := RegExReplace(text, "([.!?,:;。！？，：；])(\R)", "#PRESERVE#")  ; [.!?,:;。！？，：；] 临时标记保留的换行
; result := RegExReplace(result, "\R")                         ; 删除所有未保留的换行
; result := RegExReplace(result, "#PRESERVE#", "`n")               ; 恢复保留的换行

; MsgBox result
