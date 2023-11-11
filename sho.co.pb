EnableExplicit
UsePNGImageDecoder()

Global SoundSystemOK = InitSound()

If InitSprite() = 0
	MessageRequester("", "InitSprite failed", #PB_MessageRequester_Error)
	End
EndIf
InitKeyboard()
InitMouse()

#AppTitle$ = "sho.co 2"
#NewFileName$ = "*New*"

#SCR_BACKGROUND = $302520
#NbDecimals = 4
#CHECK_RAM = 1

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
	#NL$ = #CRLF$
CompilerElse
	#NL$ = #LF$
CompilerEndIf	

Enumeration ENUM_MENU 1
	#m_New
	#m_Open
	#m_Save
	#m_SaveAs
	#m_Undo
	#m_Redo
	#m_Close
	#m_Quit
	#m_Parse
	#m_ParseRun
	#m_Help
	#m_SearchPopup
	#m_SearchSel
	#m_SearchCase
	#m_SearchWhole
	#m_SearchRegEx
	#m_SearchPrev
	#m_SearchNext
	#m_Comment
	#m_Uncomment
	
	#m_Run
	#m_Step
	#m_StepOut
	#m_ExportC
	#m_Hilight
	#m_Monitor
EndEnumeration

Enumeration
	#t_Main
	#t_Monitor
EndEnumeration

Enumeration ENUM_GADGET 1
	#g_FilePanel
	#g_SplitterEditorH
	#g_SplitterEditorV
	#g_SplitterMonitor
	#g_Error
	#g_Monitor
	#g_Variables
	#g_SubContainer
	#g_Sub
	#g_SearchContainer
	#g_SearchText
	#g_SearchPrev
	#g_SearchNext
	#g_SearchOptions
	#g_Help
EndEnumeration

Enumeration ENUM_WINDOW 1
	#w_Main
	#w_Screen
	#w_Monitor
	#w_Help
EndEnumeration

EnumerationBinary ENUM_FLAG
	#FLAG_EQUAL
	#FLAG_NOTEQUAL
	#FLAG_GREATER
	#FLAG_LOWER
EndEnumeration

Enumeration ENUM_ADDRESSMODE
	#ADR_DIRECT  =  %0000
	#ADR_INDIRECT = %0001
	#ADR_POINTER =  %0010
	#ADR_INDX_DI =  %0100
	#ADR_INDX_IN =  %1000
EndEnumeration

Enumeration	
	#SYM_INT
	#SYM_FLOAT	
	#SYM_CONSTANT
	#SYM_STRING
	#SYM_OPCODE
	#SYM_VARIABLE
	#SYM_SUB
	#SYM_ADDRESS
	#SYM_LABEL
	#SYM_FIELD
EndEnumeration

EnumerationBinary ENUM_RUNSTATE
	#STATE_END
	#STATE_RUN
	#STATE_PAUSE
	#STATE_STEP
	#STATE_STEPOUT
	#STATE_ERROR
	#STATE_QUIT
EndEnumeration

EnumerationBinary ENUM_READSTATE
	#READ_SUB
	#READ_IF
	#READ_ELSE
	#READ_LOOP
EndEnumeration

Enumeration ENUM_TOKENTYPE
	#T_UNKNOWN
	#T_OPCODE
	#T_VARIABLE
	#T_PERIOD
	#T_NUMBER
	#T_SUB
	#T_LABEL
	#T_BRACKET_OPEN
	#T_BRACKET_CLOSE
	#T_NEWLINE
	#T_SEPARATOR
	#T_FIELD
	#T_ELSE	
	#T_BREAK
	#T_STRING
	#T_COMMENT
	#T_SOUND
EndEnumeration

EnumerationBinary
	#Button_Left
	#Button_Right
EndEnumeration

Enumeration ENUM_OPCODE
	#_END = 0
	#_KIL
	#_SET
	#_INT
	#_NTH
	#_CIL
	#_MOV
	#_RND
	#_WRT
	#_ADD
	#_SUB
	#_MUL
	#_DIV
	#_POW
	#_MOD
	#_NEG
	#_ABS
	#_MIN
	#_MAX
	#_SGN
	#_JMP
	#_JMF
	#_STP
	#_TO
	#_IFL
	#_ILO
	#_IGR
	#_ILE
	#_IGE
	#_IEQ
	#_INE
	#_PSH
	#_POP
	#_PSF
	#_POF
	#_PSC
	#_POC
	#_CAL
	#_RET
	#_CHS
	#_CHM
	#_CXY
	#_CHR
	#_CLF
	#_CLB
	#_PLT
	#_SCR
	#_DRW
	#_CLS
	#_INP
	#_KEY
	#_SNP
	#_SNS
	#_DLY
	#_DBG
	#_HLT
EndEnumeration

Structure TOKEN
	type.a
	index.i
	position.i
	length.i
	text.s
	value.d
	*opcode.OPCODE
EndStructure

Structure OPCODE
	name.s
	ID.a
	nParams.i
	size.i
	procAddress.i
	ip.i
EndStructure

Structure ExitList
	bracketCount.i
	lineNr.i
	exit_adr.i
	List adrList.i()
	adr.i
	*data.DATASECT
EndStructure

Structure VARIABLE
	name.s
	key.s
	adr.i
	prevValue.d
	infoLineNr.i
EndStructure

Structure CONSTANT
	type.i
	name.s
	key.s
	adr.i
	value.i
EndStructure

Structure DATASECT
	type.i
	*token.TOKEN
	startAdr.i
	endAdr.i
	lineNr.i
EndStructure

Structure CPU
	Array RAM.d(0)						; memory ram
	Array VRAM.u(0)						; video ram
	Array STACK.d(0)					; stack ram
	IP.i                                ; instruction pointer
	SP.i                                ; stack pointer
	V.i									; V-Register holds address of current variable	
	X.i									; X-Register holds the current LOOP variable
	C.d									; C-Register
	FLAGS.i								; flag register
EndStructure

Structure SYMTABLE
	type.i
	name.s
	lineNr.i
	*token.TOKEN
	*var.VARIABLE
EndStructure

Structure SYSTEM
	CPU.CPU
	
	prevIP.i
	nextIP.i                            
	
	Array symTable.SYMTABLE(0)
	
	adrMode.a							; current addressing mode (encoded in opcode)
								  		; bit 7    param is array indirect address A.B = 1
										; bit 6    param is array direct address A.1 = 2
										; bit 4-5  param #3
										; bit 2-3  param #2
										; bit 0-1  param #1
	
	RAM_Size.i                          ; size of RAM
	STACK_Size.i                        ; size of STACK
	VRAM_Size.i							; total size of Video-RAM
	
	ADR_Color.i							; address of rgb values
	ADR_COL_Front.i						; current front color
	ADR_COL_Back.i						; current back color
	ADR_CHR_X.i							; current char x (command: CXY)
	ADR_CHR_Y.i							; current char y (command: CXY)
	ADR_CHR_W.i							; current char width (command: CHS)
	ADR_CHR_H.i							; current char height (command: CHS)
	ADR_CHR_MODE.i						; current char drawing mode (command: CHM)
	ADR_Time.i							; address of system time
	ADR_CollisionID.i					; address of collision ID
	ADR_Collision.i						; address of collision info
	ADR_VarPointer.i					; points to current variable position
	ADR_Var.i							; start address of variables
	
	wait.i                              ; delay time for DLY command
	state.i								; current state
	
	exitDepth.i							; depth of "step out"
	callDepth.i							; depth of nested calls    
	
	SCR_Active.i						; active screen
	SCR_Visible.i						; screen hidden or visible?
	SCR_Width.i							; screen height
	SCR_Height.i						; screen width
	SCR_PixelSize.i					
	
	mouseX.i
	mouseY.i
	mouseB.i
	
	programSize.i                       ; size of program
	startTime.i
	time.i
	
	Map sound.i()
EndStructure

Structure PARSER
	tokenIndex.i
	tokenCount.i
	
	code.s
	codeLineCount.i
	
	curAdrMode.i
	curIP.i
	*curLine.CODELINE
	*curOpcode.OPCODE
	*curField.FIELD
	*curDataSect.DATASECT
	*curVar.VARIABLE
	*curToken.TOKEN
	
	paramNr.i
	readState.i
	stringIndex.i
	
	Array token.Token(0)	
	
	Map constant.CONSTANT()
	Map var.VARIABLE()
	
	Map *sub.DATASECT()
	Map *label.DATASECT()
	Map *field.DATASECT()
	
	List dataSect.DATASECT()
	List reference.DATASECT()
	
	List brakeList.ExitList()
	List bracketList.ExitList()
EndStructure

Structure FILE
	editor.i
	path.s
	isNew.i
EndStructure

Global VarAddress.i, VarAddressMode.a, VarIndex.i
Global System.SYSTEM
Global *CPU.CPU
Global Parser.PARSER
Global NewList File.FILE()
Global *CurrentFile.File
Global Dim Opcode.OPCODE(255)
Global NewMap *Opcode.OPCODE()
Global NewMap KeyWord.i()
Global MonitorVisible, Window_X = 100, Window_Y = 100
Global RunState.i
Global SCR_PixelSize = 1
Global Font = LoadFont(#PB_Any, "Consolas", 10)

Declare File_Add(path.s = "", newFile = #False)
Declare File_Open(path.s, newFile = #False)
Declare File_Close(*file.FILE)
Declare File_Activate(*file.File, carretPos = -1, parse = #False)
Declare File_UpdateIni()
Declare System_Init(ramSize, stackSize)
Declare System_RunState(state, updateGadget = #True)
Declare System_CloseScreen(CloseScreen = #False)
Declare System_Update_Editor(*file.FILE, init = #False)
Declare System_Update_Variable(wait = #True, initList = #False)
Declare System_Update_Monitor(ip)
Declare System_Parse(*file.FILE, run = #False)
Declare System_Error(line, message.s, warning = 0)
Declare Parse_NextType(direction, tokenType = -1, value.s = "")
Declare Parse_IsNumber(param.s)
Declare System_VarByIP(ip)
Declare System_LineNrByIP(ip)
Declare Parse_Start(code.s)
Declare Parse(readState = 0, depth = 0)
Declare Event_Window()
Declare Event_Gadget()
Declare Event_Menu()

XIncludeFile("_editor\Scintilla.pb")

Macro MEMSTR(v_)
	"[" + RSet(Str(v_), 6, "0") + "]"
EndMacro

Macro TIMESTR()
	"[" + FormatDate("%hh:%ii:%ss", Date()) + "]"
EndMacro

Macro SETVAL(ip_, v_)
	CompilerIf #CHECK_RAM
		If (ip_) < 0 Or (ip_) >= System\RAM_Size
			System_Error(System_LineNrByIP(System\prevIP), "write outside RAM: " + Str(ip_))
		Else
			*CPU\RAM(ip_) = (v_)
		EndIf
	CompilerElse
		*CPU\RAM(ip_) = (v_)
	CompilerEndIf
EndMacro

Macro GETVAL(ip_, v_)
	CompilerIf #CHECK_RAM
		If (ip_) < 0 Or (ip_) >= System\RAM_Size
			System_Error(System_LineNrByIP(System\prevIP), "read outside RAM: " + Str(System\prevIP))
		Else
			v_ = *CPU\RAM(ip_)
		EndIf
	CompilerElse
		v_ = *CPU\RAM(ip_)
	CompilerEndIf
EndMacro

Macro GETNEXTADRMODE()
	System\adrMode >> 4
EndMacro

Macro GETINDEX()
	If VarAddressMode & #ADR_INDX_DI
		GETVAL(System\nextIP, VarIndex)
		System\nextIP + 1
	ElseIf VarAddressMode & #ADR_INDX_IN
		GETVAL(System\nextIP, VarIndex)
		GETVAL(VarIndex, VarIndex)
		System\nextIP + 1
	Else
		VarIndex = 0
	EndIf
EndMacro

Macro GETVAL_WRITE(ip_, w_)
	VarAddressMode = System\adrMode & $F
	GETINDEX()
	If VarAddressMode & #ADR_POINTER
 		GETVAL(ip_, VarAddress)
		GETVAL(VarAddress, w_)
		w_ + VarIndex
	Else
		GETVAL(ip_, w_)
	EndIf
	System\nextIP + 1
EndMacro

Macro GETVAL_READ(ip_, r_)
	VarAddressMode = System\adrMode & $F
	GETINDEX()
	If VarAddressMode & #ADR_INDIRECT
		GETVAL(ip_, VarAddress)
		If VarAddressMode & #ADR_POINTER
			GETVAL(VarAddress, VarAddress)
		EndIf
		VarAddress + VarIndex
		GETVAL(VarAddress, r_)
	Else
		GETVAL(ip_, r_)
	EndIf
	System\nextIP + 1
EndMacro

Macro PUSH(v_)
	If *CPU\SP >= System\STACK_Size
		System_Error(System_LineNrByIP(*CPU\IP), "stack overflow error")
	Else
		*CPU\STACK(*CPU\SP) = v_
		*CPU\SP + 1
	EndIf
EndMacro

Macro POP(v_)
	*CPU\SP - 1
	If *CPU\SP < 0
		System_Error(System_LineNrByIP(*CPU\IP), "stack underflow error")
	Else
		v_ = *CPU\STACK(*CPU\SP)
	EndIf
EndMacro

Macro MATH(op_,)
	Static r1.d, r2.d
	GETVAL(*CPU\V, r1)
	GETVAL_READ(System\nextIP, r2)
	r1 op_ r2
	SETVAL(*CPU\V, r1)
EndMacro

Macro COMPARE(op_, flagTrue_, flagFalse_)
	Static r1.d, r2.d
	GETVAL(*CPU\V, r1)
	GETVAL_READ(System\nextIP, r2)
	If r1 op_ r2
		System\nextIP + 1
		*CPU\FLAGS = flagTrue_
	Else
		GETVAL(System\nextIP, System\nextIP)
		*CPU\FLAGS = flagFalse_
	EndIf
EndMacro

Macro TokenText(token_)
	Mid(Parser\code, token_\position, token_\length)
EndMacro

;-

Procedure.s FSTR(v.d, asFloat = 0)
	Protected s.s
	
	If v = Int(v)
		If asFloat
			ProcedureReturn Str(v) + ".0"
		EndIf
		ProcedureReturn Str(v)
	EndIf
	s = RTrim(StrF(v, #NbDecimals), "0")
	If Right(s, 1) = "."
		ProcedureReturn s + "0"
	EndIf
	ProcedureReturn s
EndProcedure

Procedure GETVAR(ip)
	Static adr
	GETVAL(ip, adr)
	ProcedureReturn System_VarByIP(ip)
EndProcedure

Procedure MIN(v1, v2)
	If v1 < v2
		ProcedureReturn v1
	EndIf
	ProcedureReturn v2
EndProcedure

Procedure MAX(v1, v2)
	If v1 > v2
		ProcedureReturn v1
	EndIf
	ProcedureReturn v2
EndProcedure

Procedure CLAMP(v, min, max)
	If v < min
		ProcedureReturn min
	ElseIf v > max
		ProcedureReturn max
	EndIf
	ProcedureReturn v
EndProcedure

;-

Procedure IDE_Init()
 	Protected *file.FILE
 	
 	Protected NewMap img()
 	img("new") = LoadImage(#PB_Any, "_ico\file_new.png")
 	img("open") = LoadImage(#PB_Any, "_ico\file_open.png")
 	img("save") = LoadImage(#PB_Any, "_ico\file_save.png")
 	img("close") = LoadImage(#PB_Any, "_ico\file_close.png")
 	img("undo") = LoadImage(#PB_Any, "_ico\undo.png")
 	img("redo") = LoadImage(#PB_Any, "_ico\redo.png")
 	img("compilerun") = LoadImage(#PB_Any, "_ico\compile_run.png")
 	img("compile") = LoadImage(#PB_Any, "_ico\compile.png")
 	img("run") = LoadImage(#PB_Any, "_ico\run.png")
 	img("step") = LoadImage(#PB_Any, "_ico\step.png")
 	img("stepout") = LoadImage(#PB_Any, "_ico\stepout.png")
 	img("monitor") = LoadImage(#PB_Any, "_ico\monitor.png")
 	img("exportc") = LoadImage(#PB_Any, "_ico\exportC.png")
 	img("help") = LoadImage(#PB_Any, "_ico\help.png")
 	
	OpenWindow(#w_Main, 0, 0, 800, 600, #AppTitle$ + " - Control", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_Invisible | #PB_Window_ScreenCentered)
	CreateImageMenu(0, WindowID(#w_Main))
	MenuTitle("File")
	MenuItem(#m_New, "New", ImageID(img("new")))
	MenuItem(#m_Open, "Open...", ImageID(img("open")))
	MenuItem(#m_Save, "Save", ImageID(img("save")))
	MenuItem(#m_SaveAs, "Save As...")
	MenuItem(#m_ExportC, "Export C...", ImageID(img("exportc")))
	MenuItem(#m_Close, "Close", ImageID(img("close")))
	MenuBar()
	MenuItem(#m_Quit, "Quit")
	MenuTitle("Edit")
	MenuItem(#m_Undo, "Undo")
	MenuItem(#m_Redo, "Redo")
	MenuBar()
	MenuItem(#m_Comment, "Comment")
	MenuItem(#m_Uncomment, "Uncomment")
	MenuTitle("Help")
	MenuItem(#m_Help, "Help...", ImageID(img("help")))
	
	CreateToolBar(#t_Main, WindowID(#w_Main), #PB_ToolBar_Small)
	ToolBarImageButton(#m_New, ImageID(img("new"))) : ToolBarToolTip(#t_Main, #m_New, "New")
	ToolBarImageButton(#m_Open, ImageID(img("open"))) : ToolBarToolTip(#t_Main, #m_Open, "Open")
	ToolBarImageButton(#m_Save, ImageID(img("save"))) : ToolBarToolTip(#t_Main, #m_Save, "Save")
	ToolBarSeparator()
	ToolBarImageButton(#m_Undo, ImageID(img("undo"))) : ToolBarToolTip(#t_Main, #m_Undo, "Undo")
	ToolBarImageButton(#m_Redo, ImageID(img("redo"))) : ToolBarToolTip(#t_Main, #m_Redo, "Redo")
	ToolBarSeparator()
	ToolBarImageButton(#m_Close,ImageID(img("close"))) : ToolBarToolTip(#t_Main, #m_Close, "Close")
	ToolBarSeparator()
	ToolBarImageButton(#m_ParseRun, ImageID(img("compilerun"))) : ToolBarToolTip(#t_Main, #m_ParseRun, "Compile/Run")
	ToolBarImageButton(#m_Parse, ImageID(img("compile"))) : ToolBarToolTip(#t_Main, #m_Parse, "Compile")
	ToolBarSeparator()
	ToolBarImageButton(#m_Monitor, ImageID(img("monitor"))) : ToolBarToolTip(#t_Main, #m_Monitor, "Monitor")
	ToolBarSeparator()
	ToolBarImageButton(#m_ExportC, ImageID(img("exportc"))) : ToolBarToolTip(#t_Main, #m_ExportC, "Export C")
	ToolBarSeparator()
	ToolBarImageButton(#m_Help, ImageID(img("help"))) : ToolBarToolTip(#t_Main, #m_Help, "Help")
	
	CreateStatusBar(0, WindowID(#w_Main))
	AddStatusBarField(200)
	AddStatusBarField(100)
	AddStatusBarField(#PB_Ignore)
	
	ContainerGadget(#g_SubContainer, 0,0,0,0, #PB_Container_Double);, #PB_Container_BorderLess)
	ContainerGadget(#g_SearchContainer, 5, 0, 180, 25, #PB_Container_BorderLess)
	StringGadget(#g_SearchText, 0, 0, 100, 25, "", #PB_String_BorderLess)
	ButtonGadget(#g_SearchPrev, 105, 0, 25, 25, "<")
	ButtonGadget(#g_SearchNext, 130, 0, 25, 25, ">")
	ButtonGadget(#g_SearchOptions, 155, 0, 25, 25, "...")
	CloseGadgetList()
	ListViewGadget(#g_Sub, 0, 30, 0, 0)
	CloseGadgetList()
	PanelGadget(#g_FilePanel, 0, MenuHeight() + 5, 800, 600)
	CloseGadgetList()
	
	*file = File_Add("", #True)
	ListIconGadget(#g_Error, 0, 0, 800, 300, "Time", 80, #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_FullRowSelect)
	AddGadgetColumn(#g_Error, 1, "Description", 700)
	SplitterGadget(#g_SplitterEditorH, 0, 0, 800, 600, #g_FilePanel, #g_Error)
	SetGadgetState(#g_SplitterEditorH, 520)
	
	SplitterGadget(#g_SplitterEditorV, 0, 0, 800, 600, #g_SplitterEditorH, #g_SubContainer, #PB_Splitter_Vertical)
	SetGadgetState(#g_SplitterEditorV, 700)
	WindowBounds(#w_Main, 200, 60, #PB_Ignore, #PB_Ignore)
	HideWindow(#w_Main, 0)
	
	CreatePopupMenu(#m_SearchPopup)
	MenuItem(#m_SearchCase, "Case Sensitive")
	MenuItem(#m_SearchWhole, "Whole Words only")
	MenuItem(#m_SearchRegEx, "Regular Expression")
	
	AddKeyboardShortcut(#w_Main, #PB_Shortcut_Control | #PB_Shortcut_S, #m_Save)
	AddKeyboardShortcut(#w_Main, #PB_Shortcut_Control | #PB_Shortcut_O, #m_Open)
	AddKeyboardShortcut(#w_Main, #PB_Shortcut_F1, #m_Help)
	AddKeyboardShortcut(#w_Main, #PB_Shortcut_F3, #m_SearchNext)
	AddKeyboardShortcut(#w_Main, #PB_Shortcut_F5, #m_ParseRun)
	AddKeyboardShortcut(#w_Main, #PB_Shortcut_F6, #m_Parse)
	AddKeyboardShortcut(#w_Main, #PB_Shortcut_Shift | #PB_Shortcut_F3, #m_SearchPrev)
	AddKeyboardShortcut(#w_Main, #PB_Shortcut_Control | #PB_Shortcut_F, #m_SearchSel)	
	AddKeyboardShortcut(#w_Main, #PB_Shortcut_Control | #PB_Shortcut_B, #m_Comment)	
	AddKeyboardShortcut(#w_Main, #PB_Shortcut_Control | #PB_Shortcut_Shift | #PB_Shortcut_B, #m_Uncomment)
	AddKeyboardShortcut(#w_Main, #PB_Shortcut_F2, #m_Hilight)
	
	BindEvent(#PB_Event_Gadget, @Event_Gadget())
	BindEvent(#PB_Event_Menu, @Event_Menu())
	BindEvent(#PB_Event_CloseWindow, @Event_Window())
	BindEvent(#PB_Event_SizeWindow, @Event_Window())
	
	OpenWindow(#w_Screen, 0, 0, 320, 240, #AppTitle$, #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_Invisible)
	AddKeyboardShortcut(#w_Screen, #PB_Shortcut_F5, #m_ParseRun)
	AddKeyboardShortcut(#w_Screen, #PB_Shortcut_F6, #m_Parse)
	StickyWindow(#w_Screen, 1)
	
	OpenWindow(#w_Monitor, 0, 0, 800,600, #AppTitle$ + " - Monitor", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_Invisible)
	CreateToolBar(#t_Monitor, WindowID(#w_Monitor), #PB_ToolBar_Small)
	ToolBarImageButton(#m_ParseRun, ImageID(img("compilerun")))
	ToolBarImageButton(#m_Parse, ImageID(img("compile")))
	ToolBarSeparator()
	ToolBarImageButton(#m_Run, ImageID(img("run")))
	ToolBarImageButton(#m_Step, ImageID(img("step")))	
	ToolBarImageButton(#m_StepOut, ImageID(img("stepout")))
	ToolBarSeparator()
	ToolBarImageButton(#m_ExportC, ImageID(img("exportc")))	
	
	ListIconGadget(#g_Monitor, 0, 0, 0, 0, "Address", 80, #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines)
	AddGadgetColumn(#g_Monitor, 1, "Memory", 100)
	AddGadgetColumn(#g_Monitor, 2, "Code", 1000)
	ListIconGadget(#g_Variables, 0, 0, 0, 0, "Name", 100, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_GridLines)
	AddGadgetColumn(#g_Variables, 1, "Address", 100)
	AddGadgetColumn(#g_Variables, 2, "Value", 500)
	SplitterGadget(#g_SplitterMonitor, 0, 0,800, 600, #g_Monitor, #g_Variables, #PB_Splitter_Vertical)
	SetGadgetState(#g_SplitterMonitor, 500)
	StickyWindow(#w_Monitor, 1)
	AddKeyboardShortcut(#w_Monitor, #PB_Shortcut_F5, #m_ParseRun)
	AddKeyboardShortcut(#w_Monitor, #PB_Shortcut_F6, #m_Parse)
	
	SetGadgetFont(#g_Error, FontID(Font))
	SetGadgetFont(#g_Variables, FontID(Font))
	SetGadgetFont(#g_Monitor, FontID(Font))
	SetGadgetColor(#g_Error, #PB_Gadget_BackColor, 0)
	SetGadgetColor(#g_Error, #PB_Gadget_FrontColor, RGB(255,255,255))
	SetGadgetColor(#g_Sub, #PB_Gadget_BackColor, 0)
	SetGadgetColor(#g_Sub, #PB_Gadget_FrontColor, RGB(255,255,255))
	
	While CountGadgetItems(#g_Monitor) < 1250
		AddGadgetItem(#g_Monitor, -1, "")
	Wend
	
	SetWindowState(#w_Main, #PB_Window_Maximize)
	WindowBounds(#w_Screen, #PB_Ignore, #PB_Ignore, #PB_Ignore, WindowHeight(#w_Main) - ToolBarHeight(#t_Main) - StatusBarHeight(0) - MenuHeight())	
	
	SetActiveWindow(#w_Main)
		
	Protected opcode, procAdr, nParams, size, name.s
	Protected text.s, param.s, paramNr
	
	Restore Opcodes:
	Repeat
		Read opcode
		Read procAdr
		Read nParams
		Read size
		
		If procAdr
			Read.s text
			
			name = StringField(text, 1, " ")
			
			With Opcode(opcode)
				\name = name
				\ID = opcode
				\nParams = nParams
				\size = size
				\procAddress = procAdr
			EndWith
			
			*Opcode(name) = @Opcode(opcode)
		EndIf
	Until procAdr = 0
	
	For opcode = 0 To 255
		If Opcode(opcode)\name = ""
			CopyStructure(@Opcode(#_KIL), @Opcode(opcode), Opcode)
		EndIf
	Next
	
	KeyWord("ELSE") = #T_ELSE
	KeyWord("BRK") = #T_BREAK
	KeyWord("SNL") = #T_SOUND
	
	File_Activate(*file)
EndProcedure

;-

Procedure File_Find(path.s = "")
	ForEach File()
		If path = "" And GetPathPart(File()\path) = ""
			ProcedureReturn File()
		ElseIf UCase(File()\path) = UCase(Trim(path))
			ProcedureReturn File()
		EndIf
	Next
	ProcedureReturn #Null
EndProcedure

Procedure File_Add(path.s = "", newFile = #False)
	Protected *file.FILE
	Protected index, oldGadgetList
	
	*file = File_Find(path)
	If newFile Or *file = #Null
		LastElement(File())
		*file = AddElement(File())
		If *file
			If path = ""
				*file\path = #NewFileName$
				*file\isNew = #True
			Else
				*file\path = path
			EndIf
			
			oldGadgetList = UseGadgetList(WindowID(#w_Main))
			OpenGadgetList(#g_FilePanel)
			index = CountGadgetItems(#g_FilePanel)
			AddGadgetItem(#g_FilePanel, index, GetFilePart(*file\path))
			SetGadgetItemData(#g_FilePanel, index, *file)
			*file\editor = Scintilla_Gadget(#PB_Any, 0, 0, GadgetWidth(#g_FilePanel), GadgetHeight(#g_FilePanel))
			CloseGadgetList()
			UseGadgetList(oldGadgetList)
		EndIf
	EndIf

	ProcedureReturn *file
EndProcedure
	
Procedure File_Activate(*file.File, carretPos = -1, parse = #False)
	Protected index
	
	If *file
		For index = 0  To CountGadgetItems(#g_FilePanel) - 1
			If GetGadgetItemData(#g_FilePanel, index) = *file
				SetGadgetState(#g_FilePanel, index)
				SetActiveGadget(*file\editor)
				
				If carretPos >= 0
					Scintilla_SetCarret(*file\editor, carretPos)
				EndIf
				
				Break
			EndIf
		Next
		
		If parse
			System_Parse(*file)
		EndIf
		SetWindowTitle(#w_Main, #AppTitle$ + " - " + *file\path)
		
		*CurrentFile = *file
	EndIf
	
	ProcedureReturn *CurrentFile
EndProcedure

Procedure File_Open(path.s, newFile = #False)
	Protected carret, option.s, optionName.s, optionVal.s
	Protected file, *file.FILE, *tempFile.FILE
	
	If newFile = #False
		If path = ""
			path = OpenFileRequester("", "", "*.txt|*.txt", 1)
			If path = ""
				ProcedureReturn #Null
			EndIf
		EndIf
		
		*file = File_Find(path)
		If *file
			ProcedureReturn File_Activate(*file)
		EndIf
	EndIf
	
	*file = File_Add(path, newFile)

	If *file
		file = ReadFile(#PB_Any, path, #PB_File_SharedRead)
		If IsFile(file)
			System_Init(System\RAM_Size, System\STACK_Size)
			System_RunState(0)
			*file\isNew = #False
			
			Scintilla_SetText(*file\editor, ReadString(file, #PB_File_IgnoreEOL))
			
			; get IDE-options
			If Eof(file) = 0
				ReadByte(file)
				While Eof(file) = 0
					option = ReadString(file)
					optionName = UCase(StringField(option, 1, "="))
					optionVal = StringField(option, 2, "=")
					Select optionName
						Case "VERSION"
						Case "CARRET" : carret = Val(optionVal)
					EndSelect
				Wend
			EndIf
			CloseFile(file)
			
			*tempFile = File_Find()
			If *tempFile And *tempFile\isNew
				File_Close(*tempFile)
			EndIf
			
			Scintilla_ClearUndo(*file\editor)
			Scintilla_SetSavePoint(*file\editor)
		EndIf

		File_Activate(*file, carret)
	EndIf
	
	ProcedureReturn *file
EndProcedure

Procedure File_Save(*file.FILE, saveAs = #False)
	Protected file, index, *tempFile.FILE
	Protected code.s, path.s
	
	If *file = #Null
		Debug "File_Save: no current file"
		ProcedureReturn #False
	EndIf
	
	code = Scintilla_GetText(*file\editor)
	
	If saveAs Or *file\isNew Or FileSize(*file\path) < 0
		path = SaveFileRequester("", GetPathPart(*file\path), "*.txt|*.txt", 1)
		If path = ""
			ProcedureReturn #PB_MessageRequester_Cancel
		EndIf
		
		If GetExtensionPart(path) = ""
			path + ".txt"
		EndIf

		*tempFile = File_Find(path)
		If *tempFile And MessageRequester(#AppTitle$, path + #NL$ + "a tab with this filename already exists - overwrite?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
			ProcedureReturn #PB_MessageRequester_Cancel
		ElseIf FileSize(path) >= 0
			If MessageRequester(#AppTitle$, path + #NL$ + "The file exists - overwrite?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
				ProcedureReturn #PB_MessageRequester_Cancel
			EndIf
		EndIf
		
		*file\path = path
	EndIf
	
	CopyFile(*file\path, GetPathPart(*file\path) + GetFilePart(*file\path) + ".bak")
	file = CreateFile(#PB_Any, *file\path)
	If IsFile(file) = 0
		MessageRequester(#AppTitle$, "Couldn't create file: " + #NL$ + *file\path, #PB_MessageRequester_Error)
	Else
		WriteString(file, code)
		
		; write IDE-options
		WriteByte(file, 0)
		WriteStringN(file, "")
		WriteStringN(file, "IDE-OPTIONS")
		WriteStringN(file, "VERSION=1.0")
		WriteStringN(file, "CARRET=" + Str(Scintilla_GetCarret(*file\editor)))
		CloseFile(file)
		
		Scintilla_SetSavePoint(*file\editor)
		StatusBarText(0, 1, "Code saved", #PB_StatusBar_Center)		
		SetWindowTitle(#w_Main, #AppTitle$ + " - " + *file\path)
		
		For index = 0 To CountGadgetItems(#g_FilePanel) - 1
			If GetGadgetItemData(#g_FilePanel, index) = *file
				SetGadgetItemText(#g_FilePanel, index, GetFilePart(*file\path))
				Break
			EndIf
		Next
		
		*file\isNew = #False
	EndIf
	
	File_Activate(*file)
	File_UpdateIni()
	
	ProcedureReturn #True
EndProcedure

Procedure File_Close(*file.FILE)
	Protected index
	
	If *file = #Null
		ProcedureReturn 0
	EndIf
	
	File_Activate(*file)
	If Scintilla_IsDirty(*file\editor)
		Select MessageRequester(#AppTitle$, "The file is not saved. Save it now?", #PB_MessageRequester_Warning | #PB_MessageRequester_YesNoCancel)
			Case #PB_MessageRequester_Cancel
				ProcedureReturn #PB_MessageRequester_Cancel
			Case  #PB_MessageRequester_Yes
				If File_Save(*file) = #PB_MessageRequester_Cancel
					ProcedureReturn #PB_MessageRequester_Cancel
				EndIf
		EndSelect
	EndIf
	
	System_Init(System\RAM_Size, System\STACK_Size)
	
	For index = 0 To CountGadgetItems(#g_FilePanel) - 1
		If GetGadgetItemData(#g_FilePanel, index) = *file
			RemoveGadgetItem(#g_FilePanel, index)
			Break
		EndIf
	Next
	
	ForEach File()
		If File() = *CurrentFile
			*CurrentFile = #Null
		EndIf
		If File() = *file
			*file = DeleteElement(File(), 1)
		EndIf
	Next
	If *file = #Null
		*file = File_Add("", #True)
	EndIf 
	File_Activate(*file)

	Scintilla_ClearUndo(*file\editor)
	
	ProcedureReturn *file
EndProcedure

Procedure File_UpdateIni()
	If CreatePreferences("Settings.ini")
		If *CurrentFile And *CurrentFile\isNew = #False
			WritePreferenceString("CURRENTFILE", *CurrentFile\path)
		EndIf
		ForEach File()
			If File()\isNew = #False
				WritePreferenceString("FILE" + ListIndex(File()), File()\path)
			EndIf
		Next
		ClosePreferences()
	EndIf
EndProcedure
;-

Macro SYSTEM_INITRAM(pos_, before_ = 0, after_ = 1)
	adr - (before_)
	System\pos_ = adr
	adr - (after_)
EndMacro

Procedure System_AddConstant(type, key.s, value)
	If AddMapElement(Parser\constant(), key)
		Parser\constant()\type = type
		Parser\constant()\value = value
	EndIf
EndProcedure

Procedure System_Init(ramSize, stackSize)
	Protected adr, i
	
	System_CloseScreen(#True)

	ForEach system\sound()
		If IsSound(System\sound())
			Debug "free sound: " + Str(System\sound())
			FreeSound(System\sound())
		EndIf
	Next
	
	ClearStructure(Parser, PARSER)
	InitializeStructure(Parser, PARSER)
	
	ClearStructure(System, SYSTEM)
	InitializeStructure(System, SYSTEM)
	If *CurrentFile And IsGadget(*CurrentFile\editor)
		Scintilla_ClearError(*CurrentFile\editor)
	EndIf
	
	For i = CountGadgetItems(#g_Monitor) - 1 To 0 Step -1
		SetGadgetItemText(#g_Monitor, i, "" + #LF$ + "" + #LF$ + "")
	Next
	ClearGadgetItems(#g_Sub)
	ClearGadgetItems(#g_Error)
	ClearGadgetItems(#g_Variables)
	
	Dim System\symTable(ramSize)
	Dim System\CPU\RAM(ramSize)
	Dim System\CPU\STACK(stackSize)
	System\RAM_Size = ramSize
	System\STACK_Size = stackSize
	
	*CPU = System\CPU
	
	adr = ramSize
	SYSTEM_INITRAM(ADR_Color, 255, 0)
	SYSTEM_INITRAM(ADR_COL_Front)
	SYSTEM_INITRAM(ADR_COL_Back)
	SYSTEM_INITRAM(ADR_CHR_X)
	SYSTEM_INITRAM(ADR_CHR_Y)
	SYSTEM_INITRAM(ADR_CHR_W)
	SYSTEM_INITRAM(ADR_CHR_H)
	SYSTEM_INITRAM(ADR_CHR_MODE)
	SYSTEM_INITRAM(ADR_Time)
	SYSTEM_INITRAM(ADR_CollisionID)
	SYSTEM_INITRAM(ADR_Collision)
	SYSTEM_INITRAM(ADR_VarPointer)
	SYSTEM_INITRAM(ADR_Var, 0, 0)
	
	SETVAL(System\ADR_CHR_W, 8)
	SETVAL(System\ADR_CHR_H, 8)
	SETVAL(System\ADR_VarPointer, System\ADR_Var)
	
	SETVAL(System\ADR_Color + 00, RGB(  0,   0,   0))
	SETVAL(System\ADR_Color + 01, RGB(255, 255, 255))
	SETVAL(System\ADR_Color + 02, RGB(230,  25,  75))
	SETVAL(System\ADR_Color + 03, RGB(245, 130,  48))
	SETVAL(System\ADR_Color + 04, RGB(255, 225,  25))
	SETVAL(System\ADR_Color + 05, RGB(210, 245,  60))
	SETVAL(System\ADR_Color + 06, RGB( 60, 180,  75))
	SETVAL(System\ADR_Color + 07, RGB( 70, 240, 240))
	SETVAL(System\ADR_Color + 08, RGB(  0, 130, 200))
	SETVAL(System\ADR_Color + 09, RGB(  0,   0, 128))
	SETVAL(System\ADR_Color + 10, RGB(128,   0,   0))
	SETVAL(System\ADR_Color + 11, RGB(145,  30, 180))
	SETVAL(System\ADR_Color + 12, RGB(240,  50, 230))
	SETVAL(System\ADR_Color + 13, RGB(170, 255, 195))
	SETVAL(System\ADR_Color + 14, RGB(255, 250, 200))
	SETVAL(System\ADR_Color + 15, RGB(128, 128, 128))
	
	System_AddConstant(#SYM_ADDRESS, "FRONTCOLOR", @System\ADR_COL_Front)
	System_AddConstant(#SYM_ADDRESS, "BACKCOLOR", @System\ADR_COL_Back)
	System_AddConstant(#SYM_ADDRESS, "CHAR_W", @System\ADR_CHR_W)
	System_AddConstant(#SYM_ADDRESS, "CHAR_H", @System\ADR_CHR_H)
	System_AddConstant(#SYM_ADDRESS, "CHAR_MODE", @System\ADR_CHR_MODE)
	System_AddConstant(#SYM_ADDRESS, "TIME", @System\ADR_Time)
	System_AddConstant(#SYM_ADDRESS, "VARIABLE", @System\ADR_VarPointer)
	System_AddConstant(#SYM_VARIABLE, "RAM", System\RAM_Size)
	System_AddConstant(#SYM_VARIABLE, "STACK", System\STACK_Size)
	System_AddConstant(#SYM_CONSTANT, "VRAM", System\VRAM_Size)
	System_AddConstant(#SYM_CONSTANT, "SCREEN_ACTIVE", System\SCR_Active)
	System_AddConstant(#SYM_CONSTANT, "SCREEN_W", System\SCR_Width)
	System_AddConstant(#SYM_CONSTANT, "SCREEN_H", System\SCR_Height)
	System_AddConstant(#SYM_CONSTANT, "COLOR", System\ADR_Color)
	System_AddConstant(#SYM_CONSTANT, "COLLISIONID", System\ADR_CollisionID)
	System_AddConstant(#SYM_CONSTANT, "COLLISION", System\ADR_Collision)
	System_AddConstant(#SYM_CONSTANT, "KEY_ESCAPE", #PB_Key_Escape)
	System_AddConstant(#SYM_CONSTANT, "KEY_LEFT", #PB_Key_Left)
	System_AddConstant(#SYM_CONSTANT, "KEY_RIGHT", #PB_Key_Right)
	System_AddConstant(#SYM_CONSTANT, "KEY_UP", #PB_Key_Up)
	System_AddConstant(#SYM_CONSTANT, "KEY_DOWN", #PB_Key_Down)
	System_AddConstant(#SYM_CONSTANT, "KEY_A", #PB_Key_Left)
	System_AddConstant(#SYM_CONSTANT, "KEY_S", #PB_Key_Right)
	System_AddConstant(#SYM_CONSTANT, "KEY_W", #PB_Key_Up)
	System_AddConstant(#SYM_CONSTANT, "KEY_Y", #PB_Key_Down)
	System_AddConstant(#SYM_CONSTANT, "KEY_Z", #PB_Key_Down)
	System_AddConstant(#SYM_CONSTANT, "KEY_SPACE", #PB_Key_Space)
	System_AddConstant(#SYM_CONSTANT, "KEY_CONTROL", #PB_Key_LeftControl)
	System_AddConstant(#SYM_CONSTANT, "KEY_RETURN", #PB_Key_Return)
	System_AddConstant(#SYM_CONSTANT, "BLACK", #Black)
	System_AddConstant(#SYM_CONSTANT, "MAGENTA", #Magenta)
	System_AddConstant(#SYM_CONSTANT, "BLUE", #Blue)
	System_AddConstant(#SYM_CONSTANT, "GREEN", #Green)
	System_AddConstant(#SYM_CONSTANT, "CYAN", #Cyan)
	System_AddConstant(#SYM_CONSTANT, "RED", #Red)
	System_AddConstant(#SYM_CONSTANT, "ORANGE", RGB(255,128,0))
	System_AddConstant(#SYM_CONSTANT, "YELLOW", #Yellow)
	System_AddConstant(#SYM_CONSTANT, "GRAY", RGB(128,128,128))
	System_AddConstant(#SYM_CONSTANT, "WHITE", #White)
	System_AddConstant(#SYM_CONSTANT, "EQ", #FLAG_EQUAL)
	System_AddConstant(#SYM_CONSTANT, "NE", #FLAG_NOTEQUAL)
	System_AddConstant(#SYM_CONSTANT, "GR", #FLAG_GREATER)
	System_AddConstant(#SYM_CONSTANT, "LO", #FLAG_LOWER)
	
	System\startTime = ElapsedMilliseconds()
EndProcedure

Procedure System_Start(ramSize, stackSize)
	Protected *file.FILE
	Protected path.s, currentFile.s, index
	
	System_Init(ramSize, stackSize)
	
	If OpenPreferences("Settings.ini")
		currentFile = ReadPreferenceString("CURRENTFILE", "")
		Repeat
			path = ReadPreferenceString("FILE" + Str(index), "")
			If currentFile And path = currentFile
				*file = File_Open(path)
			ElseIf path
				File_Open(path)
			EndIf
			index + 1
		Until path = ""
		ClosePreferences()
	EndIf
	
	If *file = #Null
		*file = File_Add()		
	EndIf
	
	File_Activate(*file)
	
	ProcedureReturn *file
EndProcedure

Procedure System_VarByIP(ip)
	If ip < 0 Or ip >= System\RAM_Size
		ProcedureReturn #Null
	EndIf
	ProcedureReturn System\symTable(ip)\var
EndProcedure

Procedure System_LineNrByIP(ip)
	If ip < 0 Or ip >= System\RAM_Size
		ProcedureReturn 0
	EndIf
	ProcedureReturn System\symTable(ip)\lineNr
EndProcedure

Procedure System_TokenByIP(ip)
	If ip < 0 Or ip >= System\RAM_Size
		ProcedureReturn 0
	EndIf
	ProcedureReturn System\symTable(ip)\token
EndProcedure

Procedure System_CloseScreen(CloseScreen = #False)
	If System\SCR_Active
		If CloseScreen
			System\SCR_Active = 0
			CloseScreen()
		EndIf
		System\SCR_Visible = #False
		HideWindow(#w_Screen, 1)
	EndIf
EndProcedure

Procedure System_RunState(state, updateGadget = #True)
	Protected previousState
	
	If RunState <> state
		previousState = RunState
		RunState = state
		
		If System\state & (#STATE_RUN | #STATE_ERROR | #STATE_ERROR)
			RunState & ~#STATE_RUN
		EndIf
		
		If RunState & #STATE_RUN            
			SetToolBarButtonState(#t_Main, #m_Run, 1)
			StatusBarText(0, 1, "Running", #PB_StatusBar_Center)
			
			If System\SCR_Active And System\SCR_Visible = #False
				System\SCR_Visible = #True
				HideWindow(#w_Screen, 0)
			EndIf
			
			If previousState & #STATE_RUN = 0
				AddGadgetItem(#g_Error, -1, TIMESTR() + Chr(10) + "program started") 
			EndIf
		Else
			SetToolBarButtonState(#t_Main, #m_Run, 0)
			StatusBarText(0, 1, "Stopped", #PB_StatusBar_Center)
			If System\SCR_Visible = #False
				System\SCR_Visible = #False
				HideWindow(#w_Screen, 1)
			EndIf
			If previousState & #STATE_RUN
				AddGadgetItem(#g_Error, -1, TIMESTR() + Chr(10) + "program stopped")
			EndIf
			If SoundSystemOK
				StopSound(#PB_All)
			EndIf
		EndIf
		
		If RunState & #STATE_STEP
			SetToolBarButtonState(#t_Main, #m_Step, 1)
			
			If updateGadget
				System_Update_Variable(#False)
				If MonitorVisible
					System_Update_Monitor(0)
				EndIf
			EndIf

			System\wait = -1
			
			If previousState & #STATE_STEP = 0
				AddGadgetItem(#g_Error, -1, TIMESTR() + Chr(10) + "program paused")
			EndIf
		Else
			SetToolBarButtonState(#t_Main, #m_Step, 0)
			
			If previousState & #STATE_STEP
				AddGadgetItem(#g_Error, -1, TIMESTR() + Chr(10) + "program continued")
			EndIf
		EndIf
		
		SetGadgetState(#g_Error, CountGadgetItems(#g_Error) - 1)
	EndIf
EndProcedure

Procedure System_Update_Monitor(ip)
	Protected curIP = *CPU\IP, varIP
	Protected paramNr, adr, op.a, opIP, index, isData, lineNr = -1
	Protected *opcode.OPCODE, *var.VARIABLE, *sym.SYMTABLE
	Protected address.s, memory.s, code.s, varIndex.s
	Protected lineCount = CountGadgetItems(#g_Monitor) - 1
	
	For index = 0 To lineCount
		SetGadgetItemText(#g_Monitor, index, "" + #LF$ + "" + #LF$ + "")
		SetGadgetItemData(#g_Monitor, index, 0)
		SetGadgetItemColor(#g_Monitor, index, #PB_Gadget_BackColor, #PB_Default)
	Next
	
	index = 0
	Repeat
		adr = *CPU\RAM(*CPU\IP)
		*sym = @System\symTable(*CPU\IP)
		
		address = MEMSTR(*CPU\IP)
		
		Select *sym\type
			Case #SYM_SUB
				SetGadgetItemText(#g_Monitor, index, TokenText(*sym\token))
				SetGadgetItemData(#g_Monitor, index, *sym\lineNr)
				SetGadgetItemColor(#g_Monitor, index, #PB_Gadget_BackColor, RGB(250, 235, 235), 0)
				index + 1
			Case #SYM_FIELD
				SetGadgetItemText(#g_Monitor, index, TokenText(*sym\token))
				SetGadgetItemData(#g_Monitor, index, *sym\lineNr)
				SetGadgetItemColor(#g_Monitor, index, #PB_Gadget_BackColor, RGB(250, 250, 235), 0)
				index + 1
			Case #SYM_LABEL
				SetGadgetItemText(#g_Monitor, index, TokenText(*sym\token))
				SetGadgetItemData(#g_Monitor, index, *sym\lineNr)
				index + 1
		EndSelect
		
		memory = RSet(FSTR(*CPU\RAM(*CPU\IP)), 3, "0") + " "
		
		isData = #False
		ForEach Parser\dataSect()
			If Parser\dataSect()\type = #SYM_FIELD
				If *CPU\IP >= Parser\dataSect()\startAdr And *CPU\IP < Parser\dataSect()\endAdr
					isData = #True
					Break
				EndIf
			EndIf
		Next
		
		op = adr & $FF
		opIP = *CPU\IP
		*opcode = @Opcode(op)
		System\adrMode = (adr >> 8) & $FF
		*CPU\IP + 1
		
		code = *opcode\name + " "
				
		For paramNr = 0 To *opcode\nParams - 1
			memory + RSet(FSTR(*CPU\RAM(*CPU\IP)), 3, "0") + " "
			VarIndex = ""
			
			adr = *CPU\RAM(*CPU\IP)
			If System\adrMode & #ADR_INDX_DI
				VarIndex = Str(adr)
				*CPU\IP + 1
			ElseIf System\adrMode & #ADR_INDX_IN
				*var = System_VarByIP(adr)
				If *var
					VarIndex = *var\name
				EndIf
				*CPU\IP + 1
			EndIf
			
			If System\adrMode & #ADR_POINTER
				code + "["
			EndIf
			
			*sym = @System\symTable(*CPU\IP)
			If *sym
				If *sym\token
					code + TokenText(*sym\token)
				Else
					code + Str(*CPU\RAM(*CPU\IP))
				EndIf
			Else
				Debug "symboltable error"
 			EndIf
			*CPU\IP + 1
			
			If VarIndex
				code + " + " + VarIndex
			EndIf
			
			If System\adrMode & #ADR_POINTER: code + "]" : EndIf
			code + " "

			GETNEXTADRMODE()
		Next
		
		Select op
			Case #_IFL, #_IGR, #_ILO, #_IGE, #_ILE, #_IEQ, #_INE, #_TO
				memory + RSet(FSTR(*CPU\RAM(*CPU\IP)), 3, "0") + " "
				code + "{exit:" + Str(*CPU\RAM(*CPU\IP)) + "} "
				*CPU\IP + 1
		EndSelect
		
		SetGadgetItemText(#g_Monitor, index, address + Chr(10) + memory + Chr(10) + code)
		SetGadgetItemData(#g_Monitor, index, System_LineNrByIP(opIP))
		SetGadgetItemColor(#g_Monitor, index, #PB_Gadget_BackColor, RGB(235, 235, 250), 0)
		SetGadgetItemColor(#g_Monitor, index, #PB_Gadget_BackColor, RGB(235, 250, 235), 1)
		If isData
			SetGadgetItemColor(#g_Monitor, index, #PB_Gadget_BackColor, RGB(250, 250, 235), 2)	
		EndIf
		If *CPU\IP = curIP
			SetGadgetItemColor(#g_Monitor, index, #PB_Gadget_BackColor, RGB(235,235,235), 2)
		EndIf
		
		If lineNr = -1 : lineNr = index : EndIf
		index + 1
	Until *CPU\IP >= System\programSize Or index >= lineCount
	
	If lineNr <> -1
		SetGadgetState(#g_Monitor, lineNr)
	EndIf
	
	*CPU\IP = curIP
EndProcedure

Procedure System_Update_Variable(wait = #True, init = #False)
	Static updateTime
	Protected lineNr, value.d, valueChanged
	Protected *var.VARIABLE, val.d
	
	If wait
		If System\time < updateTime
			ProcedureReturn
		EndIf
		updateTime = System\time + 500
	EndIf
	
	If init
		NewList var.VARIABLE()
		ForEach Parser\var()
			AddElement(var())
			var()\adr = Parser\var()
			var()\name = Parser\var()\name
		Next
		SortStructuredList(var(), #PB_Sort_Ascending, OffsetOf(VARIABLE\name), #PB_String)
		
		ClearGadgetItems(#g_Variables)
		
		AddGadgetItem(#g_Variables, 0, "Current Variable")
		SetGadgetItemColor(#g_Variables, 0, #PB_Gadget_BackColor, RGB(235, 250, 235))
		*var = System_VarByIP(VarAddress)
		If *var
			SetGadgetItemText(#g_Variables, 0, *var\name + ":" + Str(VarIndex), 1)
			SetGadgetItemText(#g_Variables, 0, FSTR(*CPU\RAM(VarAddress)), 2)
		EndIf
		lineNr = 1
		
		ForEach var()
			*var = var()\adr
			With *var
				\infoLineNr = lineNr
				
				AddGadgetItem(#g_Variables, lineNr, \name)
				
				SetGadgetItemText(#g_Variables, lineNr, MEMSTR(\adr), 1)
				SetGadgetItemText(#g_Variables, lineNr, FSTR(*CPU\RAM(\adr)), 2)
				SetGadgetItemData(#g_Variables, lineNr, *var)
				
				lineNr + 1
			EndWith
		Next
		
		ProcedureReturn #True
		
	Else
		
		*var = System_VarByIP(VarAddress)
		If *var
			GETVAL(VarAddress, val)
			; 			If System\adrMode & $F & (#ADR_INDX_DI |#ADR_INDX_IN)
			SetGadgetItemText(#g_Variables, 0, *var\name + ":" + Str(VarIndex), 1)
			; 			Else
			; 				SetGadgetItemText(#g_Variables, 0, Parser\varByIP()\name, 1)
			; 			EndIf
			SetGadgetItemText(#g_Variables, 0, FSTR(val), 2)
		EndIf
		
		ForEach Parser\var()
			With Parser\var()
				value = *CPU\RAM(\adr)
				If \prevValue <> value Or \infoLineNr = 0
					\prevValue = value
					SetGadgetItemText(#g_Variables, \infoLineNr, FSTR(value), 2)
					valueChanged = #True
				EndIf
			EndWith    
		Next
		
	EndIf
	
	ProcedureReturn valueChanged
EndProcedure

Procedure System_Update_Label()
	Protected index
	Protected NewList subList.DATASECT()
	ForEach Parser\datasect()
		If Parser\datasect()\type = #SYM_SUB
			If AddElement(subList())
				CopyStructure(Parser\datasect(), subList(), DATASECT)
			EndIf
		EndIf
	Next
	;SortStructuredList(subList(), #PB_Sort_Ascending, OffsetOf(LABEL\name), #PB_String)
	SortStructuredList(subList(), #PB_Sort_Ascending, OffsetOf(DATASECT\lineNr), TypeOf(DATASECT\lineNr))
	
	ClearGadgetItems(#g_Sub)
	ForEach subList()
		AddGadgetItem(#g_Sub, index, RemoveString(TokenText(subList()\token), ":"))
		SetGadgetItemData(#g_Sub, index, subList()\lineNr)
		index + 1
	Next
EndProcedure

Procedure System_GotoLine(lineNr)
	If *CurrentFile And IsGadget(*CurrentFile\editor)
		Scintilla_SetCursorPosition(*CurrentFile\editor, lineNr, 0)
	EndIf
EndProcedure
	
Procedure System_Variable_Change(*var.VARIABLE)
	If *var
		Protected value.s
		value.s = InputRequester(#AppTitle$, "Variable: " + *var\name, FSTR(*CPU\RAM(*var\adr)))
		If value <> "" And Parse_IsNumber(value)
			*CPU\RAM(*var\adr) = ValD(value)
			
			System_Update_Variable(#False)
			System_Update_Monitor(0)
		EndIf
	EndIf
EndProcedure

Procedure System_Parse(*file.FILE, run = #False)
	Protected result = #False
	If *file
		ClearStructure(Parser, PARSER)
		InitializeStructure(Parser, PARSER)
		
		result = Parse_Start(Scintilla_GetText(*file\editor))
		
		If run
			System_RunState(RunState | #STATE_RUN)
		EndIf
	EndIf
	ProcedureReturn result
EndProcedure

Procedure System_Error(line, message.s, warning = 0)
	Protected index = CountGadgetItems(#g_Error)
	Protected errLine = line
	
	If (System\state & #STATE_ERROR = 0)
		If line >= 0
			errLine = Max(line - 1 , 0)
			Protected text.s = "Line " + Str(line + 1) + ": " + message
			AddGadgetItem(#g_Error, index, TIMESTR() + Chr(10) + text) 
			If *CurrentFile
				If warning = 0
					Scintilla_SetErrorLine(*CurrentFile\editor, errLine, text)
				EndIf
				Scintilla_SetCursorPosition(*CurrentFile\editor, errLine, 0)
				Scintilla_Scroll(*CurrentFile\editor, -2)
				SetActiveGadget(*CurrentFile\editor)
			EndIf
		Else
			AddGadgetItem(#g_Error, index, TIMESTR() + Chr(10) + message) 
		EndIf
	EndIf
	
	SetGadgetItemData(#g_Error, index, line)
	SetGadgetState(#g_Error, index)
	
	If warning
		SetGadgetItemColor(#g_Error, index, #PB_Gadget_BackColor, RGB(255,0,0))
	Else
		System\state | #STATE_ERROR
		RunState | #STATE_END
	EndIf
EndProcedure

Procedure System_SearchFlags()
	SCI_SEARCHFLAGS = #SCFIND_NONE
	If GetMenuItemState(#m_SearchPopup, #m_SearchCase)
		SCI_SEARCHFLAGS  | #SCFIND_MATCHCASE
	EndIf
	If GetMenuItemState(#m_SearchPopup, #m_SearchWhole)
		SCI_SEARCHFLAGS  | #SCFIND_WHOLEWORD
	EndIf
	If GetMenuItemState(#m_SearchPopup, #m_SearchRegEx)
		SCI_SEARCHFLAGS  | #SCFIND_REGEXP
	EndIf
EndProcedure

Procedure System_ToC(path.s)
	Protected curIP = *CPU\IP
	Protected tabPos, tab.s, tabSize = 4
	Protected paramNr, r.d, i, w, mem, op.a, index, isData
	Protected *opcode.OPCODE, *var.VARIABLE, *token.TOKEN
	Protected datIP, datUni, datVal.f, curVar.s, stepVar.s, stepCount.s
	Protected file, header.s
	
	Structure CPARAM
		*sym.SYMTABLE
		prefix.s
		name.s
		type.s
		index.s
		indexType.i
	EndStructure
	
	Dim param.CPARAM(2)
	Protected *param.CPARAM
	
	NewMap loopJmp()
	NewList ifJmp()
	NewList sect.DATASECT()
		
	If path = ""
		ProcedureReturn #False
	ElseIf System_Parse(*CurrentFile) = #False
		MessageRequester(#AppTitle$, "Parser Error", #PB_MessageRequester_Error)
		ProcedureReturn #False
	ElseIf GetFilePart(path) = ""
		ProcedureReturn #False
	ElseIf UCase(GetExtensionPart(path)) <> "C"
		path = GetFilePart(path, #PB_FileSystem_NoExtension) + ".c"
	EndIf
	
	header = "/*" + #NL$
	header + "sho.co c-export of file '" + *CurrentFile\path + "'" + #NL$
	header + "date: " + FormatDate("%mm/%dd/%yyyy - %hh:%ii:%ss", Date()) + #NL$
	header + "*/" + #NL$
	
	file = ReadFile(#PB_Any, "_compiler\Header.c")
	If IsFile(file)
		header + ReadString(file, #PB_File_IgnoreEOL)
		CloseFile(File)
	EndIf
	file = CreateFile(#PB_Any, path)
	If IsFile(file) = 0
		MessageRequester(#AppTitle$, "Couldn't create file", #PB_MessageRequester_Error)
		ProcedureReturn #False
	EndIf
	
	WriteStringN(file, header)
	WriteStringN(file, "")
	
	If ListSize(Parser\dataSect()) > 0
		WriteStringN(file, "// GLOBAL ARRAYS:")
		
		ForEach Parser\dataSect()
			With Parser\dataSect()
				If \type = #SYM_FIELD
					datUni = #True
					datVal = *CPU\RAM(\startAdr)
					
					For datIP = \startAdr + 1 To \endAdr - 1
						If *CPU\RAM(datIP) <> datVal
							datUni = #False
							Break
						EndIf
					Next
					
					curVar = TokenText(\token)
					If FindString("$:@!~#", Left(curVar, 1))
						curVar = Mid(curVar, 2)
					EndIf
					
					If datUni
						WriteStringN(file, "float a_" + curVar + "[" + Str(\endAdr - \startAdr) + "] = {" + FSTR(datVal, 1) + "};")
					Else
						WriteString(file, "float a_" + curVar + "[" + Str(\endAdr - \startAdr) + "] = {")
						For datIP = \startAdr To \endAdr - 1
							WriteString(file, StrF(*CPU\RAM(datIP)))
							If datIP < \endAdr - 1 : WriteString(file, ",") : EndIf
						Next
						WriteStringN(file, "};")
					EndIf
				EndIf
			EndWith
		Next
		WriteStringN(file, "")
	EndIf	
	
	If MapSize(Parser\var()) > 0
		WriteStringN(file, "// GLOBAL VARIABLES:")
		ForEach Parser\var()
			WriteStringN(file, "float v_" + Parser\var()\name + " = 0;")
		Next
		WriteStringN(file, "")
	EndIf
	
	; 1.) first get subs...
	ForEach Parser\dataSect()
		If Parser\dataSect()\type = #SYM_SUB And AddElement(sect())
			CopyStructure(Parser\dataSect(), sect(), DATASECT)
		EndIf
	Next
	; 2.) get main body
	If AddElement(sect())
		sect()\type = 0
		sect()\startAdr = 0
		sect()\endAdr = System\programSize
	EndIf
	
	curVar = ""
	
	ForEach sect()
; 		Debug sect()\type
; 		Debug sect()\startAdr
; 		Debug sect()\endAdr
; 		Debug "---"
		ClearList(ifJmp())
		Select sect()\type
			Case #SYM_SUB
				WriteStringN(file, "void " + TokenText(sect()\token) + "() {")
				tabPos + 1 : tab = Space(tabPos * tabSize)
			Case 0
				WriteStringN(file, "")
				
				WriteStringN(file, "void MainLoop() {")
				tabPos + 1: tab = Space(tabPos * tabSize)
		EndSelect
		
		*CPU\IP = sect()\startAdr
		Repeat
			
			; skip subs and fields in main procedure
			ForEach Parser\dataSect()
				With Parser\dataSect()
					Select \type
						Case #SYM_SUB, #SYM_FIELD
							If sect()\type = 0 Or \type = #SYM_FIELD
								If *CPU\IP >= \startAdr And *CPU\IP < \endAdr
									*CPU\IP = \endAdr
								EndIf
							EndIf
					EndSelect
				EndWith
			Next
			If *CPU\IP >= sect()\endAdr
				Break
			EndIf
			
			mem = *CPU\RAM(*CPU\IP)
			*token = System_TokenByIP(*CPU\IP)
			
			If *token And System\symTable(*CPU\IP) = #SYM_LABEL
				WriteStringN(file, "    " + *token\text)
			EndIf
			
			op = mem & $FF
			*opcode = @Opcode(op)
			System\adrMode = (mem >> 8) & $FF
			*CPU\IP + 1
			
			For i = 0 To 1
				param(i)\sym = #Null
				param(i)\name = ""
				param(i)\index = ""
				param(i)\type = ""
				param(i)\prefix = ""
			Next
			
			For paramNr = 0 To *opcode\nParams - 1
				*param = @param(paramNr)
				
				If System\adrMode & (#ADR_INDX_DI | #ADR_INDX_IN)
					If System\adrMode & #ADR_INDIRECT
						*param\indexType = #ADR_INDIRECT
						mem = *CPU\RAM(*CPU\IP)
						*var = System_VarByIP(mem)
						If *var
							*param\index = "v_" + *var\name
						Else
							*param\index = "?"
						EndIf
					Else
						*param\index = StrF(*CPU\RAM(*CPU\IP))
					EndIf
					
					If FindString("$:@!~#", Left(*param\index, 1))
						*param\index = Mid(*param\index, 2)
					EndIf					
					*CPU\IP + 1
				EndIf
				
				*param\sym = @System\symTable(*CPU\IP)
				If *param\sym
					If *param\sym\token
						*param\name = TokenText(*param\sym\token)
					Else
						*param\name = Str(*CPU\RAM(*CPU\IP))
					EndIf
					If FindString("$:@!~#", Left(*param\name, 1))
						*param\name = Mid(*param\name, 2)
					EndIf
					
					*param\type = "float"
					
					Select *param\sym\type
						Case #SYM_FIELD :  : *param\preFix = "a_"
						Case #SYM_VARIABLE : *param\prefix = "v_"
						Case #SYM_LABEL : *param\prefix = "l_"
						Case #SYM_INT : *param\type = "int"
						Default
; 							Debug "??? " + Str(*param\sym\type)
					EndSelect
				Else
					Debug "symboltable error"
				EndIf
				
				*param\name = *param\prefix + *param\name
; 				If System\adrMode & #ADR_POINTER
; 					*param\name = "*" + *param\name
; 				EndIf
				
				*CPU\IP + 1
				System\adrMode >> 4
			Next
						
			Protected isIF = 0
			Select op
				Case #_SET
					;curVar = param(0)\name
					WriteStringN(file, tab + "curVar = &" + param(0)\name + ";")
				Case #_MOV
					Select param(0)\type
						Case "int"
							WriteStringN(file, tab + "curInt = ("   + param(0)\type + ")" + param(0)\name + ";")	
							WriteStringN(file, tab + "curVar = (" + param(0)\type + ")curInt;")
						Case "float"
							WriteStringN(file, tab + "curFloat = (" + param(0)\type + ")" + param(0)\name + ";")	
							WriteStringN(file, tab + "curVar = (" + param(0)\type + ")curFloat;")
					EndSelect
				Case #_WRT
					WriteStringN(file, tab + "*" + curVar + " = " + param(0)\name + ";")
					WriteStringN(file, tab + curVar + "++;")
				Case #_ADD
					WriteStringN(file, tab + curVar + " += " + param(0)\name + ";")
				Case #_SUB
					WriteStringN(file, tab + curVar + " -= " + param(0)\name + ";")
				Case #_MUL
					WriteStringN(file, tab + curVar + " *= " + param(0)\name + ";")
				Case #_DIV
					WriteStringN(file, tab + curVar + " /= " + param(0)\name + ";")
				Case #_POW
					WriteStringN(file, tab + curVar + " = pow(" + curVar + "," + param(0)\name + ");")
				Case #_MOD
					WriteStringN(file, tab + curVar + " = fmod(" + curVar + "," + param(0)\name + ");")
				Case #_NEG
					WriteStringN(file, tab + curVar + " = -" + curVar + ";")
				Case #_INT
					WriteStringN(file, tab + curVar + " = (int)" + curVar + ";")
					;Case #_NTH
				Case #_SGN
					WriteStringN(file, tab + curVar + " = (0 < " + param(0)\name + ") - (" + param(0)\name + " < 0);")
				Case #_CIL
					WriteStringN(file, tab + curVar + " = ceil(" + param(0)\name + ");")
				Case #_ABS
					WriteStringN(file, tab + curVar + " = abs(" + param(0)\name + ");")
				Case #_MIN
					WriteStringN(file, tab + "FLAGS = (curVar < " + param(0)\name + ");")
					WriteStringN(file, tab + curVar + " = min(" + curVar + "," + param(0)\name + ");")
				Case #_MAX
					WriteStringN(file, tab + "FLAGS = (curVar > " + param(0)\name + ");")
					WriteStringN(file, tab + curVar + " = max(" + curVar + "," + param(0)\name + ");")
				Case #_RND
					WriteStringN(file, tab + curVar + " = (double)rand() / (double)RAND_MAX;")
				Case #_IFL ; ifl adr exit
					WriteStringN(file, tab + "if (FLAGS == (int)" + param(0)\name + ") {")
					isIf = 1
				Case #_IGR
					WriteStringN(file, tab + "if (" + curVar + " > " + param(0)\name + ") {")
					isIf = 1
				Case #_ILO
					WriteStringN(file, tab + "if (" + curVar + " < " + param(0)\name + ") {")
					isIf = 1
				Case #_IEQ
					WriteStringN(file, tab + "if (" + curVar + " == " + param(0)\name + ") {")
					isIf = 1
				Case #_IGE
					WriteStringN(file, tab + "if (" + curVar + " >= " + param(0)\name + ") {")
					isIf = 1
				Case #_ILE
					WriteStringN(file, tab + "if (" + curVar + " <= " + param(0)\name + ") {")
					isIf = 1
				Case #_INE
					WriteStringN(file, tab + "if (" + curVar + " != " + param(0)\name + ") {")
					isIf = 1
				Case #_JMF ; jmf val exit
					WriteStringN(file, tab + "if (FLAGS == (int)" + param(0)\name + "){goto " + param(1)\name + ";}")
					If FindMapElement(loopJmp(), param(0)\name)
						tabPos = MAX(tabPos - 1, 0) : tab = Space(tabPos * tabSize)
						WriteStringN(file, tab + "}")
					EndIf
				Case #_JMP ; jmp adr
					If FindMapElement(loopJmp(), param(0)\name)
						tabPos = MAX(tabPos - 1, 0) : tab = Space(tabPos * tabSize)
						WriteStringN(file, tab + "}")
					Else
						WriteStringN(file, tab + "goto " + param(0)\name + ";")
					EndIf
				Case #_STP
					stepVar = curVar
					stepCount = param(0)\name
					WriteStringN(file, tab + stepVar + " -= " + param(0)\name + ";")
				Case #_TO ; to adr exit
					WriteStringN(file, tab + "for (;" + stepVar + " < " + param(0)\name + "; " + stepVar + " += " + stepCount + ") {")
					tabPos + 1 : tab = Space(tabPos * tabSize)
					loopJmp(Str(*CPU\IP - 2)) = 1
				Case #_CAL
					WriteStringN(file, tab + param(0)\name + "();")
				Case #_RET
					WriteStringN(file, tab + "return;")
				Case #_PSH
					WriteStringN(file, tab + "push(" + param(0)\name + ");")
				Case #_POP
					WriteStringN(file, tab + param(0)\name + " = pop();")
				Case #_PSF
					WriteStringN(file, tab + "push(FLAGS);")
				Case #_POF
					WriteStringN(file, tab + "FLAGS = pop();")
				Case #_SCR
					WriteStringN(file, tab + "OpenScreen(" + param(0)\name + "," + param(1)\name + ");")
				Case #_CLS
					WriteStringN(file, tab + "ClearScreen(" + param(0)\name + ");")
				Case #_CLF
					WriteStringN(file, tab + "colFront = " + param(0)\name + ";")
				Case #_CLB
					WriteStringN(file, tab + "colBack = " + param(0)\name + ";")
				Case #_CHS
					WriteStringN(file, tab + "charW = " + param(0)\name + ";")
					WriteStringN(file, tab + "charH = " + param(1)\name + ";")
				Case #_CXY
					WriteStringN(file, tab + "charX = " + param(0)\name + ";")
					WriteStringN(file, tab + "charY = " + param(1)\name + ";")
				Case #_CHM
					WriteStringN(file, tab + "charMode = " + param(0)\name + ";")
				Case #_CHR
					WriteStringN(file, tab + "DrawChar();")
				Case #_PLT
					WriteStringN(file, tab + "Plot(" + param(0)\name + "," + param(1)\name + ", colFront);")
				Case #_DRW
					WriteStringN(file, tab + "DrawScreen();")
				Case #_DLY
					WriteStringN(file, tab + "Sleep(" + param(0)\name + ");")
				Case #_INP
					WriteStringN(file, tab + "key = GetKey();")
				Case #_KEY
					WriteStringN(file, tab + "FLAGS = key;")
				Case #_DBG
					WriteStringN(file, tab + "printf(" + #DOUBLEQUOTE$ + "%f\n" + #DOUBLEQUOTE$ + ", " + param(0)\name + ");")
				Case #_END
					WriteStringN(file, tab + "return;")
				Default
					WriteStringN(file, tab + "// Opcode: " + *Opcode\name + " " + param(0)\name + "  " + param(1)\name)
			EndSelect
			
			If isIf
				tabPos + 1 : tab = Space(tabPos * tabSize)
				LastElement(ifJmp())
				If AddElement(ifJmp())
					ifJmp() = *CPU\RAM(*CPU\IP)
				EndIf
			EndIf
			
			While LastElement(ifJmp()) And *CPU\IP >= ifJmp()
				tabPos = MAX(tabPos - 1, 0) : tab = Space(tabPos * tabSize)
				WriteStringN(file, tab + "}")
				DeleteElement(ifJmp())
			Wend
			
			Select op
				Case #_IFL, #_IGR, #_ILO, #_IGE, #_ILE, #_IEQ, #_INE, #_TO
					*CPU\IP + 1
			EndSelect
		Until *CPU\IP >= sect()\endAdr
		
		tabPos = MAX(tabPos - 1, 0) : tab = Space(tabPos * tabSize)
		WriteStringN(file, "}")
		
		Select sect()\type
			Case 0
				WriteStringN(file, "")
				WriteStringN(file, "int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {")
				WriteStringN(file, "    initialize();")				
				WriteStringN(file, "    MainLoop();")
				WriteStringN(file, "    cleanUp();")
				WriteStringN(file, "}")
		EndSelect

	Next sect()
	
	CloseFile(file)
	*CPU\IP = curIP
	
	ProcedureReturn #True
EndProcedure

Procedure Help_Callback(gadget, url.s)
	If GetFilePart(url) <> "help.html"
		ProcedureReturn #False
	EndIf
	ProcedureReturn #True
EndProcedure

Procedure System_Help()
	Protected file
	
	If IsWindow(#w_Help)
		HideWindow(#w_Help, 0)
	Else
		If OpenWindow(#w_Help, 0, 0, 800, 600, #AppTitle$ + " - Help", #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_SizeGadget)
			WebGadget(#g_Help, 5, 5, 790, 590, #PB_Compiler_FilePath + "_help\help.html")
			SetGadgetAttribute(#g_Help, #PB_Web_NavigationCallback, @Help_Callback())
			SetGadgetAttribute(#g_Help, #PB_Web_BlockPopupMenu, 1)
			SetGadgetAttribute(#g_Help, #PB_Web_BlockPopups, 1)
		EndIf
	EndIf
EndProcedure

Procedure System_Quit()
	System_RunState(0)
	File_UpdateIni()
	
	ForEach File()
		If File_Close(File()) = #PB_MessageRequester_Cancel
			ProcedureReturn #False
		EndIf
	Next
	
	System\state | #STATE_QUIT
EndProcedure

;-

Procedure OP_SET()
	GETVAL_WRITE(System\nextIP, *CPU\V)
EndProcedure

Procedure OP_MOV()
	Static r.d
	GETVAL_READ(System\nextIP, r)
	SETVAL(*CPU\V, r)
EndProcedure

Procedure OP_WRT()
	Static r1, r2.d
	GETVAL(*CPU\V, r1)
	GETVAL_READ(System\nextIP, r2)
	SETVAL(r1, r2)
	SETVAL(*CPU\V, r1 + 1)
EndProcedure

Procedure OP_ADD()
	MATH(+)
EndProcedure

Procedure OP_SUB()
	MATH(-)
EndProcedure

Procedure OP_MUL()
	MATH(*)
EndProcedure

Procedure OP_POW()
	Static r1.d, r2.d
	GETVAL(*CPU\V, r1)
	GETVAL_READ(System\nextIP, r2)
	SETVAL(*CPU\V, Pow(r1, r2))
EndProcedure

Procedure OP_DIV()
	Static r1.d, r2.d
	GETVAL(*CPU\V, r1)
	GETVAL_READ(System\nextIP, r2)
	If r2 = 0
		System_Error(System_LineNrByIP(*CPU\IP), "Division by zero")
	Else
		r1 / r2
		SETVAL(*CPU\V, r1)	
	EndIf
EndProcedure

Procedure OP_MOD()
	Static r1, r2
	GETVAL(*CPU\V, r1)
	GETVAL_READ(System\nextIP, r2)
	r1 % r2
	SETVAL(*CPU\V, r1)
EndProcedure

Procedure OP_NEG()
	Static r.d	
	GETVAL(*CPU\V, r)
	SETVAL(*CPU\V, -r)
EndProcedure

Procedure OP_INT()
	Static r
	GETVAL(*CPU\V, r)
	SETVAL(*CPU\V, r)
EndProcedure

Procedure OP_NTH()
	Static r1, r2, s.s
	GETVAL(*CPU\V, r1)
	GETVAL_READ(System\nextIP, r2)
	s = Str(r1)
	r1 = Len(s) - r2
	If r1 < 1
		SETVAL(*CPU\V, 0)
	Else
		r1 = Val(Mid(s, r1, 1))
		SETVAL(*CPU\V, r1)
	EndIf
EndProcedure

Procedure OP_SGN()
	Static r
	GETVAL(*CPU\V, r)
	SETVAL(*CPU\V, Sign(r))
EndProcedure

Procedure OP_CIL()
	Static r.d
	GETVAL(*CPU\V, r)
	SETVAL(*CPU\V, Round(r, #PB_Round_Up))
EndProcedure

Procedure OP_ABS()
	Static r.d
	GETVAL(*CPU\V, r)
	SETVAL(*CPU\V, Abs(r))
EndProcedure

Procedure OP_MIN()
	Static r1.d, r2.d
	GETVAL(*CPU\V, r1)
	GETVAL_READ(System\nextIP, r2)
	If r1 < r2
		r1 = r2
		*CPU\FLAGS = 1
	Else
		*CPU\FLAGS = 0
	EndIf	
	SETVAL(*CPU\V, r1)
EndProcedure

Procedure OP_MAX()
	Static r1.d, r2.d
	GETVAL(*CPU\V, r1)
	GETVAL_READ(System\nextIP, r2)
	If r1 > r2
		r1 = r2
		*CPU\FLAGS = 1
	Else
		*CPU\FLAGS = 0
	EndIf	
	SETVAL(*CPU\V, r1)
EndProcedure

Procedure OP_RND()
	SETVAL(*CPU\V, Random(100000) / 100000.0)
EndProcedure

Procedure OP_IFL()
	Static r
	GETVAL_READ(System\nextIP, r)
	If *CPU\FLAGS = r
		System\nextIP + 1
	Else
		GETVAL(System\nextIP, System\nextIP)
	EndIf
EndProcedure

Procedure OP_IGR()
	COMPARE(>, #FLAG_GREATER, #FLAG_LOWER | #FLAG_EQUAL)
EndProcedure

Procedure OP_ILO()
	COMPARE(<, #FLAG_LOWER, #FLAG_GREATER | #FLAG_EQUAL)
EndProcedure

Procedure OP_IEQ()
	COMPARE(=, #FLAG_EQUAL, #FLAG_NOTEQUAL)
EndProcedure

Procedure OP_IGE()
	COMPARE(>=, #FLAG_GREATER | #FLAG_EQUAL, #FLAG_LOWER)
EndProcedure

Procedure OP_ILE()
	COMPARE(<=, #FLAG_LOWER | #FLAG_EQUAL, #FLAG_GREATER)
EndProcedure

Procedure OP_INE()
	COMPARE(<>, #FLAG_NOTEQUAL, #FLAG_EQUAL)
EndProcedure

Procedure OP_JMF()
	Static r1, r2
	GETVAL_READ(System\nextIP, r1)
	GETNEXTADRMODE()
	GETVAL_READ(System\nextIP, r2)
	If *CPU\FLAGS = r1
		System\nextIP = r2
	EndIf
EndProcedure

Procedure OP_STP()
	Static r.d
	*CPU\X = *CPU\V
	GETVAL_READ(System\nextIP, *CPU\C)
	GETVAL(*CPU\X, r)
	SETVAL(*CPU\X, r - *CPU\C)
EndProcedure

Procedure OP_TO()
	Static v.d, lim.d
	GETVAL(*CPU\X, v)
	GETVAL_READ(System\nextIP, lim)
	If *CPU\C < 0 And v <= lim
		GETVAL(System\nextIP, System\nextIP)
	ElseIf *CPU\C > 0 And v >= lim
		GETVAL(System\nextIP, System\nextIP)
	Else
		SETVAL(*CPU\X, v + *CPU\C)
		System\nextIP + 1
	EndIf
EndProcedure

Procedure OP_JMP()
	Static r
	GETVAL_READ(System\nextIP, r)
	System\nextIP = r
EndProcedure

Procedure OP_CAL()
	Static r
	GETVAL_READ(System\nextIP, r)	
	PUSH(System\nextIP)	; push return address
	System\nextIP = r
	System\callDepth + 1
EndProcedure

Procedure OP_RET()
	If System\callDepth < 1
		System_Error(System_LineNrByIP(*CPU\IP), "Return without Call")
	Else
		POP(System\nextIP) ; pop return address
		System\callDepth - 1
	EndIf
EndProcedure

Procedure OP_ASP()
	Static r.d
	GETVAL_READ(System\nextIP, r)
	*CPU\SP + r
EndProcedure

Procedure OP_PSH()
	Static r.d
	GETVAL_READ(System\nextIP, r)
	PUSH(r)
EndProcedure

Procedure OP_POP()
	Static w, r.d
	GETVAL_WRITE(System\nextIP, w)
	POP(r)
	SETVAL(w, r)
EndProcedure

Procedure OP_PSF()
	PUSH(*CPU\FLAGS)
EndProcedure

Procedure OP_POF()
	POP(*CPU\FLAGS)
EndProcedure

Procedure OP_PSC()
	PUSH(*CPU\C)
	PUSH(*CPU\X)
EndProcedure

Procedure OP_POC()
	POP(*CPU\X)
	POP(*CPU\C)
EndProcedure
	
Procedure OP_SCR()
	GETVAL_READ(System\nextIP, System\SCR_Width)
	GETNEXTADRMODE()
	GETVAL_READ(System\nextIP, System\SCR_Height)
	
	System\SCR_Width = CLAMP(System\SCR_Width, 1, 1000)
	System\SCR_Height = CLAMP(System\SCR_Height, 1, 1000)
	System\VRAM_Size = System\SCR_Width * System\SCR_Height
	
	Dim *CPU\VRAM(System\VRAM_Size)
	
	If IsWindow(#w_Screen)
		System_CloseScreen(#True)
		System\SCR_Active = OpenWindowedScreen(WindowID(#w_Screen), 0, 0, System\SCR_Width, System\SCR_Height, 1, 0, 0, #PB_Screen_NoSynchronization)
		
		If *CurrentFile
			SetWindowTitle(#w_Screen, *CurrentFile\path)
		EndIf

		SetWindowState(#w_Screen, #PB_Window_Maximize)
		PostEvent(#PB_Event_SizeWindow, #w_Screen, 0, 0, 1)
		
		If System\SCR_Active
			ClearScreen(0)
			FlipBuffers()
			ReleaseMouse(1)
		EndIf
		
		System\SCR_Visible = #True
		HideWindow(#w_Screen, 0)
	EndIf
EndProcedure

Procedure OP_CLS()
	Static r.b, size
	GETVAL_READ(System\nextIP, r)

	ClearScreen(#SCR_BACKGROUND)
	size = ArraySize(*CPU\VRAM())
	If size >= 0
		FillMemory(@*CPU\VRAM(0), size * 2, r, TypeOf(r))
	EndIf
EndProcedure

Procedure OP_CHS()
	GETVAL_READ(System\nextIP, *CPU\RAM(System\ADR_CHR_W))
	GETNEXTADRMODE()
	GETVAL_READ(System\nextIP, *CPU\RAM(System\ADR_CHR_H))
EndProcedure

Procedure OP_CHM()
	GETVAL_READ(System\nextIP, *CPU\RAM(System\ADR_CHR_MODE))
EndProcedure

Procedure OP_CXY()
	GETVAL_READ(System\nextIP, *CPU\RAM(System\ADR_CHR_X))
	GETNEXTADRMODE()
	GETVAL_READ(System\nextIP, *CPU\RAM(System\ADR_CHR_Y))
EndProcedure

Procedure OP_CHR()
	Static source, x, y, cx, cy
	Static chrW, chrH, chrX, chrY, chrMode, scrW, scrH
	Static adrR, adrV, adrStart, adrAdd, adrSub
	Static.u color, collision, colID, colF, colB
	
	GETVAL_READ(System\nextIP, source)
	
	If source < 0 Or source >= System\RAM_Size
		ProcedureReturn
	EndIf
	
	scrW = System\SCR_Width
	scrH = System\SCR_Height
	GETVAL(System\ADR_Collision, collision)
	GETVAL(System\ADR_COL_Front, colF)
	GETVAL(System\ADR_COL_Back, colB)
	GETVAL(System\ADR_CHR_X, chrX)
	GETVAL(System\ADR_CHR_Y, chrY)
	GETVAL(System\ADR_CHR_W, chrW)
	GETVAL(System\ADR_CHR_H, chrH)
	GETVAL(System\ADR_CHR_MODE, chrMode)
	GETVAL(System\ADR_CollisionID, colID)
	colID << 8

	chrW - 1
	chrH - 1
	
	Select chrMode
		Case 0 ; normal mode
			adrStart = source
			adrAdd = 1
			adrSub = 0
		Case 1 ; rotate 90°
			adrStart = source + chrH * (chrW + 1)
			adrAdd = -(chrW + 1)
			adrSub = (chrW + 1) * (ChrH + 1) + 1
			Swap chrW, chrH
		Case 2 ; rotate 180°
			adrStart = source + (ChrW + 1) * (chrH + 1) - 1
			adrAdd = -1
			adrSub = 0
		Case 3 ; rotate 270°
			adrStart = source + chrW
			adrAdd = chrW + 1
			adrSub = -(chrW + 1) * (chrH + 1) - 1
			Swap chrW, chrH
		Case 4 ; flip x-axis
			adrStart = source + ChrW
			adrAdd = -1
			adrSub =  ChrW * 2 + 2
		Case 5 ; flip y-axis
			adrStart = source + ChrH * (chrW + 1)
			adrAdd = 1
			adrSub = -(chrW + 1) * 2
		Default ; normal mode
			adrStart = source
			adrAdd = 1
			adrSub = 0
	EndSelect
	
	If colF
		
		adrR = adrStart
		cy = chrY
		For y = 0 To chrH
			cx = chrX
			adrV = cx + cy * scrW
			For x = 0 To chrW
				If cx >= 0 And cx < scrW And cy >= 0 And cy < scrH
					color = *CPU\RAM(adrR)
					If color
						If collision = 0
							collision = *CPU\VRAM(adrV)
							If collision & $FF00 ; collision found! 
								collision >> 8
								SETVAL(System\ADR_Collision, collision)
							EndIf
						EndIf
						color | colID ; add collision ID to the color
						*CPU\VRAM(adrV) = colF
					Else
						*CPU\VRAM(adrV) = colB
					EndIf
				EndIf
				adrR + adrAdd
				adrV + 1
				cx + 1
			Next
			adrR + adrSub
			cy + 1
		Next
		
	Else		
		
		adrR = adrStart
		cy = chrY
		For y = 0 To chrH
			cx = chrX
			adrV = cx + cy * scrW
			For x = 0 To chrW
				If cx >= 0 And cx < scrW And cy >= 0 And cy < scrH
					color = *CPU\RAM(adrR)
					If color
						If collision = 0
							collision = *CPU\VRAM(adrV)
							If collision & $FF00 ; collision found! 
								collision >> 8
								SETVAL(System\ADR_Collision, collision)
							EndIf
						EndIf
						color | colID ; add collision ID to the color
						*CPU\VRAM(adrV) = color
					ElseIf colB
						*CPU\VRAM(adrV) = colB
					EndIf
				EndIf
				adrR + adrAdd
				adrV + 1
				cx + 1
			Next
			adrR + adrSub
			cy + 1
		Next
		
	EndIf
EndProcedure

Procedure OP_CLF()
	Static r.a	
	GETVAL_READ(System\nextIP, r)
	*CPU\RAM(System\ADR_COL_Front) = r
EndProcedure

Procedure OP_CLB()
	Static r.a
	GETVAL_READ(System\nextIP, r)
	*CPU\RAM(System\ADR_COL_Back) = r
EndProcedure

Procedure OP_PLT()
	Static x, y, adr
	GETVAL_READ(System\nextIP, x)
	GETNEXTADRMODE()
	GETVAL_READ(System\nextIP, y)
	adr = x + y * System\SCR_Width
	If adr >= 0 And adr < System\VRAM_Size
		GETVAL(System\ADR_COL_Front, *CPU\VRAM(adr))
	EndIf
EndProcedure

Procedure OP_DRW()
	Static x, y, scrW, scrH, adrV, c.a
	
	If System\SCR_Active
		If StartDrawing(ScreenOutput())
			scrW = System\SCR_Width - 1
			scrH = System\SCR_Height - 1
			adrV = 0
			For y = 0 To scrH
				For x = 0 To scrW
					c = *CPU\VRAM(adrV)
					Plot(x, y, *CPU\RAM(System\ADR_Color + c))
					adrV + 1
				Next
			Next
			StopDrawing()
			
			FlipBuffers()
		EndIf
	EndIf
EndProcedure

Procedure OP_DLY()
	Static r, curIP, nextIP
	If System\wait = 0
		curIP = System\nextIP
		GETVAL_READ(System\nextIP, r)
		System\wait = System\time + r
		nextIP = System\nextIP
		System\nextIP = curIP
	ElseIf System\time >= System\wait
		System\wait = 0
		System\nextIP = nextIP
	Else
		Delay(5)
	EndIf
EndProcedure

Procedure OP_INP()
	If System\SCR_Active
		ExamineMouse()
		ExamineKeyboard()
		
		*CPU\FLAGS = KeyboardPushed(#PB_Key_All)
		System\MouseX = MouseX()
		System\MouseY = MouseY()
		System\MouseB = 0
		
		If MouseButton(#PB_MouseButton_Left)
			System\MouseB | #Button_Left
		EndIf
		If MouseButton(#PB_MouseButton_Right)
			System\MouseB | #Button_Right
		EndIf
	Else
		*CPU\FLAGS = 0
	EndIf
EndProcedure

Procedure OP_KEY()
	Static r
	GETVAL_READ(System\nextIP, r)
	*CPU\FLAGS = Bool(KeyboardPushed(r))
EndProcedure

Procedure OP_SNP()
	Static r1, r2
	GETVAL_READ(System\nextIP, r1)
	GETNEXTADRMODE()
	GETVAL_READ(System\nextIP, r2)
	
	If SoundSystemOK
		If r1
			If IsSound(r1)
				If r2 = 0
					StopSound(r1)
				ElseIf r2 = 2
					PauseSound(r1)
				Else
					PlaySound(r1)
				EndIf
			EndIf
		Else
			If r2 = 2
				PauseSound(#PB_All)
			Else
				StopSound(#PB_All)
			EndIf
		EndIf
	EndIf
EndProcedure

Procedure OP_SNS()
	Static r
	GETVAL_READ(System\nextIP, r)
	
	If SoundSystemOK
		*CPU\FLAGS = -1
		If IsSound(r)
			Select SoundStatus(r)
				Case #PB_Sound_Stopped : *CPU\FLAGS = 0
				Case #PB_Sound_Playing : *CPU\FLAGS = 1
				Case #PB_Sound_Paused : *CPU\FLAGS = 2
			EndSelect
		EndIf
	EndIf
EndProcedure

Procedure OP_DBG()
	Static r.d
	GETVAL_READ(System\nextIP, r)
	
	While CountGadgetItems(#g_Error) > 100
		RemoveGadgetItem(#g_Error, 0)
	Wend

	AddGadgetItem(#g_Error, -1, TIMESTR() + Chr(10) + "value: " + FSTR(r), 0)
	SetGadgetState(#g_Error, CountGadgetItems(#g_Error) - 1)
EndProcedure

Procedure OP_HLT()
	System_Error(System_LineNrByIP(*CPU\IP) + 1, "HALT - PROGRAM PAUSED!", #True)
	System_RunState((RunState & ~(#STATE_PAUSE | #STATE_STEPOUT)) | (#STATE_STEP | #STATE_RUN))
EndProcedure

Procedure OP_END()
	System\state | #STATE_END
	System_CloseScreen(#True)
	System_RunState(0)
EndProcedure

Procedure OP_KIL()
	Static r.d
	GETVAL(*CPU\IP, r)
	System_Error(System_LineNrByIP(*CPU\IP), "Illegal opcode: " + FSTR(r))
	System\state | #STATE_END
	System_RunState(0)
EndProcedure

;-

Procedure Parse_WriteF(value.d, ip = -1)
	Protected lineNr
	
	If ip = -1
		lineNr = Parser\curLine
		ip = *CPU\IP
		*CPU\IP + 1
	Else
		lineNr = System_LineNrByIP(ip)
	EndIf
	
	SETVAL(ip, value)		
	If System\state & #STATE_ERROR = 0
		System\symTable(ip)\type = #SYM_FLOAT
		System\symTable(ip)\lineNr = lineNr
		ProcedureReturn #True
	EndIf
		
	ProcedureReturn #False
EndProcedure

Procedure Parse_WriteI(value, type, *token.TOKEN = #Null, ip = -1)
	Protected lineNr
	
	If ip = -1
		lineNr = Parser\curLine
		ip = *CPU\IP
		*CPU\IP + 1
	Else
		lineNr = System_LineNrByIP(ip)
	EndIf
	
	SETVAL(ip, value)
	If System\state & #STATE_ERROR = 0
		System\symTable(ip)\type = type
		System\symTable(ip)\token = *token
		System\symTable(ip)\lineNr = lineNr
		ProcedureReturn #True
	EndIf

	ProcedureReturn #False
EndProcedure

Procedure Parse_IsNumber(param.s)
	Protected *c.Character = @param
	Protected decPoint
	While *c\c
		Select *c\c
			Case '-', '0' To '9'
			Case '.'
				decPoint + 1
				If decPoint > 1
					ProcedureReturn #False
				EndIf
			Default
				ProcedureReturn #False
		EndSelect
		*c + SizeOf(Character)
	Wend
	
	ProcedureReturn #True
EndProcedure

Procedure Parse_AddVar(name.s, *token)
	Protected uName.s = UCase(name)
	
	Parser\curVar = FindMapElement(Parser\var(), uName)
	If Parser\curVar = #Null
		Parser\curVar = AddMapElement(Parser\var(), uName)
		If Parser\curVar
			Parser\curVar\name = name
			Parser\curVar\adr = System\ADR_Var
			System\symTable(Parser\curVar\adr)\token = *token
			;Parse_WriteI(Parser\curVar\adr, #SYM_INT, *token, Parser\curVar\adr)
			SETVAL(System\ADR_VarPointer, System\ADR_Var)
			System\ADR_Var - 1
		EndIf
	EndIf
	
	If Parser\curVar = #Null
		System_Error(Parser\curLine, "Couldn't create Variable")
	EndIf
	
	ProcedureReturn Parser\curVar
EndProcedure

Procedure Parse_AddDataSect(type, *token.TOKEN, adr, lineNr)
	Parser\curDataSect = AddElement(Parser\dataSect())
	If Parser\curDataSect
		With Parser\curDataSect
			\type = type
			\token = *token
			\startAdr = adr
			\endAdr = adr
			\lineNr = lineNr
		EndWith
	EndIf
	ProcedureReturn Parser\curDataSect
EndProcedure

Procedure Parse_AddReference(type, *token.TOKEN, typeName.s, lineNr)
	Protected *reference.DATASECT = AddElement(Parser\reference())
	
	If *reference = #Null
		System_Error(Parser\codeLineCount, "couldn't create " + typeName + "reference")
	Else
		*reference\type = type
		*reference\token = *token
		*reference\startAdr = *CPU\IP
		*reference\lineNr = lineNr
		Parse_WriteI(0, type, *token) ; place holder for address, the real address will be written at end of parse process.
	EndIf
	ProcedureReturn *reference
EndProcedure

Procedure Parse_SetAddressMode(index, adrMode.a)
	Protected opcode

	If Parser\curOpcode = #Null
		System_Error(Parser\codeLineCount, "Syntax Error - Missing Command")
	Else
		GETVAL(Parser\curIP, opcode)
		If index <= 0
			opcode | (adrMode << 8)
			; 			opcode = (opcode & $F0FF) | (adrMode << 8)	
		ElseIf index = 1
			opcode | (adrMode << 12)
			; 			opcode = (opcode & $0FFF) | (adrMode << 12)
		Else
			System_Error(Parser\codeLineCount, "Parse_SetAddressMode: wrong index: " + Str(index))
		EndIf
		
		Parser\curAdrMode | adrMode
		SETVAL(Parser\curIP, opcode)
	EndIf
EndProcedure

Procedure.s Parser_TokenText(*token.TOKEN)
	If *token
		ProcedureReturn Mid(Parser\code, *token\position, *token\length)
	EndIf
EndProcedure

Procedure Parse_Token(*token.TOKEN, index = 0, addNew = #False)
	Protected value, address
	Protected text.s, uText.s, key.s, varType
	
	If *token = #Null
		System_Error(Parser\codeLineCount, "Null Token")
		ProcedureReturn #False
	ElseIf *token\type = #T_OPCODE
		System_Error(Parser\codeLineCount, "Syntax Error")
		ProcedureReturn #False
	EndIf
	
	Parser\curVar = #Null
	Parser\curDataSect = #Null
	
	text = *token\text
	key = UCase(*token\text)
	
	text = LTrim(text, "$")    ; Subroutine
	text = LTrim(text, ":")    ; Label
	text = LTrim(text, "@")	   ; Pointer
	text = LTrim(text, "!")	   ; Read Value
	text = LTrim(text, "~")	   ; Array
	text = LTrim(text, "#")	   ; Flag
	uText = UCase(text)
	varType = Asc(*token\text)
	
;  	Debug "    token: " + TokenText(*token) + " type: " + Str(*token\type) + "   index Nr.: " + Str(index)
	
	If *token\type = #T_SUB
		
		If addNew

			If FindMapElement(Parser\sub(), key)
				System_Error(Parser\codeLineCount, "Sub already defined: " + text)
			ElseIf AddMapElement(Parser\sub(), key) = 0
				System_Error(Parser\codeLineCount, "couldn't create Sub: " + text)
			Else
				Parser\sub() = Parse_AddDataSect(#SYM_SUB, *token, *CPU\IP, Parser\codeLineCount)
			EndIf
			
		Else
			
			Parse_SetAddressMode(index, #ADR_DIRECT)
			Parse_AddReference(#SYM_SUB, *token, "Sub", Parser\codeLineCount)
			
		EndIf
		
	ElseIf *token\type = #T_FIELD
		
		If addNew
			
			If FindMapElement(Parser\field(), key)
				System_Error(Parser\codeLineCount, "Field already defined: " + text)
			ElseIf AddMapElement(Parser\field(), key) = 0
				System_Error(Parser\codeLineCount, "couldn't create Field: " + text)
			Else
				Parser\field() = Parse_AddDataSect(#SYM_FIELD, *token, *CPU\IP, Parser\codeLineCount)
			EndIf
			
		Else
			
			Parse_SetAddressMode(index, #ADR_DIRECT)
			Parse_AddReference(#SYM_FIELD, *token, "Field", Parser\codeLineCount)
			
		EndIf
		
	ElseIf *token\type = #T_LABEL
		
		If addNew
			
			If FindMapElement(Parser\label(), key)
				System_Error(Parser\codeLineCount, "Label already defined: " + text)
			ElseIf AddMapElement(Parser\label(), key) = 0
				System_Error(Parser\codeLineCount, "couldn't create Label: " + text)
			Else
				Parser\label() = Parse_AddDataSect(#SYM_LABEL, *token, *CPU\IP, Parser\codeLineCount)
			EndIf
			
		Else
			
			Parse_SetAddressMode(index, #ADR_DIRECT)
			Parse_AddReference(#SYM_LABEL, *token, "Label", Parser\codeLineCount)
			
		EndIf
		
	ElseIf varType = '#'
		; param is a CONSTANT
		
		If FindMapElement(Parser\constant(), uText)
			
			If Parser\constant()\type = #SYM_ADDRESS
				Parse_SetAddressMode(index, #ADR_INDIRECT)
				Parse_WriteI(PeekI(Parser\constant()\value), #SYM_CONSTANT, *token)
			Else
				Parse_SetAddressMode(index, #ADR_DIRECT)
				Parse_WriteI(Parser\constant()\value, #SYM_CONSTANT, *token)
			EndIf
		Else
			System_Error(Parser\codeLineCount, "Unknown constant: " + text)
		EndIf
		
	ElseIf *token\type = #T_NUMBER
		
		Parse_SetAddressMode(index, #ADR_DIRECT)
		Parse_WriteF(*token\value)
		
	ElseIf *token\type = #T_VARIABLE
		
		If Parse_AddVar(text, *token)
			Select varType
				Case '@'
					; param is a the ADDRESS of a variable
					Parse_SetAddressMode(index, #ADR_DIRECT)
					Parse_WriteI(Parser\curVar\adr, #SYM_ADDRESS, *token)
				Case '!'
					; param is a value read from a pointer
					Parse_SetAddressMode(index, #ADR_POINTER | #ADR_INDIRECT)
					Parse_WriteI(Parser\curVar\adr, #SYM_VARIABLE, *token)
				Default
					If index < 0
						; param is a sub parameter variable
					Else
						; param is a normal variable
						Parse_WriteI(Parser\curVar\adr, #SYM_VARIABLE, *token)
						Parse_SetAddressMode(index, #ADR_INDIRECT)
					EndIf
			EndSelect
		EndIf
		
	ElseIf *token\type = #T_STRING
		
		Protected i
		Parser\stringIndex + 1
		SETVAL(System\ADR_Var, *token\length - 2)
		System\ADR_Var - 1
		For i = 0 To *token\length - 3
			SETVAL(System\ADR_Var, Asc(Mid(Parser\code, *token\position + i + 1, 1)))
			System\ADR_Var - 1
		Next
		
		If Parse_AddVar("STR_" + Str(Parser\stringIndex), *token)
			Parse_SetAddressMode(index, #ADR_INDIRECT)
			Parse_WriteI(Parser\curVar\adr, #SYM_STRING)
		EndIf
		
	Else
		
		System_Error(Parser\codeLineCount, "unknown token type: " + Str(*token\type) + "  text: '" + Parser_TokenText(*token) + "'")
		
	EndIf
	
	If System\state & #STATE_ERROR
		Parser\curVar = #Null
		ProcedureReturn #False
	Else
		ProcedureReturn #True
	EndIf
EndProcedure

Procedure Parse_NextType(direction, tokenType = -1, value.s = "")
	Protected *token.TOKEN
	Protected index = Parser\tokenIndex
	
	Repeat
		index + direction
		*token = @Parser\token(index)\type
		Select *token\type
			Case 0
				ProcedureReturn -1
			Case #T_NEWLINE, #T_LABEL, #T_SEPARATOR, #T_COMMENT
			Case tokenType
				If value And Parser_TokenText(*token) <> value
					ProcedureReturn -1
				EndIf
				ProcedureReturn index
			Default
				If tokenType >= 0
					ProcedureReturn -1
				EndIf
				ProcedureReturn *token\type
		EndSelect
	Until (direction < 0 And index = 0)
	
	ProcedureReturn -1
EndProcedure

Procedure Parse_NextToken(type = #T_UNKNOWN, throwError = #False)
	Protected *token.TOKEN
	Protected index = Parser\tokenIndex
	Protected prevLineNr = Parser\codeLineCount

	Parser\curToken = #Null
	While index < Parser\tokenCount And (System\state & #STATE_ERROR) = 0
		*token = @Parser\token(index)\type
		index + 1
		Select *token\type
			Case #T_SEPARATOR, #T_COMMENT
			Case #T_NEWLINE
				Parser\codeLineCount + 1
			Default
				If type = #T_UNKNOWN Or type = *token\type
					Parser\tokenIndex = index
					Parser\curToken = *token
				ElseIf throwError
					System_Error(Parser\codeLineCount, "Syntax Error")
				EndIf
				Break
		EndSelect
	Wend
	
	If (System\state & #STATE_ERROR) Or Parser\curToken = #Null
		Parser\codeLineCount = prevLineNr
		ProcedureReturn #Null
	EndIf
	
	ProcedureReturn Parser\curToken
EndProcedure

Procedure Parse_Field()
	Protected i, value.d
	Protected currentLine, fieldSize
	Protected *dataSect.DATASECT
	
	currentLine = Parser\codeLineCount
	
	If Parse_Token(Parser\curToken, 0, #True)
		*dataSect = Parser\curDataSect
		If Parse_NextToken(#T_BRACKET_OPEN, #True)
			While (System\state & #STATE_ERROR = 0) And Parse_NextToken()
				Select Parser\curToken\type
					Case #T_BRACKET_CLOSE
						*dataSect\endAdr = *CPU\IP
						ProcedureReturn #True
					Case #T_NUMBER
						value = Parser\curToken\value
						If Parse_NextToken(#T_OPCODE)
							If Parser\curToken\opcode\ID <> #_MUL
								System_Error(Parser\codeLineCount, "Syntax Error")
							ElseIf Parse_NextToken(#T_NUMBER, #True)
								; e.g.:  DAT (0*64)  - allocate 64 slots with value 0
								For i = Parser\curToken\value - 1 To 0 Step -1
									If Parse_WriteF(value)
										fieldSize + 1
									Else
										ProcedureReturn #False
									EndIf
								Next
							EndIf
						ElseIf Parse_WriteF(value)
							fieldSize + 1
						Else
							; e.g.:  DAT (123)  - allocate one slot with value 123
							ProcedureReturn #False
						EndIf
					Case #T_STRING
						; e.g.:  DAT ("123")  - allocate 4 slots with the values 49, 50, 51, 0 (ascii values of 1,2,3 and 0 as end-of-text marker)
						For i = 1 To Parser\curToken\length - 2
							value = Asc(Mid(Parser\code, Parser\curToken\position + i, 1))
							If Parse_WriteI(value, #SYM_STRING)
								fieldSize + 1
							Else
								ProcedureReturn #False
							EndIf
						Next
						If Parse_WriteI(0, #SYM_STRING)
							fieldSize + 1
						Else
							; write '0' as string terminator
							ProcedureReturn #False
						EndIf
					Default
						System_Error(Parser\codeLineCount, "Wrong Datatype")
						ProcedureReturn #False
				EndSelect
			Wend
		EndIf
	EndIf
	
	System_Error(currentLine, "Field has no end")
	ProcedureReturn #False
EndProcedure

Procedure Parse_Var(index)
	Protected *curToken.TOKEN = Parser\curToken
	
	If Parse_NextToken(#T_PERIOD) ; it's an indexed variable
		If Parse_NextToken(#T_NUMBER)
			Parse_SetAddressMode(Parser\paramNr, #ADR_INDX_DI)
			Parse_WriteI(Parser\curToken\value, #SYM_INT, Parser\curToken)
		ElseIf Parse_NextToken(#T_VARIABLE)
			If Parse_Token(Parser\curToken, index)
				Parse_SetAddressMode(Parser\paramNr, #ADR_INDX_IN)
			EndIf
		Else
			System_Error(Parser\codeLineCount, "wrong index type")
			ProcedureReturn #False
		EndIf
	EndIf
	
	ProcedureReturn Parse_Token(*curToken, index)
EndProcedure

Procedure Parse_SkipVar()
	If Parse_NextToken(#T_PERIOD) ; it's an indexed variable
		If Parse_NextToken(#T_NUMBER) Or Parse_NextToken(#T_VARIABLE)
		Else
			System_Error(Parser\codeLineCount, "wrong index type")
			ProcedureReturn #False
		EndIf
	EndIf	
	ProcedureReturn Bool(System\state & #STATE_ERROR = 0)
EndProcedure

Procedure Parse_Param(expectedType1 = #T_UNKNOWN, expectedType2 = #T_UNKNOWN)
	Protected type, expectedType, paramNr, result
	
	If Parser\curOpcode = 0
		System_Error(Parser\codeLineCount, "Parameter without command")
	EndIf
	
	For paramNr = 0 To Parser\curOpcode\nParams - 1
		Parser\paramNr = paramNr
		
		If Parser\paramNr = 0
			expectedType = expectedType1
		ElseIf Parser\paramNr = 1
			expectedType = expectedType2
		EndIf
		
		type = expectedType
		result = #False
		
		If type = #T_UNKNOWN
			If Parse_NextToken(#T_NUMBER)
				type = #T_NUMBER
				result = #True
			ElseIf Parse_NextToken(#T_VARIABLE)
				type = #T_VARIABLE
				result = #True
			ElseIf Parse_NextToken(#T_LABEL)
				type = #T_LABEL
				result = #True
			ElseIf Parse_NextToken(#T_FIELD)
				type = #T_FIELD
				result = #True
			ElseIf Parse_NextToken(#T_SUB)
				type = #T_SUB
				result = #True
			EndIf
		ElseIf Parse_NextToken(type)
			result = #True
		EndIf
		
		If result = #True
			If type = #T_VARIABLE
				result = Parse_Var(Parser\paramNr)
			Else
				result = Parse_Token(Parser\curToken, Parser\paramNr)
			EndIf
		Else
			System_Error(Parser\codeLineCount, "Wrong parameter type: " + Str(type) + " expected: " + Str(expectedType))
		EndIf
	Next
	
	ProcedureReturn result
EndProcedure

Procedure Parse_Tokenize()	
	Protected text.s, uText.s, varType
	Protected regEx
	regEx = CreateRegularExpression(#PB_Any, "('(.?)+)|" + 												; comment starting with '''
	                                         "(" + #DOUBLEQUOTE$ + "(.?)+" + #DOUBLEQUOTE$ + ")|" +		; string "..."
	                                         "(\r\n|\r|\n)|" +											; any newLine
	                                         "([=<>]{2})|" +											; <> <= ... compare
	                                         "([-]?\d+(?:\.\d+)?)|" +									; any number (int or float)
	                                         "([$~@#!':]?[0-9A-Z_]+)|" +								; continuous text
	                                         "[=+\-*\/\^%\.:?'(){}<>|]",								; single characters
	                                #PB_RegularExpression_NoCase)
	
	If IsRegularExpression(regEx) = 0
		MessageRequester(#AppTitle$, "Regular Expression Error: " + #NL$ + RegularExpressionError(), #PB_MessageRequester_Error)
		ProcedureReturn #False
	ElseIf ExamineRegularExpression(regEx, Parser\code + #CR$) = #False
		MessageRequester(#AppTitle$, "Regular Expression Error: " + #NL$ + RegularExpressionError(), #PB_MessageRequester_Error)
		FreeRegularExpression(regEx)
		ProcedureReturn #False
	EndIf
	
	While NextRegularExpressionMatch(regEx)
		text = RegularExpressionMatchString(regEx)
		uText = UCase(text)
		
		If Parser\tokenCount >= ArraySize(Parser\token())
			ReDim Parser\token(Parser\tokenCount + 100)
		EndIf

		With Parser\token(Parser\tokenCount)
			\position = RegularExpressionMatchPosition(regEx)
			\length = RegularExpressionMatchLength(regEx)
			\type = 0
			varType = Asc(text)
			
			Select uText
				Case #CR$, #LF$, #NL$
					\type = #T_NEWLINE
				Case "("
					\type = #T_BRACKET_OPEN
				Case ")"
					\type = #T_BRACKET_CLOSE
				Case "."
					\type = #T_PERIOD
				Case "|"
					\type = #T_SEPARATOR
				Default
					If varType = Asc("'")
					ElseIf varType = Asc(#DOUBLEQUOTE$)
						\type = #T_STRING
					ElseIf varType = '$'
						\type = #T_SUB
						\text = text
					ElseIf varType = '~'
						\type = #T_FIELD
						\text = text
					ElseIf varType = ':'
						\type = #T_LABEL
						\text = text
					ElseIf FindMapElement(*Opcode(), uText)
						\type = #T_OPCODE
						\opcode = *Opcode()
					ElseIf  FindMapElement(KeyWord(), uText)
						\type = KeyWord()
					ElseIf Parse_IsNumber(uText)
						\type = #T_NUMBER
						\value = ValD(uText)
					Else
						\type = #T_VARIABLE
						\text = text
					EndIf
			EndSelect
			
			If \type
				\index = Parser\tokenCount
				Parser\tokenCount + 1
			EndIf
		EndWith
	Wend
	FreeRegularExpression(regEx)
	
	ReDim Parser\token(Parser\tokenCount)
	
	ProcedureReturn Parser\tokenCount
EndProcedure

Procedure Parse_Start(code.s)	
	Protected StartTime = ElapsedMilliseconds()
	Protected refName.s
	Protected key.s
	
	System_Init(System\RAM_Size, System\STACK_Size)
	
	Parser\code = code
	Parse_Tokenize()	
	
	System_RunState(RunState & ~(#STATE_END | #STATE_RUN | #STATE_ERROR))
	*CPU\IP = 0
	
	Parse()
	
	System\programSize = *CPU\IP
	
	If LastElement(Parser\bracketList())
		System_Error(Parser\bracketList()\lineNr, "missing closing bracket")
	EndIf
	
	If RunState & #STATE_END = 0
		; assign addresses for subroutines
		ForEach Parser\reference()
			With Parser\reference()
				refName = TokenText(Parser\reference()\token)
				key = UCase(refName)
				
				Select \type
					Case #SYM_SUB
						If FindMapElement(Parser\sub(), key) And Parser\sub()\startAdr >= 0
							;SETVAL(\startAdr, Parser\sub()\startAdr)
							Parse_WriteI(Parser\sub()\startAdr, #SYM_SUB, \token, \startAdr)
						ElseIf (System\state & #STATE_ERROR) = 0
							System_Error(\lineNr, "Sub not found: " + refName)
						EndIf
					Case #SYM_LABEL
						If FindMapElement(Parser\label(), key) And Parser\label()\startAdr >= 0
							SETVAL(\startAdr, Parser\label()\startAdr)
;							Parse_WriteI(Parser\label()\startAdr, #SYM_LABEL, \startAdr)
						ElseIf (System\state & #STATE_ERROR) = 0
							System_Error(\lineNr, "Label not found: " + refName)
						EndIf
					Case #SYM_FIELD
						If FindMapElement(Parser\field(), key) And Parser\field()\startAdr >= 0
; 							SETVAL(\startAdr, Parser\field()\startAdr)
							Parse_WriteI(Parser\field()\startAdr, #SYM_FIELD, \token, \startAdr)
						ElseIf (System\state & #STATE_ERROR) = 0
							System_Error(\lineNr, "Field not found: " + refName)
						EndIf
					Default
						Debug "unknown reference: " + refName
				EndSelect
			EndWith
		Next
	EndIf
	
	*CPU\IP = 0
	
	System_Update_Label()
	If MonitorVisible
		System_Update_Variable(#False, #True)
		System_Update_Monitor(0)
	EndIf
	
	AddGadgetItem(#g_Error, -1, TIMESTR() + Chr(10) + "parsing finished in " + FSTR((ElapsedMilliseconds() - StartTime) / 1000.0) + " seconds") 
	
	StatusBarText(0, 0, "RAM: " + Str(System\RAM_Size) + " Size: " + Str(System\programSize) + " / " + Str(System\ADR_Var - System\programSize) + " free", #PB_StatusBar_Center)
	
	SortStructuredList(Parser\dataSect(), #PB_Sort_Ascending, OffsetOf(DATASECT\startAdr), TypeOf(DATASECT\startAdr))
	
; 	ForEach Parser\dataSect()
; 		With Parser\dataSect()
; 			Select \type
; 				Case #SYM_LABEL : Debug "LABEL " + TokenText(\token)
; 				Case #SYM_FIELD : Debug "FIELD " + TokenText(\token)
; 				Case #SYM_SUB : Debug "SUB " + TokenText(\token)
; 				Default : Debug "? " + Str(\type) + " " + TokenText(\token)
; 			EndSelect
; 			
; 			Debug "Line: " + Str(\lineNr + 1)
; 			Debug "Adr:  "  + Str(\startAdr) + " - " + Str(\endAdr) 
; 			Debug "--------"
; 		EndWith
; 	Next
	
; 	If CreateFile(0, "output.bsm")
; 		WriteData(0, @*CPU\RAM(0), System\programSize)
; 		CloseFile(0)
; 	EndIf
	
	ProcedureReturn Bool(System\state & #STATE_ERROR = 0)
EndProcedure

Procedure Parse(readState = 0, depth = 0)
	Protected prevIP, elseIP, readGroup, breakLevel
	Protected *dataSect.DATASECT
	Protected tab.s = Space(depth * 4)
	Protected setVar.s
	
	While (System\state & #STATE_ERROR = 0) And Parse_NextToken()
		Parser\curLine = Parser\codeLineCount
		
;  		Debug  MEMSTR(Parser\curLine + 1) + MEMSTR(Parser\tokenIndex) + tab + MEMSTR(readState) + ":  " + TokenText(Parser\curToken)
		
		Select Parser\curToken\type
				
			Case 0
				
				Break
				
			Case #T_BRACKET_OPEN
				
				LastElement(Parser\bracketList())
				If AddElement(Parser\bracketList())
					Parser\bracketList()\lineNr = Parser\curLine
				EndIf
				
			Case #T_BRACKET_CLOSE
				
				If LastElement(Parser\bracketList())
					DeleteElement(Parser\bracketList())
				Else
					System_Error(Parser\curLine, "mismatched bracket")
				EndIf
				
				If depth > 0
					; exit this dataSection and return to previous one
					Break
				EndIf
				
			Case #T_VARIABLE
				
; 				If setVar And setVar = Parser\curToken\text
;  					Debug MEMSTR(*CPU\IP) + ":  SET " + setVar + " skipped"
;  					Parse_SkipVar()
;  				Else
;  					setVar = Parser\curToken\text
 					
					Parser\curOpcode = @Opcode(#_SET)
					Parser\curIP = *CPU\IP
					Parser\paramNr = 0
					If Parse_WriteI(#_SET, #SYM_OPCODE)
						Parse_Var(0)
					EndIf
; 				EndIf
				
			Case #T_LABEL
				
				Parse_Token(Parser\curToken, 0, #True)

			Case #T_SUB
				
				If Parse_Token(Parser\curToken, 0, #True)
					*dataSect = Parser\curDataSect
					While Parse_NextToken(#T_VARIABLE)
						Debug Parse_Token(Parser\curToken, -1)
					Wend
					;Parse_WriteI(#_RET, #SYM_OPCODE)
					If Parse(readState | #READ_SUB, depth + 1)
						If Parser\curOpcode = #Null Or Parser\curOpcode\ID <> #_RET
							Parse_WriteI(#_RET, #SYM_OPCODE)
						EndIf
					EndIf
					If *dataSect
						*dataSect\endAdr = *CPU\IP
					EndIf
				EndIf
				
			Case #T_FIELD
				
					Parse_Field()
								
			Case #T_BREAK
				
				If readState & #READ_LOOP
					If AddElement(Parser\brakeList())
						If Parse_NextToken(#T_NUMBER)
							Parser\brakeList()\data = Parser\curToken\value
						EndIf
						Parse_WriteI(#_JMP, #SYM_OPCODE)
						Parse_WriteI(0, #SYM_ADDRESS)
						Parser\brakeList()\adr = *CPU\IP - 1
					EndIf
				Else
					System_Error(Parser\curLine, "Break without Loop")
				EndIf
				
 			Case #T_ELSE
 				
 				System_Error(Parser\curLine, "Else without If")
 				
 			Case #T_SOUND
 				
 				If Parse_NextToken(#T_VARIABLE, #True)
 					If Parse_AddVar(TokenText(Parser\curToken), Parser\curToken)
 						If Parse_NextToken(#T_STRING, #True)
 							If SoundSystemOK
 								If FindMapElement(System\Sound(), TokenText(Parser\curToken))
 									SETVAL(Parser\curVar\adr, System\Sound())
 								Else
 									AddMapElement(System\sound(), TokenText(Parser\curToken))
 									System\sound() = LoadSound(#PB_Any, GetPathPart(*CurrentFile\path) + Trim(TokenText(Parser\curToken), #DOUBLEQUOTE$))
 									If IsSound(System\sound())
 										SETVAL(Parser\curVar\adr, System\sound())
 									EndIf
 								EndIf
 							EndIf
 						EndIf
 					EndIf
 				EndIf
 				
			Case #T_OPCODE
				
				Protected groupIndex = 0
				Protected curOpIP = *CPU\IP
				Protected *curOpcode.OPCODE = Parser\curToken\opcode
				Parser\curOpcode = *curOpcode
				
				readGroup = Parse_NextToken(#T_BRACKET_OPEN)
				
				Repeat
					
					If (readState & #READ_LOOP) And *curOpcode\ID = #_STP
						Parse_WriteI(#_PSC, #SYM_OPCODE) ; push current loop state on the stack (for nested loops)
					EndIf
					
					Parser\curIP = *CPU\IP
					Parser\paramNr = 0	
					System\adrMode = 0
					
					Parse_WriteI(*curOpcode\ID, #SYM_OPCODE)
;  					Debug "    cur. opcode: " + Parser\curOpcode\name + " groupindex " + Str(groupIndex)
					groupIndex + 1
					
					Select *curOpcode\ID
						Case #_SET: Parse_Param()
						Case #_MOV: Parse_Param()
						Case #_WRT: Parse_Param()
						Case #_INT, #_CIL, #_NEG, #_ABS, #_RND, #_SGN
						Case #_ADD, #_SUB, #_MUL, #_DIV, #_MOD, #_POW, #_NTH: Parse_Param()
						Case #_MIN, #_MAX: Parse_Param()
						Case #_JMP: Parse_Param()
						Case #_JMF: Parse_Param()
						Case #_STP: Parse_Param()
						Case #_TO
							
							If Parse_Param() 
								*dataSect = Parser\curDataSect
								prevIP = *CPU\IP
								If Parse_WriteI(0, #SYM_ADDRESS) ; placeholder for the "exit address"
									If Parse(readState | #READ_LOOP, depth + 1)
										Parse_WriteI(#_JMP, #SYM_OPCODE)
										Parse_WriteI(curOpIP, #SYM_ADDRESS)
										ForEach Parser\brakeList()
											SETVAL(Parser\brakeList()\adr, *CPU\IP)
										Next
										SETVAL(prevIP, *CPU\IP)
										If readState & #READ_LOOP
											Parse_WriteI(#_POC, #SYM_OPCODE) ; pop previous loop state from  the stack (for nested loops)
										EndIf
										
										ClearList(Parser\brakeList())
									EndIf
								EndIf
								If *dataSect
									*dataSect\endAdr = *CPU\IP
								EndIf
							EndIf
							
						Case #_IFL, #_ILO, #_IGR, #_ILE, #_IGE, #_IEQ, #_INE
							
							If Parse_Param()
								*dataSect = Parser\curDataSect
								
								prevIP = *CPU\IP
 								Parse_WriteI(0, #SYM_ADDRESS)
 								
 								Protected NewList ExitAdr()
 								Protected addIp = 0
 								
 								If Parse(readState | #READ_IF, depth + 1)
 									If Parse_NextToken(#T_ELSE)
 										SETVAL(prevIP, *CPU\IP + 2)
 										Repeat
 											Parse_WriteI(#_JMP, #SYM_OPCODE)
 											Parse_WriteI(0, #SYM_ADDRESS)
 											AddElement(ExitAdr())
 											ExitAdr() = *CPU\IP - 1
 											Parse(readState | #READ_ELSE, depth + 1)
 										Until Parse_NextToken(#T_ELSE) = 0
 									EndIf
 									If Parse_NextType(1, #T_ELSE) >= 0
 										SETVAL(prevIP, *CPU\IP + 2)
 									ElseIf ListSize(ExitAdr()) = 0
  										SETVAL(prevIP, *CPU\IP)
 									EndIf
								EndIf

								ForEach ExitAdr()
									SETVAL(ExitAdr(), *CPU\IP)
								Next
								ClearList(ExitAdr())
								
								If *dataSect
									*dataSect\endAdr = *CPU\IP
								EndIf
							EndIf
							
						Case #_PSH, #_POP: Parse_Param()
						Case #_PSF, #_POF, #_PSC, #_POC
						Case #_CAL: Parse_Param(#T_SUB)
						Case #_RET
						Case #_CHM, #_CHS, #_CHR, #_CXY: Parse_Param()
						Case #_CLF, #_CLB: Parse_Param()
						Case #_PLT: Parse_Param()
						Case #_SCR: Parse_Param()
						Case #_DRW
						Case #_CLS: Parse_Param()
						Case #_INP
						Case #_KEY: Parse_Param()
						Case #_SNP, #_SNS: Parse_Param()
						Case #_DLY: Parse_Param()
						Case #_DBG: Parse_Param()
						Case #_HLT, #_KIL, #_END
						Default 
							System_Error(Parser\curLine, "Unknown Opcode: " + *curOpcode\name)
					EndSelect

				Until (readGroup = 0) Or (System\state & #STATE_ERROR) Or Parse_NextToken(#T_BRACKET_CLOSE)
				
				Parser\curOpcode = 0
				
			Default
				
				System_Error(Parser\curLine, "Unknown Tokentype: " + Str(Parser\curToken\type))
				
		EndSelect
	Wend
	
	ProcedureReturn Bool(System\state & #STATE_ERROR = 0)
EndProcedure

;-

Procedure Event_Menu()
	System_RunState(0)
	
	Select EventMenu()
		Case #m_Quit
			System_Quit()
		Case #m_New
			File_Open("", #True)
		Case #m_Open
			File_Open("")
		Case #m_Save
			File_Save(*CurrentFile)
		Case #m_SaveAs
			File_Save(*CurrentFile, #True)
		Case #m_Close
			File_Close(*CurrentFile)
		Case #m_Undo
			Scintilla_Undo(*CurrentFile\editor)
		Case #m_Redo
			Scintilla_Redo(*CurrentFile\editor)
		Case #m_Parse
			System_Parse(*CurrentFile, #False)
		Case #m_ParseRun
			System_Parse(*CurrentFile, #True)
		Case #m_Run 
			If (RunState & #STATE_ERROR) = 0
				If RunState & #STATE_STEP
					System_RunState((RunState & ~(#STATE_STEP | #STATE_STEPOUT | #STATE_PAUSE)) | #STATE_RUN)
				ElseIf RunState & #STATE_RUN
					System_RunState(0)
				Else
					System_RunState(#STATE_RUN)
				EndIf
			EndIf
		Case #m_Step
			If (RunState & #STATE_ERROR) = 0
 				System_RunState((RunState & ~(#STATE_PAUSE | #STATE_STEPOUT)) | (#STATE_STEP | #STATE_RUN), #False)
			EndIf
		Case #m_StepOut
			If (RunState & #STATE_ERROR) = 0
				If System\callDepth > 0
					System\exitDepth = System\callDepth
					System_RunState((RunState & ~#STATE_PAUSE) | (#STATE_STEP | #STATE_STEPOUT | #STATE_RUN))
				Else
					System_RunState((RunState & ~(#STATE_PAUSE | #STATE_STEPOUT)) | (#STATE_STEP | #STATE_RUN))    
				EndIf
			EndIf
		Case #m_Monitor
			System_Update_Monitor(0)
			HideWindow(#w_Monitor, 0)
			MonitorVisible = #True
		Case #m_Help
			System_Help()
		Case #m_SearchSel
			If *CurrentFile
				SetGadgetText(#g_SearchText, Scintilla_GetSelText(*CurrentFile\editor))
				Scintilla_SearchStart(*CurrentFile\editor, GetGadgetText(#g_SearchText))
				;			SetActiveGadget(#g_SearchText)
			EndIf
		Case #m_SearchCase, #m_SearchWhole, #m_SearchRegEx
			SetMenuItemState(#m_SearchPopup, EventMenu(), Bool(GetMenuItemState(#m_SearchPopup, EventMenu()) = 0))
			System_SearchFlags()
		Case #m_SearchNext
			If *CurrentFile
				If Scintilla_SearchNext(*CurrentFile\editor) < 0
					MessageRequester(#AppTitle$, "No match found.")
				EndIf
				SetActiveGadget(*CurrentFile\editor)
			EndIf
		Case #m_SearchPrev
			If *CurrentFile
				If Scintilla_SearchPrevious(*CurrentFile\editor) < 0
					MessageRequester(#AppTitle$, "No match found.")
				EndIf
				SetActiveGadget(*CurrentFile\editor)
			EndIf
		Case #m_Hilight
			If *CurrentFile
				Scintilla_HighlightWord(*CurrentFile\editor)
			EndIf
		Case #m_Comment
			If *CurrentFile
				Scintilla_BlockComment(*CurrentFile\editor, Asc("'"))
			EndIf
		Case #m_Uncomment
			If *CurrentFile
				Scintilla_BlockComment(*CurrentFile\editor, Asc("'"), #True)
			EndIf
		Case #m_ExportC
			System_ToC("_compiler\output.c")
; 			System_ToC(SaveFileRequester(#AppTitle$, "", "*.c|*.c", 1))
	EndSelect
EndProcedure

Procedure Event_Gadget()
	Select Event()
		Case #PB_Event_Gadget
			Select EventGadget()
				Case #g_FilePanel
					File_Activate(GetGadgetItemData(#g_FilePanel, GetGadgetState(#g_FilePanel)))
				Case #g_Error, #g_Monitor
					If EventType() = #PB_EventType_LeftDoubleClick
						System_GotoLine(GetGadgetItemData(EventGadget(), GetGadgetState(EventGadget())))
						File_Activate(*CurrentFile)
					EndIf
				Case #g_Variables
					If EventType() = #PB_EventType_LeftDoubleClick
						System_Variable_Change(GetGadgetItemData(#g_Variables, GetGadgetState(#g_Variables)))
					EndIf
				Case #g_Sub
					If EventType() = #PB_EventType_LeftDoubleClick
						System_GotoLine(GetGadgetItemData(#g_Sub, GetGadgetState(#g_Sub)))
						If *CurrentFile And IsGadget(*CurrentFile\editor)
							SetActiveGadget(*CurrentFile\editor)
						EndIf
					EndIf
				Case #g_SearchOptions
					DisplayPopupMenu(#m_SearchPopup, WindowID(#w_Main))
				Case #g_SearchText
					If *CurrentFile And EventType() = #PB_EventType_LostFocus
						Scintilla_SearchStart(*CurrentFile\editor, GetGadgetText(#g_SearchText))	
					EndIf
				Case #g_SearchPrev
					PostEvent(#PB_Event_Menu, #w_Main, #m_SearchPrev)
				Case #g_SearchNext
					PostEvent(#PB_Event_Menu, #w_Main, #m_SearchNext)
				Case #g_SplitterEditorV
					PostEvent(#PB_Event_SizeWindow, #w_Main, 0)
			EndSelect
	EndSelect
EndProcedure

Procedure Event_Window()
	Protected x, y, w, h
	Select Event()
		Case #PB_Event_CloseWindow
			Select EventWindow()
				Case #w_Main
					System_Quit()
				Case #w_Monitor
					MonitorVisible = #False
					HideWindow(#w_Monitor, 1)
				Case #w_Screen
					System\SCR_Visible = #False
					HideWindow(#w_Screen, 1)
					System_RunState(0)
				Default
					HideWindow(EventWindow(), 1)
			EndSelect
		Case #PB_Event_SizeWindow
			Select EventWindow()
				Case #w_Main
					y = ToolBarHeight(#t_Main) + MenuHeight()
					ResizeGadget(#g_SplitterEditorV, 5, ToolBarHeight(#t_Main), WindowWidth(#w_Main) - 10, WindowHeight(#w_Main) - StatusBarHeight(0) - y)
					;ResizeGadget(#g_SearchContainer, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
					ResizeGadget(#g_Sub, #PB_Ignore, #PB_Ignore, GadgetWidth(#g_SubContainer), GadgetHeight(#g_SubContainer) - 30)
					w = GetGadgetState(#g_SplitterEditorV)
					h = GetGadgetState(#g_SplitterEditorH)
					ForEach File()
						ResizeGadget(File()\editor, 0, 0, w, h)
					Next
				Case #w_Screen
					If EventData()
						x = WindowX(#w_Main) + (WindowWidth(#w_Main) - WindowWidth(#w_Screen)) * 0.5
						y = WindowY(#w_Main) + (WindowHeight(#w_Main) - WindowHeight(#w_Screen)) * 0.5
					Else
						x = #PB_Ignore
						y = #PB_Ignore
					EndIf
					Protected aspect.d = System\SCR_Width / System\SCR_Height
					ResizeWindow(#w_Screen, x, y, WindowHeight(#w_Screen) * aspect, #PB_Ignore)
				Case #w_Monitor
					y = ToolBarHeight(#t_Monitor)
					ResizeGadget(#g_SplitterMonitor, 0, y, WindowWidth(#w_Monitor), WindowHeight(#w_Monitor) - y)
				Case #w_Help
					ResizeGadget(#g_Help, 5, 5, WindowWidth(#w_Help) - 10, WindowHeight(#w_Help) - 10)
			EndSelect
	EndSelect
EndProcedure

DisableExplicit

IDE_Init()
System_Start(16320, 256)

Repeat
	If (RunState & #STATE_RUN) And (RunState & #STATE_PAUSE) = 0
		Counter + 1
		If (Counter > 250) Or (RunState & (#STATE_PAUSE))
				Counter = 0
			event = WindowEvent()
		EndIf
		If event = 0
			System\time = ElapsedMilliseconds() - System\startTime
			SETVAL(System\ADR_Time, System\time)
			
			System\prevIP = *CPU\IP
			VarIndex = 0
			VarAddIP = 0
			mem = *CPU\RAM(*CPU\IP)
			opcode = mem & $FF
			System\adrMode = (mem >> 8) & $FF
			
			System\nextIP = *CPU\IP + 1
			CallFunctionFast(Opcode(opcode)\procAddress)
			If System\wait <= 0
				*CPU\IP = System\nextIP
			EndIf
			If System\state & #STATE_ERROR
				System_RunState(RunState & ~(#STATE_RUN | #STATE_STEPOUT))
			EndIf
			
			If (RunState & #STATE_STEPOUT)
				If (opcode = #_RET) And (System\callDepth < System\exitDepth)
					System_RunState((RunState & ~#STATE_STEPOUT) | #STATE_PAUSE)
				EndIf
			Else
				If (RunState & #STATE_STEP)
					System_RunState(RunState | #STATE_PAUSE)
				EndIf
			EndIf
			
		EndIf
	Else
		WaitWindowEvent()
	EndIf
Until System\state & #STATE_QUIT

End

;{
DataSection
	Opcodes:
	; opcode, procAddress, nrParams, size, name
	Data.i #_SET, @OP_SET(), 1, 2 : Data.s "SET"
	Data.i #_MOV, @OP_MOV(), 1, 2 : Data.s "="
	Data.i #_WRT, @OP_WRT(), 1, 2 : Data.s "WRT"
	Data.i #_ADD, @OP_ADD(), 1, 2 : Data.s "+"
	Data.i #_SUB, @OP_SUB(), 1, 2 : Data.s "-"
	Data.i #_MUL, @OP_MUL(), 1, 2 : Data.s "*"
	Data.i #_DIV, @OP_DIV(), 1, 2 : Data.s "/"
	Data.i #_POW, @OP_POW(), 1, 2 : Data.s "^"
	Data.i #_MOD, @OP_MOD(), 1, 2 : Data.s "%"
	Data.i #_INT, @OP_INT(), 0, 1 : Data.s "INT"
	Data.i #_CIL, @OP_CIL(), 0, 1 : Data.s "CIL"
	Data.i #_ABS, @OP_ABS(), 0, 1 : Data.s "ABS"
	Data.i #_NEG, @OP_NEG(), 0, 1 : Data.s "NEG"
	Data.i #_NTH, @OP_NTH(), 1, 2 : Data.s "NTH"
	Data.i #_MIN, @OP_MIN(), 1, 2 : Data.s "MIN"
	Data.i #_MAX, @OP_MAX(), 1, 2 : Data.s "MAX"
	Data.i #_SGN, @OP_SGN(), 0, 1 : Data.s "SGN"
	Data.i #_RND, @OP_RND(), 0, 1 : Data.s "RND"
	Data.i #_IFL, @OP_IFL(), 1, 3 : Data.s "?"
	Data.i #_IGR, @OP_IGR(), 1, 3 : Data.s ">"
	Data.i #_IGE, @OP_IGE(), 1, 3 : Data.s ">="
	Data.i #_ILO, @OP_ILO(), 1, 3 : Data.s "<"
	Data.i #_ILE, @OP_ILE(), 1, 3 : Data.s "<="
	Data.i #_IEQ, @OP_IEQ(), 1, 3 : Data.s "=="
	Data.i #_INE, @OP_INE(), 1, 3 : Data.s "<>"
	Data.i #_JMP, @OP_JMP(), 1, 2 : Data.s "JMP"
	Data.i #_JMF, @OP_JMF(), 2, 3 : Data.s "JMF"
	Data.i #_STP, @OP_STP(), 1, 2 : Data.s "STP"
	Data.i #_TO,  @OP_TO(),  1, 3 : Data.s "TO"
	Data.i #_CAL, @OP_CAL(), 1, 2 : Data.s "CAL"
	Data.i #_RET, @OP_RET(), 0, 1 : Data.s "RET"
	Data.i #_PSH, @OP_PSH(), 1, 2 : Data.s "PSH"
	Data.i #_POP, @OP_POP(), 1, 2 : Data.s "POP"
	Data.i #_PSF, @OP_PSF(), 0, 1 : Data.s "PSF"
	Data.i #_POF, @OP_POF(), 0, 1 : Data.s "POF"
	Data.i #_PSC, @OP_PSC(), 0, 1 : Data.s "PSC"
	Data.i #_POC, @OP_POC(), 0, 1 : Data.s "POC"
	Data.i #_SCR, @OP_SCR(), 2, 3 : Data.s "SCR"
	Data.i #_CLS, @OP_CLS(), 1, 2 : Data.s "CLS"
	Data.i #_DRW, @OP_DRW(), 0, 1 : Data.s "DRW"
	Data.i #_CHS, @OP_CHS(), 2, 3 : Data.s "CHS"
	Data.i #_CXY, @OP_CXY(), 2, 3 : Data.s "CXY"
	Data.i #_CHM, @OP_CHM(), 1, 2 : Data.s "CHM"
	Data.i #_CHR, @OP_CHR(), 1, 2 : Data.s "CHR"
	Data.i #_PLT, @OP_PLT(), 2, 3 : Data.s "PLT"
	Data.i #_CLF, @OP_CLF(), 1, 2 : Data.s "CLF"
	Data.i #_CLB, @OP_CLB(), 1, 2 : Data.s "CLB"
	Data.i #_DLY, @OP_DLY(), 1, 2 : Data.s "DLY"
	Data.i #_INP, @OP_INP(), 0, 1 : Data.s "INP"
	Data.i #_KEY, @OP_KEY(), 1, 2 : Data.s "KEY"
	Data.i #_SNP, @OP_SNP(), 2, 3 : Data.s "SNP"
	Data.i #_SNS, @OP_SNS(), 1, 2 : Data.s "SNS"
	Data.i #_DBG, @OP_DBG(), 1, 2 : Data.s "DBG"
	Data.i #_HLT, @OP_HLT(), 0, 1 : Data.s "HLT"
	Data.i #_KIL, @OP_KIL(), 0, 1 : Data.s "KIL"
	Data.i #_END, @OP_END(), 0, 1 : Data.s "END"
	Data.i 0, 0, 0, 0
EndDataSection
;}
; IDE Options = PureBasic 6.03 LTS (Windows - x64)
; CursorPosition = 510
; FirstLine = 510
; Folding = ----+-----------------
; Markers = 283
; EnableXP
; DPIAware
; UseIcon = _ico\icon.ico
; Executable = sho.co2.exe
; DisableDebugger