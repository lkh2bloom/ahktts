CoordMode("Mouse","Screen")
#SuspendExempt true
MButton::Suspend()
#SuspendExempt false
WheelDown::{
    MouseGetPos(&x,&y)
    Click "1386 1248"
    MouseMove x,y
}
WheelUp::{
    MouseGetPos(&x,&y)
    Click "1245 1248"
    MouseMove x,y

}