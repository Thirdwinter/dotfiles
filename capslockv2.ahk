; 禁用CapsLock键 
SetCapsLockState, AlwaysOff
CapsLock::
    Send, {Esc} ; 发送Esc键
return

;CapsLock + o快速插入邮箱
CapsLock & o::
    SendMode, Input
    SendInput, zzx15601035637@outlook.com
return

;切换大小写锁定
CapsLock & `::
    Send, {Blind}{CapsLock}
Return

; 移动光标
CapsLock & w::
    Send, {Blind}{Up Down}{Up Up}
Return

CapsLock & a::
    Send, {Blind}{Left Down}{Left Up}
Return

CapsLock & s::
    Send, {Blind}{Down Down}{Down Up}
Return

CapsLock & d::
    Send, {Blind}{Right Down}{Right Up}
Return
; 全选ctrl a
CapsLock & q::
    Send, {Blind}^a
Return

; 保存
CapsLock & e::
    Send, {Blind}^s
Return
; 撤销
CapsLock & f::
    Send, {Blind}^z
Return

; 剪切
CapsLock & x::
    Send, {Blind}^x
Return
;复制
CapsLock & c::
    Send, {Blind}^c
Return
;粘贴
CapsLock & v::
    Send, {Blind}^v
Return
;home
CapsLock & j::
    Send, {Blind}{Home}
return
;end
CapsLock & l::
    Send, {Blind}{End}
return

CapsLock & i::
    Send, {Blind}{PgUp}
return

CapsLock & k::
    Send, {Blind}{PgDn}
return
;向左选中一个字符
CapsLock & 1::
    SendInput {Blind}+{Left}
return

CapsLock & 2::
    SendInput {Blind}+{Down}
return

CapsLock & 3::
    SendInput {Blind}+{Up}
return

CapsLock & 4::
    SendInput {Blind}+{Right}
return

CapsLock & 7::
    SendInput {Blind}+{Home}
return

CapsLock & 8::
    SendInput {Blind}+{PgDn}
return

CapsLock & 9::
    SendInput {Blind}+{PgUp}
return

CapsLock & 0::
    SendInput {Blind}+{End}
return

CapsLock & p::
    Send, {Blind}{BackSpace}
return
CapsLock & h::
    Send, {Blind}{Enter}
return

; ; 在按下Caps Lock + T时打开指定程序
CapsLock & t::
    Run, "D:\wezterm\qwe.exe"
Return

CapsLock & n::
    Send, {Blind}^{Left}
Return

CapsLock & m::
    Send, {Blind}^{Right}
Return

CapsLock & r::
    Send, {Blind}+^{Left}
Return

CapsLock & g::
    Send, {Blind}+^{Right}
Return

CapsLock & ,::
    Send, {Blind}+^{Left}{BackSpace}
Return

CapsLock & .::
    Send, {Blind}+^{Right}{BackSpace}
Return