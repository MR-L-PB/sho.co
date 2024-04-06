EnableExplicit
UsePNGImageDecoder()

Global SoundSystemOK = InitSound()

If InitSprite() = 0
	MessageRequester("", "InitSprite failed", #PB_MessageRequester_Error)
	End
EndIf
InitKeyboard()
InitMouse()

#AppTitle$ = "sho.co"
#NewFileName$ = "<New>"

#NbDecimals = 4
#PROTECT_RAM = 1

CompilerIf #PB_Compiler_Debugger
	MessageRequester(#AppTitle$, "For more speed, deactivate the debugger.", #PB_MessageRequester_Info)
CompilerEndIf

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
	#m_CopyMonitor
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
	#m_Hilight
	#m_Monitor
	#m_MonitorUp
	#m_MonitorDown
	#m_NextFile
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
	#g_VarSort
	#g_VarContainer
	#g_Variables
	#g_SubContainer
	#g_Sub
	#g_SearchContainer
	#g_SearchText
	#g_SearchPrev
	#g_SearchNext
	#g_SearchOptions
	#g_Debug
	#g_Help
EndEnumeration

Enumeration ENUM_WINDOW 1
	#w_Main
	#w_Screen
	#w_Monitor
	#w_Debug
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

Enumeration	SYMBOL_TABLE_ENTRY
	#SYM_NULL
	#SYM_INT
	#SYM_FLOAT
	#SYM_CHAR
	#SYM_ARRAY
	#SYM_CONSTANT
	#SYM_STRING
	#SYM_OPCODE
	#SYM_VARIABLE
	#SYM_SUBPARAM
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
	#STATE_SILENT
	#STATE_QUIT
EndEnumeration

EnumerationBinary ENUM_READSTATE
	#READ_SUB
	#READ_PARAM
	#READ_IF
	#READ_ELSE
	#READ_LOOP
EndEnumeration

Enumeration ENUM_TOKENTYPE
	#T_UNKNOWN
	#T_DEFINE
	#T_SUB
	#T_CONSTANT
	#T_FIELD
	#T_LABEL
	#T_OPCODE
	#T_VARIABLE
	#T_INT
	#T_FLOAT
	#T_CHAR
	#T_PERIOD
	#T_NUMBER
	#T_LOOP
	#T_BRACKET_OPEN
	#T_BRACKET_CLOSE
	#T_NEWLINE
	#T_SEPARATOR
	#T_EQUAL
	#T_ELSE	
	#T_RETURN
	#T_BREAK
	#T_STRING
	#T_COMMENT
	#T_SOUND
EndEnumeration

Global Dim TokenName.s(255)
TokenName(#T_UNKNOWN) = "UNKNOWN"
TokenName(#T_OPCODE) = "OPCODE"
TokenName(#T_CONSTANT) = "CONSTANT"
TokenName(#T_VARIABLE) = "VARIABLE"
TokenName(#T_INT) = "INT"
TokenName(#T_FLOAT) = "FLOAT"
TokenName(#T_CHAR) = "CHAR"
TokenName(#T_PERIOD) = "PERIOD"
TokenName(#T_NUMBER) = "NUMBER"
TokenName(#T_SUB) = "SUB"
TokenName(#T_LABEL) = "LABEL"
TokenName(#T_BRACKET_OPEN) = "BRACKET_OPEN"
TokenName(#T_BRACKET_CLOSE) = "BRACKET_CLOSE"
TokenName(#T_NEWLINE) = "NEWLINE"
TokenName(#T_SEPARATOR) = "SEPARATOR"
TokenName(#T_EQUAL) = "EQUAL"
TokenName(#T_FIELD) = "FIELD"
TokenName(#T_ELSE) = "ELSE"
TokenName(#T_BREAK) = "BREAK"
TokenName(#T_STRING) = "STRING"
TokenName(#T_COMMENT) = "COMMENT"
TokenName(#T_SOUND) = "SOUND"

EnumerationBinary
	#Button_Left
	#Button_Right
EndEnumeration

Enumeration ENUM_OPCODE
	#OP_END = 0
	#OP_KIL
	#OP_MOV
	#OP_GET
	#OP_SET
	#OP_INT
	#OP_NTH
	#OP_CIL
	#OP_RSD
	#OP_RND
	#OP_ADD
	#OP_SUB
	#OP_MUL
	#OP_DIV
	#OP_SQR
	#OP_POW
	#OP_SHL
	#OP_SHR
	#OP_AND
	#OP__OR
	#OP_MOD
	#OP_NEG
	#OP_ABS
	#OP_MIN
	#OP_MAX
	#OP_SGN
	#OP_JMP
	#OP_JMF
	#OP_IFL
	#OP_ILO
	#OP_IGR
	#OP_ILE
	#OP_IGE
	#OP_IEQ
	#OP_INE
	#OP_GSP
	#OP_ADS
	#OP_PSH
	#OP_POP
	#OP_PUI
	#OP_POI
	#OP_PUS
	#OP_POS
	#OP_PUV
	#OP_POV
	#OP_PUF
	#OP_POF
	#OP_BMS
	#OP_BMM
	#OP_BXY
	#OP_BMO
	#OP_BMP
	#OP_PAL
	#OP_CLF
	#OP_CLB
	#OP_PLT
	#OP_SCR
	#OP_DRW
	#OP_DRS
	#OP_CLS
	#OP_INP
	#OP_KEY
	#OP_SNP
	#OP_SNS
	#OP_DLY
	#OP_DBG
	#OP_HLT
EndEnumeration

Structure KEYWORD
	type.a
	name.s
EndStructure

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
	mnemonic.s
	name.s
	ID.a
	nParams.i
	size.i
	ip.i
EndStructure

Structure ExitList
	lineNr.i
	exit_adr.i
	List adrList.i()
	adr.i
	loopDepth.i
EndStructure

Structure VARLIST
	*var.VARIABLE
	sub.s
	name.s
	type.s
	address.s
	value.s
EndStructure

Structure VARIABLE
	*sub.SUB
	*token.TOKEN
	name.s
	type.a
	key.s
	adr.i
	prevValue.d
	infoLineNr.i
	isLocal.a
	isParam.a
EndStructure

Structure CONSTANT
	type.i
	name.s
	key.s
	adr.i
	value.d
EndStructure

Structure DATASECT
	isSub.a
	isLabel.a
	isField.a
	
	*sub.SUB
	*token.TOKEN
	startAdr.i
	endAdr.i
	lineNr.i
EndStructure

Structure SUB
	name.s
	*parent.SUB
	*dataSect.DATASECT
	nrParams.i
	List *vars.VARIABLE()
	List ret.i()
	Map var.VARIABLE()
	Map sub.SUB()
EndStructure

Structure CPU
	Array RAM.d(0)						; memory
	Array VRAM.l(0)						; video ram
	IP.i                                ; instruction pointer
	SP.i                                ; stack pointer
	V.i									; V-Register
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
								  		; bit 3 and 7    param is indexed indirect address (A.B)
										; bit 2 and 6    param is indexed direct address (A.1)
										; bit 1 and 5    set = param is a pointer
										; bit 0 and 4    set = indirect address, not set = direct address
	
	RAM_Size.i                          ; size of RAM
	STACK_Size.i                        ; size of STACK
	VRAM_Size.i							; total size of Video-RAM
	
	ADR_Palette.i						; 0 = no palette (rgb values), 1 = use palette
	ADR_Color.i							; address of rgb values
	ADR_COL_Front.i						; current front color
	ADR_COL_Back.i						; current back color
	ADR_BMP_X.i							; current bmp x (command: BXY)
	ADR_BMP_Y.i							; current bmp y (command: BXY)
	ADR_BMP_W.i							; current bmp width (command: BMS)
	ADR_BMP_H.i							; current bmp height (command: BMS)
	ADR_BMP_MODE.i						; current bmp drawing mode (command: BMM)
	ADR_MOUSE_X.i
	ADR_MOUSE_Y.i
	ADR_MOUSE_B.i
	ADR_Time.i							; address of system time
	ADR_CollisionID.i					; address of collision ID
	ADR_Collision.i						; address of collision info
	ADR_StackEnd.i						; end address of stack
	ADR_StackStart.i					; start address of stack
	ADR_VarStart.i						; start address of variables
	ADR_Var.i							; current variable address
	
	wait.i                              ; delay time for DLY command
	state.i								; current state
	
	exitDepth.i							; depth of "step out"
	callDepth.i							; depth of nested calls    
	
	SCR_Active.i						; active screen
	SCR_Visible.i						; screen hidden or visible?
	SCR_Width.i							; screen height
	SCR_Height.i						; screen width
	SCR_PixelSize.d
	
	programSize.i                       ; size of program
	startTime.i
	time.i

	Map sound.i()
EndStructure

Structure PARSER
	preParse.a
	
	tokenIndex.i
	tokenCount.i
	
	code.s
	codeLineCount.i
	
	curAdrMode.i
	curIP.i
	*curSub.SUB
	*curOpcode.OPCODE
	*curLine.CODELINE
	*curField.DATASECT
	*curDataSect.DATASECT
	*curVar.VARIABLE
	*curToken.TOKEN
	curVarType.a
	
	readState.i
	stringIndex.i
	loopDepth.i
	
	Array token.Token(0)	
	
	main.SUB
	
  	Map *sub.SUB()
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

Global RamSize, StackSize
Global VarAddress.i, VarAddressMode.a, VarIndex.i
Global System.SYSTEM
Global *CPU.CPU
Global *CurrentFile.File
Global Parser.PARSER
Global Dim Opcode.OPCODE(255)
Global NewList File.FILE()
Global NewMap *Opcode.OPCODE()
Global NewMap KeyWord.KEYWORD()
Global NewMap Constant.CONSTANT()
Global MonitorVisible, Window_X = 100, Window_Y = 100
Global RunState.i
Global SCR_PixelSize = 1
Global Font = LoadFont(#PB_Any, "Consolas", 10)

Global valF1.d, valF2.d, valI1, valI2, valL.l, valA.a, valS.s, valAdr, arrIndex

Declare File_Add(path.s = "", newFile = #False)
Declare File_Open(path.s, newFile = #False, activate = #False)
Declare File_Close(*file.FILE, quit = #False, saveChanges = #True)
Declare File_Activate(*file.File, carretPos = -1, parse = #False)
Declare File_UpdateIni()
Declare System_Init(ramSize, stackSize)
Declare System_RunState(state, updateGadget = #True)
Declare System_CloseScreen(CloseScreen = #False)
Declare System_Update_Editor(*file.FILE, init = #False)
Declare System_Update_VarList(*sub.SUB, wait = #True, init = #False)
Declare System_Update_Monitor(ip, direction = 0)
Declare System_Parse(*file.FILE, parseFull = #True, run = #False)
Declare System_Error(line, message.s, warning = 0)
Declare System_VarByIP(ip)
Declare System_LineNrByIP(ip)
Declare Tokenize_Start()
Declare Parse_NextType(direction, tokenType = -1, value.s = "")
Declare Parse_IsNumber(param.s)
Declare Parse_Var(*sub.SUB, opcode, paramNr = 0, getVarType = #True, getArray = #True, isLocal = #False)
Declare Parse_Start(*file.FILE, parseFull = #True)
Declare Parse_First(*sub.SUB, readMode, depth)
Declare Parse_Main(*sub.SUB, readState, depth)
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
	CompilerIf #PROTECT_RAM
		If (ip_) < 0 Or (ip_) >= System\RAM_Size
			System_Error(System_LineNrByIP(System\prevIP), "write outside RAM: " + Str(ip_))
		Else
			If System\symTable(ip_)\type
				Select System\symTable(ip_)\type
					Case #SYM_INT: *CPU\RAM(ip_) = Int(v_)
					Case #SYM_FLOAT: *CPU\RAM(ip_) = v_
					Case #SYM_CHAR: valA = v_ : *CPU\RAM(ip_) = valA
					Default: *CPU\RAM(ip_) = Int(v_)
				EndSelect
			Else
				*CPU\RAM(ip_) = v_
			EndIf
		EndIf
	CompilerElse
		If System\symTable(ip_)\type
			Select System\symTable(ip_)\type
				Case #SYM_INT: *CPU\RAM(ip_) = Int(v_)
				Case #SYM_FLOAT: *CPU\RAM(ip_) = v_
				Case #SYM_CHAR: valA = v_ : *CPU\RAM(ip_) = valA
				Default: *CPU\RAM(ip_) = Int(v_)
			EndSelect
		Else
			*CPU\RAM(ip_) = v_
		EndIf
	CompilerEndIf
EndMacro

Macro GETVAL(ip_, v_)
	CompilerIf #PROTECT_RAM
		If (ip_) < 0 Or (ip_) >= System\RAM_Size
			System_Error(System_LineNrByIP(System\prevIP), "read outside RAM: " + Str(ip_))
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
; 		If VarIndex
; 			GETVAL(ip_ - 1, arrSize)
; 			If (VarIndex < 0 Or VarIndex > arrSize)
; 				Debug arrsize
; 				System_Error(System_LineNrByIP(ip_), "Array index: " + Str(VarIndex) + " out of bounds: " + Str(arrSize))
; 			EndIf
; 		EndIf
		w_ + VarIndex
	EndIf
	System\nextIP + 1
EndMacro

Macro GETVAL_READ(ip_, r_)
	VarAddressMode = System\adrMode & $F
	GETINDEX()
	If VarAddressMode & #ADR_INDIRECT
 		GETVAL(ip_, VarAddress)
 		
;  		If VarIndex
;  			GETVAL(VarAddress -1, arrSize)
;  			If VarIndex < 0 Or VarIndex > arrSize
;  				System_Error(System_LineNrByIP(ip_), "Array index: " + Str(VarIndex) + " out of bounds: " + Str(arrSize))
;  			EndIf
;  		EndIf

 		If VarAddressMode & #ADR_POINTER
 			GETVAL(VarAddress, VarAddress)
;  		ElseIf VarIndex
;  			GETVAL(VarAddress -1, arrSize)
;  			If VarIndex < 0 Or VarIndex > arrSize
;  				System_Error(System_LineNrByIP(ip_), "Array index: " + Str(VarIndex) + " out of bounds: " + Str(arrSize))
;  			EndIf
 		EndIf
 		VarAddress + VarIndex
 		GETVAL(VarAddress, r_)
	Else
		GETVAL(ip_, r_)
	EndIf
	System\nextIP + 1
EndMacro

Procedure DebugStack()
	Protected i
	For i = System\ADR_StackStart To *CPU\SP - 1
 		Debug MEMSTR(i - System\ADR_StackStart) + "  " + *CPU\RAM(i)
	Next
	Debug "--------"
EndProcedure

Macro PUSH(v_)
	If *CPU\SP >= System\ADR_StackEnd
		System_Error(System_LineNrByIP(*CPU\IP), "stack overflow error")
	Else
		*CPU\RAM(*CPU\SP) = v_
		*CPU\SP + 1
	EndIf
; 	DebugStack()
EndMacro

Macro POP(v_)
 	*CPU\SP - 1
	If *CPU\SP < System\ADR_StackStart
		System_Error(System_LineNrByIP(*CPU\IP), "stack underflow error")
	Else
		v_ = *CPU\RAM(*CPU\SP)
	EndIf
;	DebugStack()
EndMacro

Macro MATH_I(op_)
	GETVAL(*CPU\V, valI1)
	GETVAL_READ(System\nextIP, valI2)
	valI1 op_ valI2
	SETVAL(*CPU\V, valI1)
EndMacro

Macro MATH_F(op_)
	GETVAL_READ(System\nextIP, valF1)
	*CPU\RAM(*CPU\V) op_ valF1
EndMacro

Macro COMPARE(op_, flagTrue_, flagFalse_)
	GETVAL(*CPU\v, valF1)
	GETVAL_READ(System\nextIP, valF2)
	If valF1 op_ valF2
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

Procedure.s GetTokenName(ID)
	If ID >= 0  And ID < 255
		ProcedureReturn TokenName(ID)
	EndIf
	ProcedureReturn ""
EndProcedure

;-

Procedure.s FSTR(v.d, asFloat = 0)
	If v = Int(v)
		If asFloat
			ProcedureReturn Str(v) + ".0"
		EndIf
		ProcedureReturn Str(v)
	EndIf
	valS = RTrim(StrD(v, #NbDecimals), "0")
	If Right(valS, 1) = "."
		ProcedureReturn valS + "0"
	EndIf
	ProcedureReturn valS
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

Procedure Keyword_Add(type, name.s)
	KeyWord(UCase(name))\type = type
	KeyWord(UCase(name))\name = name
EndProcedure

Procedure Constant_Add(type, name.s, value.d)
	Protected key.s = UCase(name)
	
	If FindMapElement(Constant(), key)
		System_Error(Parser\curLine, "Constant already defined: " + name)
	ElseIf AddMapElement(Constant(), key)
		Constant()\type = type
		Constant()\value = value
		Constant()\name = name
	Else
		System_Error(Parser\curLine, "couldn't create Constant")
	EndIf
EndProcedure

;-

Procedure IDE_Init()
 	Protected *file.FILE
 	
	Protected opcode, nParams, size, mnemonic.s, name.s
	Protected text.s, param.s, paramNr
	
	Restore Opcodes:
	Repeat
		Read opcode
		Read nParams
		Read size
		
		If size
			Read.s text
			
			mnemonic = Trim(StringField(text, 1, ","))
			name = Trim(StringField(text, 2, ","))
			
			With Opcode(opcode)
				\mnemonic = mnemonic
				\name = name
				\ID = opcode
				\nParams = nParams
				\size = size
			EndWith
			
			*Opcode(UCase(name)) = @Opcode(opcode)
		EndIf
	Until size = 0
	
	For opcode = 0 To 255
		If Opcode(opcode)\name = ""
			CopyStructure(@Opcode(#OP_KIL), @Opcode(opcode), Opcode)
		EndIf
	Next
	
	Keyword_Add(#T_DEFINE, "Define")
	Keyword_Add(#T_LOOP, "Loop")
	Keyword_Add(#T_INT, "Int")
	Keyword_Add(#T_FLOAT, "Float")
	Keyword_Add(#T_CHAR, "Char")
	Keyword_Add(#T_ELSE, "Else")
	Keyword_Add(#T_RETURN, "Return")
	Keyword_Add(#T_BREAK, "Break")
	Keyword_Add(#T_SOUND, "Sound")
 	
 	Protected NewMap img()
 	img("new") = CatchImage(#PB_Any, ?ico_file_new)
 	img("open") = CatchImage(#PB_Any, ?ico_file_open)
 	img("save") = CatchImage(#PB_Any, ?ico_file_save)
 	img("close") = CatchImage(#PB_Any, ?ico_file_close)
 	img("undo") = CatchImage(#PB_Any, ?ico_undo)
 	img("redo") = CatchImage(#PB_Any, ?ico_redo)
 	img("compilerun") = CatchImage(#PB_Any, ?ico_compile_run)
 	img("compile") = CatchImage(#PB_Any, ?ico_compile)
 	img("run") = CatchImage(#PB_Any, ?ico_run)
 	img("step") = CatchImage(#PB_Any, ?ico_step)
 	img("stepout") = CatchImage(#PB_Any, ?ico_stepout)
 	img("monitor") = CatchImage(#PB_Any, ?ico_monitor)
 	img("help") = CatchImage(#PB_Any, ?ico_help)
 	img("copyMonitor") = CatchImage(#PB_Any, ?ico_copy)
 	
	OpenWindow(#w_Main, 0, 0, 800, 600, #AppTitle$ + " - Control", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_Invisible | #PB_Window_ScreenCentered)
	
	CreateImageMenu(0, WindowID(#w_Main))
	MenuTitle("File")
	MenuItem(#m_New, "New", ImageID(img("new")))
	MenuItem(#m_Open, "Open...", ImageID(img("open")))
	MenuItem(#m_Save, "Save", ImageID(img("save")))
	MenuItem(#m_SaveAs, "Save As...")
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
	ToolBarImageButton(#m_Close,ImageID(img("close"))) : ToolBarToolTip(#t_Main, #m_Close, "Close")
	ToolBarSeparator()
	ToolBarImageButton(#m_Undo, ImageID(img("undo"))) : ToolBarToolTip(#t_Main, #m_Undo, "Undo")
	ToolBarImageButton(#m_Redo, ImageID(img("redo"))) : ToolBarToolTip(#t_Main, #m_Redo, "Redo")
	ToolBarSeparator()
	ToolBarImageButton(#m_ParseRun, ImageID(img("compilerun"))) : ToolBarToolTip(#t_Main, #m_ParseRun, "Compile/Run")
	ToolBarImageButton(#m_Parse, ImageID(img("compile"))) : ToolBarToolTip(#t_Main, #m_Parse, "Compile")
	ToolBarSeparator()
	ToolBarImageButton(#m_Monitor, ImageID(img("monitor"))) : ToolBarToolTip(#t_Main, #m_Monitor, "Monitor")
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
	ListViewGadget(#g_Error, 0, 0, 800, 300)
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
	AddKeyboardShortcut(#w_Main, #PB_Shortcut_Control | #PB_Shortcut_Tab, #m_NextFile)
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
	ToolBarImageButton(#m_ParseRun, ImageID(img("compilerun"))) : ToolBarToolTip(#t_Monitor, #m_ParseRun, "Compile/Run")
	ToolBarImageButton(#m_Parse, ImageID(img("compile"))) : ToolBarToolTip(#t_Monitor, #m_Parse, "Compile")
	ToolBarSeparator()
	ToolBarImageButton(#m_Run, ImageID(img("run"))) : ToolBarToolTip(#t_Monitor, #m_Run, "Run")
	ToolBarImageButton(#m_Step, ImageID(img("step"))) : ToolBarToolTip(#t_Monitor, #m_Step, "Step")	
	ToolBarImageButton(#m_StepOut, ImageID(img("stepout"))) : ToolBarToolTip(#t_Monitor, #m_StepOut, "Step Out")
	ToolBarImageButton(#m_CopyMonitor, ImageID(img("copyMonitor"))) : ToolBarToolTip(#t_Monitor, #m_CopyMonitor, "Copy")
	
	ListIconGadget(#g_Monitor, 0, 0, 0, 0, "Address", 80, #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines | #PB_ListIcon_MultiSelect)
	AddGadgetColumn(#g_Monitor, 1, "m1", 50)
	AddGadgetColumn(#g_Monitor, 2, "m2", 50)
	AddGadgetColumn(#g_Monitor, 3, "m3", 50)
	AddGadgetColumn(#g_Monitor, 4, "Code", 1000)
	ContainerGadget(#g_VarContainer, 0, 0, 0, 0)
	ComboBoxGadget(#g_VarSort, 0, 0, 0, 0)
	
	AddGadgetItem(#g_VarSort, 0, "Subroutine")
	AddGadgetItem(#g_VarSort, 1, "Name")
	AddGadgetItem(#g_VarSort, 2, "Type")
	AddGadgetItem(#g_VarSort, 3, "Address")
	AddGadgetItem(#g_VarSort, 4, "Value")
	SetGadgetState(#g_VarSort, 0)
	
	ListIconGadget(#g_Variables, 0, 0, 0, 0, "Subroutine", 80, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_GridLines)
	CloseGadgetList()
	AddGadgetColumn(#g_Variables, 1, "Name", 80)
	AddGadgetColumn(#g_Variables, 2, "Type", 50)
	AddGadgetColumn(#g_Variables, 3, "Address", 100)
	AddGadgetColumn(#g_Variables, 4, "Value", 500)
	
	SplitterGadget(#g_SplitterMonitor, 0, 0,800, 600, #g_Monitor, #g_VarContainer, #PB_Splitter_Vertical)
	SetGadgetState(#g_SplitterMonitor, 400)
	
	StickyWindow(#w_Monitor, 1)
	AddKeyboardShortcut(#w_Monitor, #PB_Shortcut_F5, #m_ParseRun)
	AddKeyboardShortcut(#w_Monitor, #PB_Shortcut_F6, #m_Parse)
	AddKeyboardShortcut(#w_Monitor, #PB_Shortcut_Up, #m_MonitorUp)
	AddKeyboardShortcut(#w_Monitor, #PB_Shortcut_Down, #m_MonitorDown)
	
	SetGadgetFont(#g_Error, FontID(Font))
	SetGadgetFont(#g_Variables, FontID(Font))
	SetGadgetFont(#g_Monitor, FontID(Font))
	SetGadgetColor(#g_Error, #PB_Gadget_BackColor, 0)
	SetGadgetColor(#g_Error, #PB_Gadget_FrontColor, RGB(255,255,255))
	SetGadgetColor(#g_Sub, #PB_Gadget_BackColor, 0)
	SetGadgetColor(#g_Sub, #PB_Gadget_FrontColor, RGB(255,255,255))
	
	While CountGadgetItems(#g_Monitor) < 100
		AddGadgetItem(#g_Monitor, -1, "")
	Wend
	
	SetWindowState(#w_Main, #PB_Window_Maximize)
	WindowBounds(#w_Screen, #PB_Ignore, #PB_Ignore, #PB_Ignore, WindowHeight(#w_Main) - ToolBarHeight(#t_Main) - StatusBarHeight(0) - MenuHeight())	
	
	OpenWindow(#w_Debug, 0, 0, 600, 400, #AppTitle$ + " - Debug output", #PB_Window_Tool | #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_Invisible)
	EditorGadget(#g_Debug, 0, 0, 600, 400, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
	StickyWindow(#w_Debug, 1)
	SetGadgetFont(#g_Debug, FontID(Font))
	
	SetActiveWindow(#w_Main)
	
	File_Activate(*file)
	
	ForEach img()
		If IsImage(img())
			FreeImage(img())
		EndIf
	Next
	
	AddGadgetItem(#g_Error, -1, "System started") 
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
			index = GetGadgetState(#g_FilePanel) + 1
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
		
		If parse And *file\isNew = #False
			System_Parse(*file, #False, #False)
		EndIf
		Scintilla_AutoMarginWidth(*file\editor)
		SetWindowTitle(#w_Main, #AppTitle$ + " - " + *file\path)
		
		*CurrentFile = *file
	EndIf
	
	ProcedureReturn *CurrentFile
EndProcedure

Procedure File_Open(path.s, newFile = #False, activate = #False)
	Protected carret, option.s, optionName.s, optionVal.s
	Protected file, *file.FILE, *tempFile.FILE
	
	path = ReplaceString(path, "\", "/")
	
	If newFile = #False
		If path = ""
			path = OpenFileRequester("", "", "*.txt|*.txt", 1)
			If path = ""
				ProcedureReturn #Null
			EndIf
		EndIf
		
		*file = File_Find(path)
		If *file And activate
			ProcedureReturn File_Activate(*file)
		EndIf
	EndIf
	
	If newFile = 0 And FileSize(path) < 0
		MessageRequester(#AppTitle$, "File not found: " + path, #PB_MessageRequester_Error)
		ProcedureReturn #Null
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

			If *tempFile; And *tempFile\isNew
				File_Close(*tempFile)
			EndIf
			
			Scintilla_ClearUndo(*file\editor)
			Scintilla_SetSavePoint(*file\editor)
		EndIf
		
		If activate
			File_Activate(*file, carret)
			System_Parse(*file)
		EndIf
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
	
	If *tempFile
		File_Close(*tempFile, #False, #False)
	EndIf
	
	File_Activate(*file)
	
	ProcedureReturn #True
EndProcedure

Procedure File_Close(*file.FILE, quit = #False, saveChanges = #True)
	Protected index

	If *file
		File_Activate(*file)
	EndIf
	
	If *file = #Null
		ProcedureReturn 0
	EndIf
	
	If saveChanges And Scintilla_IsDirty(*file\editor)		
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
	
	If *CurrentFile = #Null
		*CurrentFile = File_Activate(GetGadgetItemData(#g_FilePanel, MAX(index - 1, 0)))
	EndIf
	
	If *file = #Null And quit = #False
		*file = File_Add("", #True)
		File_Activate(*file)
		
		Scintilla_ClearUndo(*file\editor)
	EndIf
	
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

Procedure File_Next()
	Protected index = GetGadgetState(#g_FilePanel) + 1
	If index >= CountGadgetItems(#g_FilePanel)
		index = 0
	EndIf
	File_Activate(GetGadgetItemData(#g_FilePanel, index))
EndProcedure

;-

Macro SYSTEM_INITRAM(pos_, before_ = 0, after_ = 1)
	*CPU\IP - (before_)
	System\pos_ = *CPU\IP
	*CPU\IP - (after_)
EndMacro

Macro SYSTEM_HASERROR()
	Bool(System\state & #STATE_ERROR <> 0)
EndMacro

Macro SYSTEM_NOERROR()
	Bool(System\state & #STATE_ERROR = 0)
EndMacro

Procedure System_Init(ramSize, stackSize)
	Protected i
	Protected silent = System\state & #STATE_SILENT
	
	System_CloseScreen(#True)

	ForEach System\sound()
		If IsSound(System\sound())
			FreeSound(System\sound())
		EndIf
	Next
	
	ClearMap(Constant())
	ClearStructure(System, SYSTEM)
	InitializeStructure(System, SYSTEM)
	
	System\state | silent
	
	If *CurrentFile And IsGadget(*CurrentFile\editor)
		Scintilla_ClearError(*CurrentFile\editor)
	EndIf
	
	For i = CountGadgetItems(#g_Monitor) - 1 To 0 Step -1
		SetGadgetItemText(#g_Monitor, i, "" + #LF$ + "" + #LF$ + "")
	Next
	ClearGadgetItems(#g_Sub)
	ClearGadgetItems(#g_Debug)
	ClearGadgetItems(#g_Variables)
	
	Parser\main\name  = ".main."
	AddMapElement(Parser\sub(), UCase(Parser\main\name))
	
	System\RAM_Size = ramSize + stackSize
	System\STACK_Size = stackSize
	*CPU = System\CPU

	Dim System\symTable(System\RAM_Size)
	Dim System\CPU\RAM(System\RAM_Size)
	
	*CPU\IP = RamSize
	SYSTEM_INITRAM(ADR_Palette)
	SYSTEM_INITRAM(ADR_Color, 255)
	SYSTEM_INITRAM(ADR_COL_Front)
	SYSTEM_INITRAM(ADR_COL_Back)
	SYSTEM_INITRAM(ADR_BMP_X)
	SYSTEM_INITRAM(ADR_BMP_Y)
	SYSTEM_INITRAM(ADR_BMP_W)
	SYSTEM_INITRAM(ADR_BMP_H)
	SYSTEM_INITRAM(ADR_BMP_MODE)
	SYSTEM_INITRAM(ADR_MOUSE_X)
	SYSTEM_INITRAM(ADR_MOUSE_Y)
	SYSTEM_INITRAM(ADR_MOUSE_B)
	SYSTEM_INITRAM(ADR_Time)
	SYSTEM_INITRAM(ADR_CollisionID)
	SYSTEM_INITRAM(ADR_Collision)
	SYSTEM_INITRAM(ADR_StackEnd)
	SYSTEM_INITRAM(ADR_StackStart, 255)
	SYSTEM_INITRAM(ADR_VarStart, 1)
	SYSTEM_INITRAM(ADR_Var, 8)
	
	SETVAL(System\ADR_Palette, 1)
	SETVAL(System\ADR_BMP_W, 8)
	SETVAL(System\ADR_BMP_H, 8)
	
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
	
	Constant_Add(#SYM_ADDRESS, "#PALETTE", @System\ADR_Palette)
	Constant_Add(#SYM_ADDRESS, "#FRONTCOLOR", @System\ADR_COL_Front)
	Constant_Add(#SYM_ADDRESS, "#BACKCOLOR", @System\ADR_COL_Back)
	Constant_Add(#SYM_ADDRESS, "#CHAR_W", @System\ADR_BMP_W)
	Constant_Add(#SYM_ADDRESS, "#CHAR_H", @System\ADR_BMP_H)
	Constant_Add(#SYM_ADDRESS, "#CHAR_MODE", @System\ADR_BMP_MODE)
	Constant_Add(#SYM_ADDRESS, "#MOUSE_X", @System\ADR_MOUSE_X)
	Constant_Add(#SYM_ADDRESS, "#MOUSE_Y", @System\ADR_MOUSE_Y)
	Constant_Add(#SYM_ADDRESS, "#MOUSE_B", @System\ADR_MOUSE_B)
	Constant_Add(#SYM_ADDRESS, "#TIME", @System\ADR_Time)
	Constant_Add(#SYM_VARIABLE, "#RAM", System\RAM_Size)
	Constant_Add(#SYM_VARIABLE, "#STACK", System\STACK_Size)
	Constant_Add(#SYM_CONSTANT, "#VRAM", System\VRAM_Size)
	Constant_Add(#SYM_CONSTANT, "#SCREEN_ACTIVE", System\SCR_Active)
	Constant_Add(#SYM_CONSTANT, "#SCREEN_W", System\SCR_Width)
	Constant_Add(#SYM_CONSTANT, "#SCREEN_H", System\SCR_Height)
	Constant_Add(#SYM_CONSTANT, "#COLOR", System\ADR_Color)
	Constant_Add(#SYM_CONSTANT, "#COLLISIONID", System\ADR_CollisionID)
	Constant_Add(#SYM_CONSTANT, "#COLLISION", System\ADR_Collision)
	Constant_Add(#SYM_CONSTANT, "#KEY_ESCAPE", #PB_Key_Escape)
	Constant_Add(#SYM_CONSTANT, "#KEY_LEFT", #PB_Key_Left)
	Constant_Add(#SYM_CONSTANT, "#KEY_RIGHT", #PB_Key_Right)
	Constant_Add(#SYM_CONSTANT, "#KEY_UP", #PB_Key_Up)
	Constant_Add(#SYM_CONSTANT, "#KEY_DOWN", #PB_Key_Down)
	Constant_Add(#SYM_CONSTANT, "#KEY_A", #PB_Key_Left)
	Constant_Add(#SYM_CONSTANT, "#KEY_S", #PB_Key_Right)
	Constant_Add(#SYM_CONSTANT, "#KEY_W", #PB_Key_Up)
	Constant_Add(#SYM_CONSTANT, "#KEY_Y", #PB_Key_Down)
	Constant_Add(#SYM_CONSTANT, "#KEY_Z", #PB_Key_Down)
	Constant_Add(#SYM_CONSTANT, "#KEY_SPACE", #PB_Key_Space)
	Constant_Add(#SYM_CONSTANT, "#KEY_CONTROL", #PB_Key_LeftControl)
	Constant_Add(#SYM_CONSTANT, "#KEY_RETURN", #PB_Key_Return)
	Constant_Add(#SYM_CONSTANT, "#BLACK", #Black)
	Constant_Add(#SYM_CONSTANT, "#MAGENTA", #Magenta)
	Constant_Add(#SYM_CONSTANT, "#BLUE", #Blue)
	Constant_Add(#SYM_CONSTANT, "#GREEN", #Green)
	Constant_Add(#SYM_CONSTANT, "#CYAN", #Cyan)
	Constant_Add(#SYM_CONSTANT, "#RED", #Red)
	Constant_Add(#SYM_CONSTANT, "#ORANGE", RGB(255,128,0))
	Constant_Add(#SYM_CONSTANT, "#YELLOW", #Yellow)
	Constant_Add(#SYM_CONSTANT, "#GRAY", RGB(128,128,128))
	Constant_Add(#SYM_CONSTANT, "#WHITE", #White)
	Constant_Add(#SYM_CONSTANT, "#EQ", #FLAG_EQUAL)
	Constant_Add(#SYM_CONSTANT, "#NE", #FLAG_NOTEQUAL)
	Constant_Add(#SYM_CONSTANT, "#GR", #FLAG_GREATER)
	Constant_Add(#SYM_CONSTANT, "#LO", #FLAG_LOWER)
	
	System\CPU\IP = 0
	System\CPU\SP = System\ADR_StackStart
	System\SCR_PixelSize = 1
	System\startTime = ElapsedMilliseconds()
EndProcedure

Procedure System_Start(ramSize_, stackSize_)
	Protected *file.FILE
	Protected path.s, currentFile.s, index
	
	RamSize = ramSize_
	StackSize = stackSize_
	
	System_Init(RamSize, StackSize)
	
	System\state | #STATE_SILENT
	If OpenPreferences("Settings.ini")
		currentFile = ReadPreferenceString("CURRENTFILE", "")
		Repeat
			path = ReadPreferenceString("FILE" + Str(index), "")
			If currentFile And path = currentFile
				*file = File_Open(path)
			ElseIf path
				File_Open(path, #False, #True)
			EndIf
			index + 1
		Until path = ""
		ClosePreferences()
	EndIf
	
	If *file = #Null
		*file = File_Add()		
	EndIf
	
	File_Activate(*file, -1, #True)
	System\state & ~#STATE_SILENT
	
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
			
			If (previousState & #STATE_RUN) = 0
				AddGadgetItem(#g_Error, -1, TIMESTR() + "   program started") 
			EndIf
		Else
			SetToolBarButtonState(#t_Main, #m_Run, 0)
			StatusBarText(0, 1, "Stopped", #PB_StatusBar_Center)
			If System\SCR_Visible = #False
				System\SCR_Visible = #False
				HideWindow(#w_Screen, 1)
			EndIf
			If previousState & #STATE_RUN
				AddGadgetItem(#g_Error, -1, TIMESTR() + "   program stopped")
			EndIf
			If SoundSystemOK
				StopSound(#PB_All)
			EndIf
		EndIf
		
		If RunState & #STATE_STEP
			SetToolBarButtonState(#t_Main, #m_Step, 1)
			
			If updateGadget
				System_Update_VarList(Parser\main, #False)
				If MonitorVisible
					System_Update_Monitor(*CPU\IP)
				EndIf
			EndIf

			System\wait = -1
			
			If previousState & #STATE_STEP = 0
				AddGadgetItem(#g_Error, -1, TIMESTR() + "   program paused")
			EndIf
		Else
			SetToolBarButtonState(#t_Main, #m_Step, 0)
			
			If previousState & #STATE_STEP
				AddGadgetItem(#g_Error, -1, TIMESTR() + "   program continued")
			EndIf
		EndIf
		
		SetGadgetState(#g_Error, CountGadgetItems(#g_Error) - 1)
	EndIf
EndProcedure

Procedure System_Collect_Variables(*sub.SUB, List varList.VARLIST())
	If *sub
		ForEach *sub\var()
			AddElement(varList())
			varList()\var = *sub\var()
			varList()\sub = *sub\name
			varList()\name = *sub\var()\name
			Select *sub\var()\type
				Case #SYM_INT: varList()\type = "int"
				Case #SYM_FLOAT: varList()\type = "float"
				Case #SYM_CHAR: varList()\type = "char"
				Case #SYM_ARRAY: varList()\type = "array"
				Default: varList()\type = "?"
			EndSelect
			varList()\address = MEMSTR(*sub\var()\adr)
			varList()\value = FSTR(*CPU\RAM(*sub\var()\adr))
		Next
		
		ForEach *sub\sub()
			System_Collect_Variables(*sub\sub(), varList())
		Next
	EndIf
EndProcedure

Procedure System_Update_SubList()
	Protected index
	Protected NewList subList.DATASECT()
	
	ForEach Parser\datasect()
		If Parser\datasect()\isSub
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
	
; 	ForEach Parser\field()
;  		AddGadgetItem(#g_Sub, index, TokenText(Parser\field()\token))
;  		SetGadgetItemData(#g_Sub, index, Parser\field()\lineNr)
;  		index + 1
; 	Next
EndProcedure

Procedure System_Update_VarList(*sub.SUB, wait = #True, init = #False)
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
		Protected NewList varList.VARLIST(), subName.s, startIndex
		System_Collect_Variables(*sub, varList())
		
		Select GetGadgetState(#g_VarSort)
			Case 0
				SortStructuredList(varList(), #PB_Sort_Ascending, OffsetOf(VARLIST\sub), #PB_String)
				If FirstElement(varList())
					subName = varList()\sub
					startIndex = 0
					While NextElement(varList())
						If subName <> varList()\sub
							PushListPosition(varList())
							SortStructuredList(varList(), #PB_Sort_Ascending, OffsetOf(VARLIST\name), #PB_String, startIndex, ListIndex(varList()) - 1)
							PopListPosition(varList())
							subName = varList()\sub
							startIndex = ListIndex(varList())
						EndIf
					Wend
					SortStructuredList(varList(), #PB_Sort_Ascending, OffsetOf(VARLIST\name), #PB_String, startIndex, ListSize(varList()) - 1)
					subName = varList()\sub
				EndIf
			Case 1
				SortStructuredList(varList(), #PB_Sort_Ascending, OffsetOf(VARLIST\name), #PB_String)
			Case 2
				SortStructuredList(varList(), #PB_Sort_Ascending, OffsetOf(VARLIST\type), #PB_String)
			Case 3
				SortStructuredList(varList(), #PB_Sort_Ascending, OffsetOf(VARLIST\address), #PB_String)
			Case 4
				SortStructuredList(varList(), #PB_Sort_Ascending, OffsetOf(VARLIST\value), #PB_String)
		EndSelect
		
		ClearGadgetItems(#g_Variables)
		
		lineNr = 0
		ForEach varList()
			With varList()\var
				\infoLineNr = lineNr
				
				AddGadgetItem(#g_Variables, lineNr, varList()\sub)
				SetGadgetItemText(#g_Variables, lineNr, varList()\name, 1)
				SetGadgetItemText(#g_Variables, lineNr, varList()\type, 2)
				SetGadgetItemText(#g_Variables, lineNr, varList()\address, 3)
				SetGadgetItemText(#g_Variables, lineNr, FSTR(*CPU\RAM(\adr)), 4)
				
				If varList()\var\isLocal
					SetGadgetItemColor(#g_Variables, lineNr, #PB_Gadget_BackColor, RGB(255, 245, 230), 1)
				EndIf
				If varList()\var\isParam
					SetGadgetItemColor(#g_Variables, lineNr, #PB_Gadget_BackColor, RGB(255, 225, 210), 1)
				EndIf
				
				SetGadgetItemData(#g_Variables, lineNr, varList()\var)
				lineNr + 1
			EndWith
		Next
		
		ProcedureReturn #True
		
	Else
		ForEach *sub\var()
			With *sub\var()
				GETVAL(\adr, value)
				If \prevValue <> value Or \adr = VarAddress
					\prevValue = value
					SetGadgetItemText(#g_Variables, \infoLineNr, FSTR(value), 4)
					If \adr = VarAddress
						SetGadgetState(#g_Variables, \infoLineNr)
					EndIf
					valueChanged = #True
				EndIf
			EndWith    
		Next		
	EndIf
	
	ProcedureReturn valueChanged
EndProcedure

Procedure System_Update_Monitor(ip, direction = 0)
	Protected curIP, varIP, prevIP
	Protected paramNr, adr, op.a, opIP, index, isData, lineNr = -1
	Protected *opcode.OPCODE, *var.VARIABLE, *sym.SYMTABLE
	Protected code.s, varIndex.s
	Protected lineCount = CountGadgetItems(#g_Monitor) - 1
	
	For index = 0 To lineCount
		SetGadgetItemText(#g_Monitor, index, "" + #LF$ + "" + #LF$ + "" + #LF$ + "" + #LF$ + "")
		SetGadgetItemData(#g_Monitor, index, 0)
		SetGadgetItemColor(#g_Monitor, index, #PB_Gadget_BackColor, #PB_Default)
	Next
	If System\programSize <= 0
		ProcedureReturn
	EndIf
	
	curIP = CLAMP(*CPU\IP, 0, System\programSize)
	If 1;direction
		While ((direction < 0 And curIP > 0) Or (curIP < System\programSize)) And System\symTable(curIP)\type <> #SYM_OPCODE
			curIP + direction
		Wend
		
		Protected skipOp = 10
		While *CPU\IP > 0
			If System\symTable(*CPU\IP)\type = #SYM_OPCODE
				If skipOp = 0
					Break
				Else
					skipOp - 1
				EndIf
			EndIf
			*CPU\IP - 1
		Wend
	EndIf
	
	index = 0
	Repeat
		prevIP = *CPU\IP
		adr = *CPU\RAM(*CPU\IP)
		*sym = @System\symTable(*CPU\IP)
		
		isData = #False
		ForEach Parser\dataSect()
			With Parser\dataSect()
				If \startAdr = *CPU\IP
					If \isLabel
						SetGadgetItemText(#g_Monitor, index, TokenText(\token))
						SetGadgetItemData(#g_Monitor, index, \lineNr)
						index + 1
					EndIf
					If \isField
						If *CPU\IP >= Parser\dataSect()\startAdr And *CPU\IP < Parser\dataSect()\endAdr
							isData = #True
						EndIf
						
						SetGadgetItemText(#g_Monitor, index, TokenText(\token))
						SetGadgetItemData(#g_Monitor, index, \lineNr)
						SetGadgetItemColor(#g_Monitor, index, #PB_Gadget_BackColor, RGB(250, 250, 235), 0)
						index + 1
					EndIf
					If \isSub
						SetGadgetItemText(#g_Monitor, index, TokenText(\token))
						SetGadgetItemData(#g_Monitor, index, \lineNr)
						SetGadgetItemColor(#g_Monitor, index, #PB_Gadget_BackColor, RGB(250, 235, 235), 0)
						index + 1
					EndIf
				EndIf
			EndWith
		Next
		
		op = adr & $FF
		opIP = *CPU\IP
		*opcode = @Opcode(op)
		System\adrMode = (adr >> 8) & $FF
		
		*CPU\IP + 1
		
		code = *opcode\mnemonic + " "
				
		For paramNr = 0 To *opcode\nParams - 1
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
				If *sym\type = #SYM_SUBPARAM
					*var = System_VarByIP(*CPU\IP)
					If *var
						code + "[SP" + " + " + Str(*var\adr) + "]"
					Else
						code + "[SP???]"
					EndIf
				ElseIf *sym\token
					code + TokenText(*sym\token)
				Else
					code + FSTR(*CPU\RAM(*CPU\IP))
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
			Case #OP_IFL, #OP_IGR, #OP_ILO, #OP_IGE, #OP_ILE, #OP_IEQ, #OP_INE
				SetGadgetItemText(#g_Monitor, index, FSTR(*CPU\RAM(*CPU\IP)), 3)
				code + FSTR(*CPU\RAM(*CPU\IP))
				*CPU\IP + 1
		EndSelect
		
		SetGadgetItemText(#g_Monitor, index, MEMSTR(prevIP), 0)
		For paramNr = 0 To *CPU\IP - prevIP - 1
			SetGadgetItemText(#g_Monitor, index, FSTR(*CPU\RAM(prevIP + paramNr)), 1 + paramNr)
			If prevIP + paramNr = curIP
				SetGadgetItemColor(#g_Monitor, index, #PB_Gadget_BackColor, RGB(235,235,235), 1 + paramNr)
			EndIf
		Next
		
		SetGadgetItemText(#g_Monitor, index, code , 4)
		SetGadgetItemData(#g_Monitor, index, System_LineNrByIP(opIP))
		
		If isData
			SetGadgetItemColor(#g_Monitor, index, #PB_Gadget_BackColor, RGB(250, 250, 235), 4)
		EndIf
		
		If lineNr = -1 : lineNr = index : EndIf
		index + 1
	Until *CPU\IP >= System\programSize Or index >= lineCount
	
	*CPU\IP = curIP
EndProcedure

Procedure System_GotoLine(lineNr)
	If *CurrentFile And IsGadget(*CurrentFile\editor)
		Scintilla_SetCursorPosition(*CurrentFile\editor, lineNr, 0)
	EndIf
EndProcedure
	
Procedure System_Variable_Change(*var.VARIABLE)
	If *var
		Protected value.s, curVal.d
		GETVAL(*var\adr, curVal)
		value.s = InputRequester(#AppTitle$, "Variable: " + *var\name, FSTR(curVal))
		If value <> "" And Parse_IsNumber(value)
			curVal = ValD(value)
			SETVAL(*var\adr, curVal)
			
			System_Update_VarList(Parser\main, #False)
			System_Update_Monitor(*CPU\IP)
		EndIf
	EndIf
EndProcedure

Procedure System_Parse(*file.FILE, parseFull = #True, run = #False)
	Protected result = #False
	If *file
		ClearStructure(Parser, PARSER)
		InitializeStructure(Parser, PARSER)
		
		result = Parse_Start(*file, parseFull)
		
		If run
			System_RunState(RunState | #STATE_RUN)
		EndIf
	EndIf
	ProcedureReturn result
EndProcedure

Procedure System_Error(line, message.s, warning = 0)
	If (System\state & #STATE_SILENT)
		ProcedureReturn
	EndIf
	
	Protected index = CountGadgetItems(#g_Error)
	Protected errLine = line
	
	If SYSTEM_NOERROR()
		If line >= 0
			errLine = Max(line - 1 , 0)
			Protected text.s = "Line " + Str(line + 1) + ": " + message
			AddGadgetItem(#g_Error, index, TIMESTR() + "   " + text) 
			If *CurrentFile
				If warning = 0
					Scintilla_SetErrorLine(*CurrentFile\editor, errLine, text)
				EndIf
				Scintilla_SetCursorPosition(*CurrentFile\editor, errLine, 0)
				Scintilla_Scroll(*CurrentFile\editor, -2)
				SetActiveGadget(*CurrentFile\editor)
			EndIf
		Else
			AddGadgetItem(#g_Error, index, TIMESTR() + "   " + message) 
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
			WebGadget(#g_Help, 5, 5, 790, 590, GetCurrentDirectory() + "_help\help.html")
			SetGadgetAttribute(#g_Help, #PB_Web_NavigationCallback, @Help_Callback())
			SetGadgetAttribute(#g_Help, #PB_Web_BlockPopupMenu, 1)
			SetGadgetAttribute(#g_Help, #PB_Web_BlockPopups, 1)
		EndIf
	EndIf
EndProcedure

Procedure System_Quit()
	System_RunState(0)
	
	While LastElement(File())
		If File_Close(File(), #True) = #PB_MessageRequester_Cancel
			ProcedureReturn #False
		EndIf
	Wend
	
	System\state | #STATE_QUIT
EndProcedure

;-

Procedure Parse_WriteF(value.d, ip = -1, varType = #SYM_FLOAT)
	If Parser\preParse
		ProcedureReturn #True
	EndIf
	
	Protected lineNr
	
	If ip = -1
		lineNr = Parser\curLine
		ip = *CPU\IP
		*CPU\IP + 1
	Else
		lineNr = System_LineNrByIP(ip)
	EndIf
	
	SETVAL(ip, value)		
	If SYSTEM_NOERROR()
		System\symTable(ip)\type = varType
		System\symTable(ip)\lineNr = lineNr
		ProcedureReturn #True
	EndIf
		
	ProcedureReturn #False
EndProcedure

Procedure Parse_WriteI(value, type, *token.TOKEN = #Null, ip = -1)
	Protected lineNr
	
	If Parser\preParse And ip = -1
		ProcedureReturn #True
	EndIf
	
	If ip = -1
		lineNr = Parser\curLine
		ip = *CPU\IP
		*CPU\IP + 1
	Else
		lineNr = System_LineNrByIP(ip)
	EndIf
	
	SETVAL(ip, value)
	If SYSTEM_NOERROR()
		System\symTable(ip)\type = type
		System\symTable(ip)\token = *token
		System\symTable(ip)\lineNr = lineNr
		System\symTable(ip)\var = Parser\curVar
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

Procedure Parse_IsMainSub(*sub.SUB)
	If *sub\parent = #Null
		; the main sub has no parent
		ProcedureReturn #True
	EndIf
	ProcedureReturn #False
EndProcedure
	
Procedure Parse_AddVar(*sub.SUB, name.s, varType.a, *token, isLocal = #False)
	Protected key.s = UCase(name)

	; does the variable already exist in the local variable Map?
	Parser\curVar = FindMapElement(*sub\var(), key)
	If Parser\curVar = #Null	
		
		If isLocal = #False And Parse_IsMainSub(*sub) = #False
			; does the variable already exist in the global variable Map?
			Parser\curVar = FindMapElement(Parser\main\var(), key)
		EndIf
		
		If Parser\curVar = #Null
			; variable does not exist -> create new one
			Parser\curVar = AddMapElement(*sub\var(), key)
			If Parser\curVar
				LastElement(*sub\vars())
				AddElement(*sub\vars())
				*sub\vars() = Parser\curVar
				
				Parser\curVar\token = *token
				Parser\curVar\sub = *sub
				Parser\curVar\name = name
				Parser\curVar\type = varType
				Parser\curVar\adr = System\ADR_Var
				
				If Parse_IsMainSub(*sub)
					Parser\curVar\isLocal = #False
;   					Debug MEMSTR(System\ADR_Var) + "   " + LSet(*sub\name, 25) + LSet(name, 25) + LSet(Str(varType), 4) + ": new Global var"
				Else
					Parser\curVar\isLocal = isLocal
;   					Debug MEMSTR(System\ADR_Var) + "   " + LSet(*sub\name, 25) + LSet(name, 25) + LSet(Str(varType), 4) + ": new Local var"
 				EndIf
 				
 				System\symTable(System\ADR_Var)\token = *token
 				System\symTable(System\ADR_Var)\var = Parser\curVar
 				System\symTable(System\ADR_Var)\type = varType
 				
 				System\ADR_Var - 1
 				
			EndIf
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
			If type = #SYM_SUB
				\isSub = #True
			ElseIf type = #SYM_FIELD
				\isField = #True
			ElseIf type = #SYM_LABEL
				\isLabel = #True
			EndIf
			\token = *token
			\startAdr = adr
			\endAdr = adr
			\lineNr = lineNr
		EndWith
	EndIf
	ProcedureReturn Parser\curDataSect
EndProcedure

Procedure Parse_AddReference(type, *sub.SUB, *token.TOKEN, typeName.s, lineNr)
	Protected *reference.DATASECT = AddElement(Parser\reference())
	
	If *reference = #Null
		System_Error(Parser\codeLineCount, "couldn't create " + typeName + "reference")
	Else
		If type = #SYM_SUB
			*reference\isSub = #True
		ElseIf type = #SYM_FIELD
			*reference\isField = #True
		ElseIf type = #SYM_LABEL
			*reference\isLabel = #True
		EndIf
		*reference\sub = *sub
		*reference\token = *token
		*reference\startAdr = *CPU\IP
		*reference\lineNr = lineNr
		Parse_WriteI(0, type, *token) ; place holder for address, the real address will be written at end of parse process.
	EndIf
	ProcedureReturn *reference
EndProcedure

Procedure Parse_AddBracket()
	LastElement(Parser\bracketList())
	If AddElement(Parser\bracketList())
		Parser\bracketList()\lineNr = Parser\curLine
	EndIf
EndProcedure

Procedure Parse_SetAddressMode(paramNr, adrMode.a)
	Protected opcode

	GETVAL(Parser\curIP, opcode)
	If paramNr <= 0
		opcode | (adrMode << 8)
	ElseIf paramNr = 1
		opcode | (adrMode << 12)
	Else
		System_Error(Parser\codeLineCount, "Parse_SetAddressMode: wrong paramNr: " + Str(paramNr))
	EndIf
	
	Parser\curAdrMode | adrMode
	SETVAL(Parser\curIP, opcode)
EndProcedure

Procedure Parse_AddSound(*variable.VARIABLE, path.s)
	Protected key.s = UCase(Parser\curVar\name)
	
	If FindMapElement(System\sound(), key) 
		SETVAL(*variable\adr, System\sound())
	ElseIf AddMapElement(System\sound(), key)
		System\sound() = LoadSound(#PB_Any, path)
		If IsSound(System\sound())
			SETVAL(*variable\adr, System\sound())
		Else
			System_Error(Parser\curLine, "sound not loaded: "+ path, #True)
		EndIf
	Else
		System_Error(Parser\curLine, "Parse_AddSound: couldn't add Map element")
	EndIf
EndProcedure

Procedure.s Parser_TokenText(*token.TOKEN)
	If *token
		ProcedureReturn Mid(Parser\code, *token\position, *token\length)
	EndIf
EndProcedure

Procedure Parse_Token(*sub.SUB, *token.TOKEN, paramNr = 0, createNew = 0, isLocal = #False)
	Protected value, address
	Protected text.s, uText.s, key.s, adrMode
	
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
	text = LTrim(text, "#")	   ; Constant
	uText = UCase(text)
	adrMode = Asc(*token\text)
	
;   	Debug "SUB:" + RSet(*sub\name, 8) + "    token: " + RSet(TokenText(*token), 8) + " type: " + RSet(GetTokenName(*token\type), 12) + "   paramNr Nr.: " + Str(paramNr)
	
	;If FindMapElement(Parser\sub(), key)
		
	
	If *token\type = #T_SUB
		
		If createNew
			
			Parser\curSub = FindMapElement(*sub\sub(), key)
			If Parser\preParse
				If Parser\curSub
					System_Error(Parser\codeLineCount, "Sub already defined: " + text)
				Else
					Parser\curSub = AddMapElement(*sub\sub(), key)
					If Parser\curSub = #Null
						System_Error(Parser\codeLineCount, "couldn't create Sub: " + text)
					Else
						Parser\curSub\dataSect = Parse_AddDataSect(#SYM_SUB, *token, *CPU\IP, Parser\codeLineCount)
						Parser\curSub\name = text
						Parser\curSub\parent = *sub
					EndIf
				EndIf
			ElseIf Parser\curSub
				Parser\curDataSect = Parser\curSub\dataSect
				Parser\curDataSect\startAdr = *CPU\IP
				Parser\curDataSect\endAdr = *CPU\IP
				Parser\curDataSect\lineNr = Parser\codeLineCount
			Else
				System_Error(Parser\codeLineCount, "Sub not defined: " + text)
			EndIf
			
		Else

			Parse_SetAddressMode(paramNr, #ADR_DIRECT)
			Parse_AddReference(#SYM_SUB, *sub, *token, "Sub", Parser\codeLineCount)
			
		EndIf
		
	ElseIf *token\type = #T_FIELD
		
		If createNew
			
			Parser\curField = FindMapElement(Parser\field(), key)
			If Parser\preParse
				If Parser\curField
					System_Error(Parser\codeLineCount, "Field already defined: " + text)
				Else
					Parser\curField = AddMapElement(Parser\field(), key)
					If Parser\curField = #Null
						System_Error(Parser\codeLineCount, "couldn't create Field: " + text)
					Else
						Parser\field() = Parse_AddDataSect(#SYM_FIELD, *token, *CPU\IP, Parser\codeLineCount)
					EndIf
				EndIf
			ElseIf Parser\curField
				Parser\curDataSect = Parser\field()
				Parser\curDataSect\startAdr = *CPU\IP
				Parser\curDataSect\endAdr = *CPU\IP
				Parser\curDataSect\lineNr = Parser\codeLineCount
			Else
				System_Error(Parser\codeLineCount, "Field not defined: " + text)
			EndIf
			
		Else
			
			Parse_SetAddressMode(paramNr, #ADR_DIRECT)
			Parse_AddReference(#SYM_FIELD, *sub, *token, "Field", Parser\codeLineCount)
			
		EndIf
		
	ElseIf *token\type = #T_LABEL
		
		If createNew
			
			If FindMapElement(Parser\label(), key)
				System_Error(Parser\codeLineCount, "Label already defined: " + text)
			ElseIf AddMapElement(Parser\label(), key) = 0
				System_Error(Parser\codeLineCount, "couldn't create Label: " + text)
			Else
				Parser\label() = Parse_AddDataSect(#SYM_LABEL, *token, *CPU\IP, Parser\codeLineCount)
			EndIf
			
		Else
			
			Parse_SetAddressMode(paramNr, #ADR_DIRECT)
			Parse_AddReference(#SYM_LABEL, *sub, *token, "Label", Parser\codeLineCount)
			
		EndIf
		
	ElseIf adrMode = '#' ; param is a CONSTANT
		
		If FindMapElement(Constant(), key)
			If Constant()\type = #SYM_ADDRESS
				Parse_SetAddressMode(paramNr, #ADR_INDIRECT)
				Parse_WriteI(PeekI(Constant()\value), #SYM_CONSTANT, *token)
			Else
				Parse_SetAddressMode(paramNr, #ADR_DIRECT)
				Parse_WriteI(Constant()\value, #SYM_CONSTANT, *token)
			EndIf
		Else
			System_Error(Parser\codeLineCount, "Unknown constant: " + text)
		EndIf
					
	ElseIf *token\type = #T_NUMBER
		
		Parse_SetAddressMode(paramNr, #ADR_DIRECT)
		Parse_WriteF(*token\value)
		
	ElseIf *token\type = #T_STRING
		
		Parse_SetAddressMode(paramNr, #ADR_DIRECT)
		Parse_WriteI(*token, #SYM_INT)
		
	ElseIf *token\type = #T_VARIABLE
		
		If Parse_AddVar(*sub, text, Parser\curVarType, *token, isLocal)
			Select adrMode
				Case '@'
					; param is a the ADDRESS of a variable
					Parse_SetAddressMode(paramNr, #ADR_DIRECT)
 					Parse_WriteI(Parser\curVar\adr, #SYM_ADDRESS, *token)
				Case '!'
					; param is a value read from a pointer
					Parse_SetAddressMode(paramNr, #ADR_POINTER | #ADR_INDIRECT)
					Parse_WriteI(Parser\curVar\adr, #SYM_VARIABLE, *token)
				Default
					; param is a normal variable
					Parse_SetAddressMode(paramNr, #ADR_INDIRECT)
					Parse_WriteI(Parser\curVar\adr, #SYM_VARIABLE, *token)
			EndSelect
		EndIf
		
; 	ElseIf *token\type = #T_STRING
; 		
; 		Protected i
; 		Parser\stringIndex + 1
; 		SETVAL(System\ADR_Var, *token\length - 2)
; 		System\ADR_Var - 1
; 		For i = 0 To *token\length - 3
; 			SETVAL(System\ADR_Var, Asc(Mid(Parser\code, *token\position + i + 1, 1)))
; 			System\ADR_Var - 1
; 		Next
; 		
; 		If Parse_AddVar(*sub, "STR_" + Str(Parser\stringIndex), #SYM_CHAR, *token)
; 			Parse_SetAddressMode(paramNr, #ADR_INDIRECT)
; 			Parse_WriteI(Parser\curVar\adr, #SYM_STRING)
; 		EndIf
		
	Else
		
		System_Error(Parser\codeLineCount, "unknown token type: " + Str(*token\type) + "  text: '" + Parser_TokenText(*token) + "'")
		
	EndIf
	
	If SYSTEM_HASERROR()
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
	Protected lastIndex
	
	lastIndex = Parser\tokenCount
	
	Parser\curToken = #Null
			
	While index < lastIndex And SYSTEM_NOERROR()
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
					System_Error(Parser\curLine, "Syntax Error - expected '" + GetTokenName(type) + "'")
				EndIf
				Break
		EndSelect
	Wend
	
	If SYSTEM_HASERROR() Or Parser\curToken = #Null
		Parser\codeLineCount = prevLineNr
		ProcedureReturn #Null
	EndIf
	
	ProcedureReturn Parser\curToken
EndProcedure

Procedure Parse_VarType(*sub.SUB)
	If Parse_NextToken(#T_INT) 
		Parser\curVarType = #SYM_INT
	ElseIf Parse_NextToken(#T_FLOAT) 
		Parser\curVarType = #SYM_FLOAT
	ElseIf Parse_NextToken(#T_CHAR) 
		Parser\curVarType = #SYM_CHAR
	Else
		Parser\curVarType = #SYM_INT
		ProcedureReturn #False
	EndIf
	ProcedureReturn #True
EndProcedure

Procedure Parse_SubVar(*sub.SUB, *var.VARIABLE, opcode)
	opcode | (#ADR_INDIRECT << 8)
	Parser\curIP = *CPU\IP
	Parser\curVarType  = *var\type
	Parse_WriteI(opcode, #SYM_OPCODE)
	Parse_Token(*sub, *var\token, 0, 0, #True)
	SETVAL(Parser\curIP, opcode)
EndProcedure

Procedure Parse_FindSub(*sub.SUB, key.s)
	Protected *childSub.SUB
	If *sub
		*childSub = FindMapElement(*sub\sub(), key)
		If *childSub = #Null
			ProcedureReturn Parse_FindSub(*sub\parent, key)
		EndIf
	EndIf
	ProcedureReturn *childSub
EndProcedure

Procedure Parse_Sub(*sub.SUB, readState)
	Protected *childSub.SUB
	Protected *token.TOKEN
	Protected nSubParams, prevIP
		
	*childSub = Parse_FindSub(*sub, UCase(TokenText(Parser\curToken)))
	If *childSub = #Null
		System_Error(Parser\curLine, "Sub not defined: '" + TokenText(Parser\curToken) + "'")
	Else
		*token = Parser\curToken
		nSubParams = 0
		
		If (*sub = *childSub) And (readState & #READ_SUB)
			; if recursive call - > save current variables (push them on the stack)
			ForEach *childSub\vars()
				Parse_SubVar(*childSub, *childSub\vars(), #OP_PSH)
			Next
		EndIf
		
		Parse_WriteI(#OP_PSH, #SYM_OPCODE) ; push
		Parse_WriteI(0, #SYM_INT)		   ; placeholder for return address 
		
		prevIP = *CPU\IP - 1
; 		Parse_WriteI(#OP_PUV, #SYM_OPCODE) ; push current V-Register
		
		nSubParams = *childSub\nrParams
		While nSubParams And Parse_NextToken()
			Parser\curIP = *CPU\IP
			Parser\curAdrMode = 0
			
			If Parser\curToken\type = #T_VARIABLE
				Parse_Var(*sub, #OP_PSH, 0, #True, #False)
			Else
				Parse_WriteI(#OP_PSH, #SYM_OPCODE)
				Parse_Token(*sub, Parser\curToken)
			EndIf
			
			nSubParams - 1
		Wend
		
		If nSubParams > 0
			System_Error(Parser\curLine, "Missing parameter")
		ElseIf nSubParams < 0
			System_Error(Parser\curLine, "Too many parameters")
		Else
			
			;Parse_WriteI(#OP_CAL, #SYM_OPCODE)
			Parse_WriteI(#OP_JMP, #SYM_OPCODE)
			Parse_Token(*sub, *token)
			
			SETVAL(prevIP,  *CPU\IP) ; write return address
			
			If (*sub = *childSub) And (readState & #READ_SUB)
				; if recursive call - > restore current variables
				If LastElement(*childSub\vars())
					Repeat
						Parse_SubVar(*childSub, *childSub\vars(), #OP_POP)
					Until PreviousElement(*childSub\vars()) = #Null
				EndIf
			EndIf
			
		EndIf
	EndIf
	
EndProcedure

Procedure Parse_Field(*sub.SUB)
	Protected i, value.d
	Protected currentLine, fieldSize
	Protected *dataSect.DATASECT
	
	currentLine = Parser\codeLineCount
	
	If Parse_Token(*sub, Parser\curToken, 0, #True)
		*dataSect = Parser\curDataSect
		If Parse_NextToken(#T_BRACKET_OPEN, #True)
			While SYSTEM_NOERROR() And Parse_NextToken()
				Select Parser\curToken\type
					Case #T_BRACKET_CLOSE
						*dataSect\endAdr = *CPU\IP
						ProcedureReturn #True
					Case #T_NUMBER
						value = Parser\curToken\value
						If Parse_NextToken(#T_OPCODE)
							If Parser\curToken\opcode\ID <> #OP_MUL
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
						; e.g.:  DAT ("123")  - allocate 4 slots with the values 49, 50, 51, 0 (ascii values of 1,2,3 and 0 as string terminator)
						For i = 1 To Parser\curToken\length - 2
							value = Asc(Mid(Parser\code, Parser\curToken\position + i, 1))
							If Parse_WriteI(value, #SYM_CHAR)
								fieldSize + 1
							Else
								ProcedureReturn #False
							EndIf
						Next
						; write '0' as string terminator
						If Parse_WriteI(0, #SYM_CHAR)
							fieldSize + 1
						Else
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

Procedure Parse_Var(*sub.SUB, opcode, paramNr = 0, getVarType = #True, getArray = #True, isLocal = #False)
	Protected *curToken.TOKEN = Parser\curToken
	Protected arrSize = -1, i
	
	If opcode
		Parse_WriteI(opcode, #SYM_OPCODE)
	EndIf
	
	If getVarType
		Parse_VarType(*sub)
	EndIf
	
	If Parse_NextToken(#T_PERIOD) ; it's an indexed variable
		If Parse_NextToken(#T_NUMBER)
			Parse_SetAddressMode(paramNr, #ADR_INDX_DI)
			Parse_WriteI(Parser\curToken\value, #SYM_INT, Parser\curToken)
		ElseIf Parse_NextToken(#T_VARIABLE)
			If Parse_Token(*sub, Parser\curToken, paramNr, 0, isLocal)
				Parse_SetAddressMode(paramNr, #ADR_INDX_IN)
			EndIf
		Else
			System_Error(Parser\codeLineCount, "wrong index type")
			ProcedureReturn #False
		EndIf
	EndIf
	
	If getArray And Parse_NextToken(#T_BRACKET_OPEN)
		If Parse_NextToken(#T_NUMBER) Or Parse_NextToken(#T_CONSTANT, #True)
			If parser\curToken\type = #T_NUMBER
				arrSize = Parser\curToken\value
			ElseIf parser\curToken\type = #T_CONSTANT
				If FindMapElement(Constant(), UCase(Parser\curToken\text))
					arrSize = Constant()\value
				Else
					System_Error(Parser\codeLineCount, "Unknown constant: " + Parser\curToken\text)
				EndIf
			EndIf
			If arrSize < 0
				System_Error(Parser\curLine, "Error: negative array index")
			Else
				System\ADR_Var - arrSize
				For i = 0 To arrSize
					Parse_WriteI(0, Parser\curVarType, #Null, System\ADR_Var + i)
				Next
			EndIf
		EndIf
		Parse_NextToken(#T_BRACKET_CLOSE, #True)
	EndIf
	
	If Parse_Token(*sub, *curToken, paramNr, 0, isLocal)
		If arrSize >= 0
			Parse_WriteI(arrSize, Parser\curVarType, #Null, System\ADR_Var)
			Parser\curVar\type = #SYM_ARRAY
		EndIf
		ProcedureReturn #True
	Else
		ProcedureReturn #False
	EndIf
EndProcedure

Procedure Parse_Param(*sub.SUB, paramNr)
	Protected result = #False
	Protected type = -1
	
	Parse_VarType(*sub)
	
	If Parse_NextToken(#T_NUMBER)
		type = #T_NUMBER
	ElseIf Parse_NextToken(#T_CONSTANT)
		type = #T_CONSTANT
	ElseIf Parse_NextToken(#T_VARIABLE)
		type = #T_VARIABLE
	ElseIf Parse_NextToken(#T_LABEL)
		type = #T_LABEL
	ElseIf Parse_NextToken(#T_FIELD)
		type = #T_FIELD
	ElseIf Parse_NextToken(#T_SUB)
		type = #T_SUB
	ElseIf Parse_NextToken(#T_STRING)
		type = #T_STRING
	Else
		type = Parse_NextType(1)
	EndIf
	
	If  type < 0
		System_Error(Parser\codeLineCount, "Wrong parameter type: " + GetTokenName(type))
	Else
		If type = #T_VARIABLE
			result = Parse_Var(*sub, #Null, paramNr, #False, #False)
		Else
			result = Parse_Token(*sub, Parser\curToken, paramNr)
		EndIf
	EndIf
	
	ProcedureReturn result
EndProcedure

Procedure Parse_Expression(*sub.SUB, *opcode.OPCODE, paramNr, readState)
	Protected *var.VARIABLE = Parser\curVar
	Protected adrMode = Parser\curAdrMode
	Protected varAdr = System\ADR_VarStart - paramNr

	Protected *curOp.OPCODE, curParam
	
	If Parse_NextToken(#T_BRACKET_OPEN)
		Parse_WriteI(#OP_PUV, #SYM_OPCODE)
		
		Parse_WriteI(#OP_GET | #ADR_INDIRECT << 8, #SYM_OPCODE)
		Parse_WriteI(varAdr, #SYM_ADDRESS)
		Parse_WriteI(0, #SYM_FLOAT, #Null, varAdr)
		
		While Parse_NextToken() And Parser\curToken\type <> #T_BRACKET_CLOSE
			Protected found = 0
			Parser\curIP = *CPU\IP
			System\adrMode = 0
			Select Parser\curToken\type
				Case #T_VARIABLE
					Parse_Var(*sub, #OP_SET, 0, #False, #False)
				Case #T_NUMBER
					If FindString(TokenText(Parser\curToken), ".")
						Parse_WriteI(0, #SYM_FLOAT, #Null, varAdr)
					EndIf
					Parse_WriteI(#OP_SET, #SYM_OPCODE)
					Parse_Token(*sub, Parser\curToken)
				Case #T_CONSTANT, #T_FIELD
					Parse_WriteI(#OP_SET, #SYM_OPCODE)
					Parse_Token(*sub, Parser\curToken)
				Case #T_SUB
					Parse_Sub(*sub, readState)
 				Case #T_OPCODE
 					*curOp = Parser\curToken\opcode
 					Select *curOp\ID
 						Case #OP_RND
 							Parse_WriteI(0, #SYM_FLOAT, #Null, varAdr)
 					EndSelect
 					
					Parse_WriteI(*curOp\ID, #SYM_OPCODE)
					For curParam = 0 To *curOp\nParams - 1
						Parse_Param(*sub, curParam)
					Next
				Case #T_STRING
					Parse_WriteI(parser\curToken, #SYM_INT)
			EndSelect
		Wend
		Parse_WriteI(#OP_POV, #SYM_OPCODE)
		
		If paramNr < *Opcode\nParams - 1
		;	System\ADR_Var - 1
		Else
			Parser\curIP = *CPU\IP
			System\adrMode = 0
			Parse_WriteI(*opcode\ID, #SYM_OPCODE)
			
			If *Opcode\nParams = 1
				Parse_SetAddressMode(0, #ADR_INDIRECT)
				Parse_WriteI(varAdr, #SYM_ADDRESS)
			Else
				Parse_SetAddressMode(0, #ADR_INDIRECT)
				Parse_WriteI(varAdr + 1, #SYM_ADDRESS)
				Parse_SetAddressMode(1, #ADR_INDIRECT)
				Parse_WriteI(varAdr, #SYM_ADDRESS)
			EndIf
		EndIf
	Else
		If paramNr = 0
			Parser\curIP = *CPU\IP
			System\adrMode = 0
			Parse_WriteI(*opcode\ID, #SYM_OPCODE)
		EndIf
		Parse_Param(*sub, paramNr)
	EndIf
	
	ProcedureReturn SYSTEM_NOERROR()
EndProcedure

;-

Procedure Tokenize_Comment(*c.Character)
	Protected size = 1
	Repeat
		*c + SizeOf(Character)
		If *c\c = 0 Or *c\c = 10 Or *c\c = 13
			Break
		EndIf
		size + 1
	ForEver
	ProcedureReturn size
EndProcedure

Procedure Tokenize_String(*c.Character)
	Protected size = 1
	Repeat
		*c + SizeOf(Character)
		size + 1
		If *c\c = 0 Or *c\c = 34
			Break
		EndIf
	ForEver
	ProcedureReturn size
EndProcedure

Procedure Tokenize_Text(*c.Character)
	Protected size = 1
	Repeat
		*c + SizeOf(Character)
		Select *c\c
			Case 'a' To 'z', 'A' To 'Z', '_', '0' To '9'
			Default
				Break
		EndSelect
		size + 1
	ForEver
	ProcedureReturn size
EndProcedure

Procedure Tokenize_Number(*c.Character)
	Protected size = 1, decPoint
	Repeat
		*c + SizeOf(Character)
		Select *c\c
			Case '0' To '9'
			Case '.'
				If decPoint : Break : EndIf
				decPoint = 1
			Default
				Break
		EndSelect
		size + 1
	ForEver
	ProcedureReturn size
EndProcedure

Procedure Tokenize_Start()
	Protected.Character *c, *cNext
	Protected text.s, key.s
	Protected pos = 1
	Protected token.TOKEN
	
	*c.Character = @Parser\code
	If *c = #Null
		ProcedureReturn 0
	EndIf
	
	While *c\c
		*cNext.Character = *c + SizeOf(Character)		
		
		With token
			\type = 0
			\position = pos
			\length = 1
			\opcode = #Null
			\text = ""
			\value = 0
			
			Select *c\c
				Case #CR
					\type = #T_NEWLINE
					If *cNext\c = #LF
						\length = 2
					EndIf
				Case #LF
					\type = #T_NEWLINE
				Case Asc("'")
					\type = #T_COMMENT
					\length = Tokenize_Comment(*c)
				Case Asc(#DOUBLEQUOTE$)
					\type = #T_STRING
					\length = Tokenize_String(*c)
				Case '$'	
					\type = #T_SUB
					\length = Tokenize_Text(*c)
					\text = PeekS(*c, \length)
				Case '~'
					\type = #T_FIELD
					\length = Tokenize_Text(*c)
					\text = PeekS(*c, \length)
				Case ':'
					\type = #T_LABEL
					\length = Tokenize_Text(*c)
					\text = PeekS(*c, \length)
				Case '#'
					\type = #T_CONSTANT
					\length = Tokenize_Text(*c)
					\text = PeekS(*c, \length)
				Case 'a' To 'z', 'A' To 'Z', '_', '@', '!'
					\length = Tokenize_Text(*c)
					text = PeekS(*c, \length)
					key = UCase(text)
					If FindMapElement(*Opcode(), key)
						\type = #T_OPCODE
						\opcode = *Opcode()
					ElseIf  FindMapElement(KeyWord(), key)
						\type = KeyWord()\type
					Else
						\type = #T_VARIABLE
						\text = text
					EndIf
				Case '-', '0' To '9'
					\length = Tokenize_Number(*c)
					If *c\c = '-' And \length = 1
						\type = #T_OPCODE
						\opcode = @Opcode(#OP_SUB)
					Else
						\type = #T_NUMBER
						\value = ValD(PeekS(*c, \length))
					EndIf
				Case '('
					\type = #T_BRACKET_OPEN
				Case ')'
					\type = #T_BRACKET_CLOSE
				Case '.'
					\type = #T_PERIOD
				Case '=', '+', '-', '*', '/', '^', '%', '?', '&', '|', '<', '>'
					\type = #T_OPCODE
					If *c\c = '<' And *cNext\c = '<'
						\opcode = @Opcode(#OP_SHL)
						\length = 2
					ElseIf *c\c = '<' And *cNext\c = '>'
						\opcode = @Opcode(#OP_INE)
						\length = 2
					ElseIf *c\c = '<' And *cNext\c = '='
						\opcode = @Opcode(#OP_ILE)
						\length = 2
					ElseIf *c\c = '>' And *cNext\c = '>'
						\opcode = @Opcode(#OP_SHR)
						\length = 2
					ElseIf *c\c = '>' And *cNext\c = '='
						\opcode = @Opcode(#OP_IGE)
						\length = 2
					ElseIf *c\c = '=' And *cNext\c = '='
						\opcode = @Opcode(#OP_IEQ)
						\length = 2
					ElseIf *c\c = '&' And *cNext\c = '&'
						\opcode = @Opcode(#OP_AND)
						\length = 2 
					ElseIf *c\c = '|' And *cNext\c = '|'
						\opcode = @Opcode(#OP__OR)
						\length = 2 
					ElseIf *c\c = '|'
						\type = #T_SEPARATOR
					ElseIf FindMapElement(*Opcode(), Chr(*c\c))
						\opcode = *Opcode()
					Else
						\type = 0
					EndIf
			EndSelect
	
			If \type
				CopyStructure(token, @Parser\token(parser\tokenCount), TOKEN)
				\index = Parser\tokenCount
				
				Parser\tokenCount + 1
				If Parser\tokenCount >= ArraySize(Parser\token())
					ReDim Parser\token(Parser\tokenCount + 1000)
				EndIf
			EndIf
			
			pos + \length
			*c + \length * SizeOf(Character)
		EndWith	
	Wend
	
	ReDim Parser\token(Parser\tokenCount + 16)
	
	ProcedureReturn Parser\tokenCount
EndProcedure


;-

Procedure Parse_First(*sub.SUB, readState, depth)
	; find subs, fields, constants, variables
	
	Protected *token.TOKEN
	Protected *childSub.SUB
	
	While Parse_NextToken()
		Parser\curLine = Parser\codeLineCount

		Select Parser\curToken\type
				
			Case #T_BRACKET_CLOSE
				
				If readState & #READ_SUB
					Break
				EndIf
			
			Case #T_DEFINE
				
				If Parse_NextToken()
					
					Select Parser\curToken\type
							
						Case #T_SUB
							
							If Parse_Token(*sub, Parser\curToken, 0, #True)
								*childSub = Parser\curSub

								While Parse_NextToken(#T_VARIABLE) Or Parse_VarType(*sub)
									If Parser\curToken\type = #T_VARIABLE
										If Parse_Var(*childSub, #Null, 0, #False, #False,#True)
											Parser\curVar\isParam = #True
											*childSub\nrParams + 1
										EndIf
									EndIf
								Wend
								
								If Parse_NextToken(#T_BRACKET_OPEN, #True)
									Parse_First(*childSub, readState | #READ_SUB, depth + 1)
								EndIf
							EndIf							
							
						Case #T_FIELD
							
							Parse_Token(*sub, Parser\curToken, 0, #True)
							
						Case #T_CONSTANT

							*token = Parser\curToken
							If Parse_NextToken(#T_NUMBER, #True)
								Constant_Add(#SYM_CONSTANT, TokenText(*token), Parser\curToken\value)
							EndIf
							
						Default
							
							System_Error(Parser\curLine, "Syntax Error")
							
					EndSelect
				EndIf
				
			Case #T_INT, #T_FLOAT, #T_CHAR
				
				Protected isLocal
				If readState &  #READ_SUB
					isLocal = #True
				Else
					isLocal = #False
				EndIf
				
				Parser\tokenIndex - 1
				Parse_VarType(*sub)
				
				If Parse_NextToken(#T_BRACKET_OPEN)
					While Parse_NextToken(#T_VARIABLE)
						Parse_AddVar(*sub, TokenText(Parser\curToken), Parser\curVarType, Parser\curToken, isLocal)
					Wend
					Parse_NextToken(#T_BRACKET_CLOSE, #True)
				ElseIf Parse_NextToken(#T_VARIABLE, #True)
					Parse_Var(*sub, #Null, 0, #False, #True, isLocal)
				EndIf
				
			Case #T_STRING
				
				;Debug TokenText(Parser\curToken)
				
		EndSelect
	Wend
	
	ProcedureReturn SYSTEM_NOERROR()
EndProcedure

Procedure Parse_Main(*sub.SUB, readState, depth)
	Protected prevIP, elseIP, prevIndex, opcode, subIP, opcodeIP, readGroup, groupIndex, breakLevel
	Protected nSubParams
	Protected *dataSect.DATASECT, *token.TOKEN
	Protected *parentSub.SUB, *childSub.SUB
	Protected *curOpcode.OPCODE
	Protected tab.s = Space(depth * 4)
	Protected setVar.s

; 	If (readState & #READ_LOOP) = 0
; 		ClearList(Parser\brakeList())
; 	EndIf
	
	While Parse_NextToken()
		
		Parser\curLine = Parser\codeLineCount
		
;     		Debug  MEMSTR(Parser\curLine + 1) + MEMSTR(Parser\tokenIndex) + tab + MEMSTR(readState) + ":  " + TokenText(Parser\curToken) + "  tokenType: " + GetTokenName(Parser\curToken\type)

		Select Parser\curToken\type
				
			Case 0
				
				Break
								
			Case #T_BRACKET_OPEN

				parser\tokenIndex - 1
				Parse_Expression(*sub, @opcode(#OP_GET), 0, readState)
								
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
												
			Case #T_DEFINE
				
				If Parse_NextToken()
					
					Select Parser\curToken\type
							
						Case #T_SUB
							
							subIP = *CPU\IP + 1
							Parse_WriteI(#OP_JMP, #SYM_OPCODE) ; a sub shouldn't be reached without a call -> so jump over it
							Parse_WriteI(0, #SYM_INT)		   ; place holder for the jump address
							
							If Parse_Token(*sub, Parser\curToken, 0, #True)
								*childSub = Parser\curSub
								*dataSect = Parser\curDataSect
								
								If Parse_VarType(*sub) Or Parse_NextToken(#T_VARIABLE)
									; the sub parameters have already been parsed in the pre-parse step, so skip it here
									While Parse_NextToken(#T_VARIABLE) Or Parse_VarType(*sub)
									Wend
									
									If LastElement(*childSub\vars())
										Repeat
											If *childSub\vars()\isParam
												Parse_SubVar(*childSub, *childSub\vars(), #OP_POP)
											EndIf
										Until PreviousElement(*childSub\vars()) = #Null
									EndIf
								EndIf
								
								If Parse_NextToken(#T_BRACKET_OPEN, #True)
									Parse_AddBracket()
									
									If Parse_Main(*childSub, readState | #READ_SUB, depth + 1)
										ForEach *childSub\ret()
											SETVAL(*childSub\ret(), *CPU\IP)
										Next
										ClearList(*childSub\ret())
										
  										;Parse_WriteI(#OP_POV, #SYM_OPCODE)
  										Parse_WriteI(#OP_MOV | #ADR_INDIRECT << 8, #SYM_OPCODE)
  										Parse_WriteI(System\ADR_VarStart, #SYM_ADDRESS)

										Parse_WriteI(#OP_POI, #SYM_OPCODE)
									EndIf
									
									*dataSect\endAdr = *CPU\IP
								EndIf
							EndIf
							
							SETVAL(subIP, *CPU\IP)
							
						Case #T_FIELD
							
							Parse_Field(*sub)
							
						Case #T_CONSTANT
							
							Parse_NextToken()						
							
					EndSelect
				EndIf
				
			Case #T_INT, #T_FLOAT, #T_CHAR
				
 				If Parse_NextToken(#T_BRACKET_OPEN)
					While Parse_NextToken(#T_VARIABLE)
					Wend
					Parse_NextToken(#T_BRACKET_CLOSE, #True)
				Else
					prevIndex = parser\tokenIndex
					If Parse_NextToken(#T_VARIABLE)
						If Parse_NextToken(#T_BRACKET_OPEN)
							Parse_NextToken()
							Parse_NextToken(#T_BRACKET_CLOSE, #True)
						Else
							parser\tokenIndex = prevIndex
						EndIf
					EndIf
				EndIf
				
			Case #T_VARIABLE
				
				Parser\curIP = *CPU\IP
				Parse_Var(*sub, #OP_GET, 0, #True, #False)
				
			Case #T_LABEL
				
				Parse_Token(*sub, Parser\curToken, 0, #True)
				
			Case #T_SUB ;- CALL SUB
				
				Parse_Sub(*sub, readState)
				
			Case #T_RETURN
				
				If readState & #READ_SUB
					If Parse_NextToken(#T_BRACKET_OPEN)
						Parser\curIP = *CPU\IP
						Parse_WriteI(#OP_GET, #SYM_OPCODE)
						Parse_Param(*sub, 0)
						Parse_NextToken(#T_BRACKET_CLOSE, #True)
					EndIf
					
					Parse_WriteI(#OP_JMP, #SYM_OPCODE)
					Parse_WriteI(*CPU\IP + 1, #SYM_ADDRESS) ; place holder for exit address
					AddElement(*sub\ret())
					*sub\ret()= *CPU\IP - 1
				Else
					System_Error(Parser\curLine, "Return without Call")
				EndIf
				
			Case #T_LOOP
				
				If Parse_NextToken(#T_BRACKET_OPEN, #True)
					opcodeIP = *CPU\IP
					*curOpcode = Parser\curToken\opcode
					Parser\curOpcode = #Null;*curOpcode
					Parser\curIP = *CPU\IP
					System\adrMode = 0
					
					Parse_AddBracket()
					
					Parser\loopDepth + 1
					If Parse_Main(*sub, readState | #READ_LOOP, depth + 1)
						Parser\loopDepth - 1
						
						Parse_WriteI(#OP_JMP, #SYM_OPCODE)
						Parse_WriteI(opcodeIP, #SYM_ADDRESS) ; jump back to loop start
						
						ForEach Parser\brakeList()
							If Parser\loopDepth <= Parser\brakeList()\loopDepth
								SETVAL(Parser\brakeList()\adr, *CPU\IP) ; set exit address
								DeleteElement(Parser\brakeList())
							EndIf
						Next
						
					EndIf
					
				EndIf

			Case #T_BREAK
				
				If readState & #READ_LOOP
					If AddElement(Parser\brakeList())
						Parser\brakeList()\loopDepth = Parser\loopDepth
						If Parse_NextToken(#T_NUMBER)
							Parser\brakeList()\loopDepth - Min(Parser\curToken\value, Parser\loopDepth)
						EndIf
						Parse_WriteI(#OP_JMP, #SYM_OPCODE)
						Parse_WriteI(*CPU\IP + 1, #SYM_ADDRESS) ; placeholder for the exit address
						Parser\brakeList()\adr = *CPU\IP - 1
					EndIf
				Else
					System_Error(Parser\curLine, "Break without Loop")
				EndIf
				
			Case #T_ELSE
				
 				System_Error(Parser\curLine, "Else without If")
 				
 			Case #T_SOUND
 	
 				If Parse_NextToken(#T_BRACKET_OPEN, #True)
 					While Parse_NextToken(#T_VARIABLE)
 						If Parse_AddVar(*sub, TokenText(Parser\curToken), #SYM_INT, Parser\curToken)
 							If Parse_NextToken(#T_STRING, #True)
 								If SoundSystemOK
 									Parse_AddSound(Parser\curVar, GetPathPart(*CurrentFile\path) + Trim(TokenText(Parser\curToken), #DOUBLEQUOTE$))
 								EndIf
 							EndIf
 						EndIf
 					Wend
 					Parse_NextToken(#T_BRACKET_CLOSE, #True)
 				EndIf
 				
			Case #T_OPCODE
				
				opcodeIP = *CPU\IP
				*curOpcode = Parser\curToken\opcode
				Parser\curOpcode = *curOpcode
				Parser\curIP = *CPU\IP
				System\adrMode = 0
				
				Select *curOpcode\ID
												
					Case #OP_IFL, #OP_ILO, #OP_IGR, #OP_ILE, #OP_IGE, #OP_IEQ, #OP_INE
						
						If Parse_Expression(*sub, *curOpcode, 0, readState)
							*dataSect = Parser\curDataSect
							
							prevIP = *CPU\IP
							Parse_WriteI(0, #SYM_ADDRESS)
							
							Protected NewList ExitAdr()
							Protected addIp = 0
							
							If Parse_NextToken(#T_BRACKET_OPEN, #True)
								Parse_AddBracket()
								If Parse_Main(*sub, readState | #READ_IF, depth + 1)
									If Parse_NextToken(#T_ELSE)
										SETVAL(prevIP, *CPU\IP + 2)
										Repeat
											If Parse_NextToken(#T_BRACKET_OPEN, #True)
												Parse_AddBracket()
												Parse_WriteI(#OP_JMP, #SYM_OPCODE)
												Parse_WriteI(*CPU\IP + 1, #SYM_ADDRESS)
												AddElement(ExitAdr())
												ExitAdr() = *CPU\IP - 1
												Parse_Main(*sub, readState | #READ_ELSE, depth + 1)
											EndIf
										Until Parse_NextToken(#T_ELSE) = 0
									EndIf
									If Parse_NextType(1, #T_ELSE) >= 0
										SETVAL(prevIP, *CPU\IP + 2)
									ElseIf ListSize(ExitAdr()) = 0
										SETVAL(prevIP, *CPU\IP)
									EndIf
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
						
					Case #OP_DBG
						
						If Parse_NextToken(#T_STRING, #True)
							Parser\curIP = *CPU\IP
							System\adrMode = 0
							
							Parse_WriteI(*curOpcode\ID, #SYM_OPCODE)
							Parser\tokenIndex - 1
							Parse_Param(*sub, 0)
							Parse_Param(*sub, 1)
						EndIf
						
					Default ;- OPCODE
						
						Parser\curIP = *CPU\IP
						System\adrMode = 0

						If *curOpcode\nParams = 0
							Parse_WriteI(*curOpcode\ID, #SYM_OPCODE)
						ElseIf *curOpcode\nParams = 1
							Parse_Expression(*sub, *curOpcode, 0, readState)
						Else
							Parse_Expression(*sub, *curOpcode, 0, readState)
							Parse_Expression(*sub, *curOpcode, 1, readState)
						EndIf
						
				EndSelect
				
			Default
				
				System_Error(Parser\curLine, "Unexpected Tokentype: " + GetTokenName(Parser\curToken\type))
				
		EndSelect
	Wend
	
	ProcedureReturn SYSTEM_NOERROR()
EndProcedure

Procedure Parse_Start(*file.FILE, parseFull = #True)
	Protected StartTime = ElapsedMilliseconds()
	Protected refName.s
	Protected key.s
	
	If *file = #Null
		ProcedureReturn #False
	EndIf
	
	ClearStructure(Parser, PARSER)
	InitializeStructure(Parser, PARSER)	
	
	System_Init(RamSize, StackSize)
	System_RunState(RunState & ~(#STATE_END | #STATE_RUN | #STATE_ERROR))
	*CPU\IP = 0
	
	; PRE PARSE STEP
	With Parser
		Parser\preParse = #True
		Parser\code = Scintilla_GetText(*file\editor)
		Tokenize_Start()
		Parse_First(\main, 0, 0)
	EndWith

	If parseFull
		; MAIN PARSE STEP
		System_RunState(RunState & ~(#STATE_END | #STATE_RUN | #STATE_ERROR))
		*CPU\IP = 0
		
		With Parser
			\preParse = #False
			\tokenIndex = 0
			\codeLineCount = 0
			\curToken = #Null
			
			ClearMap(\label())
			ClearList(\reference())
			ClearList(\brakeList())
			ClearList(\bracketList())
			
			Parse_Main(\main, 0, 0)
		EndWith
		
		System\programSize = *CPU\IP
		
		If (System\state & #STATE_SILENT) = 0
			If ListSize(Parser\bracketList()) > 0
				System_Error(Parser\bracketList()\lineNr, "missing closing bracket")
			EndIf
		EndIf
		
		If RunState & #STATE_END = 0
			; assign addresses
			ForEach Parser\reference()
				Protected found = #False
				With Parser\reference()
					refName = TokenText(Parser\reference()\token)
					key = UCase(refName)
					
					If \isSub
						; 1) local search
						If FindMapElement(\sub\sub(), key) And \sub\sub()\dataSect\startAdr >= 0
							Parse_WriteI(\sub\sub()\dataSect\startAdr, #SYM_SUB, \token, \startAdr)
							; 2) global search
						ElseIf FindMapElement(Parser\main\sub(), key) And Parser\main\sub()\dataSect\startAdr >= 0
							Parse_WriteI(Parser\main\sub()\dataSect\startAdr, #SYM_SUB, \token, \startAdr)
						Else;If SYSTEM_HASERROR()
							System_Error(\lineNr, "Sub not defined: " + refName)
						EndIf
						found = #True
					EndIf
					If \isLabel
						If FindMapElement(Parser\label(), key) And Parser\label()\startAdr >= 0
							SETVAL(\startAdr, Parser\label()\startAdr)
						Else;If SYSTEM_HASERROR()
							System_Error(\lineNr, "Label not found: " + refName)
						EndIf
						found = #True
					EndIf
					If \isField
						If FindMapElement(Parser\field(), key) And Parser\field()\startAdr >= 0
							Parse_WriteI(Parser\field()\startAdr, #SYM_FIELD, \token, \startAdr)
						Else;If SYSTEM_HASERROR()
							System_Error(\lineNr, "Field not defined: " + refName)
						EndIf
						found = #True
					EndIf
					
					If found = #False
						Debug "unknown reference: " + refName
					EndIf
				EndWith
			Next
		EndIf
	EndIf
	
	*CPU\IP = 0
	
	System_Update_SubList()
	If MonitorVisible
		System_Update_VarList(Parser\main, #False, #True)
		System_Update_Monitor(*CPU\IP)
	EndIf
	
	If System\state & #STATE_SILENT = 0
		AddGadgetItem(#g_Error, -1, TIMESTR() + "   parsing finished in " + FSTR((ElapsedMilliseconds() - StartTime) / 1000.0) + " seconds") 
	EndIf
	
	StatusBarText(0, 0, "RAM: " + Str(System\RAM_Size) + " Size: " + Str(System\programSize) + " / " + Str(System\ADR_Var - System\programSize) + " free", #PB_StatusBar_Center)
	
	SortStructuredList(Parser\dataSect(), #PB_Sort_Ascending, OffsetOf(DATASECT\startAdr), TypeOf(DATASECT\startAdr))
	
; 	ForEach Parser\dataSect()
; 		With Parser\dataSect()
; 			If \isSub
; 				Debug "SUB " + TokenText(\token)
; 			EndIf
; 			If \isField
; 				Debug "FIELD " + TokenText(\token)
; 			EndIf
; 			If \isLabel
; 				Debug "LABEL " + TokenText(\token)
; 			EndIf
; ; 				Default : Debug "? " + Str(\type) + " " + TokenText(\token)
; ; 			EndSelect
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
	
	ProcedureReturn SYSTEM_NOERROR()
EndProcedure

;-

Procedure Event_Menu()
	System_RunState(0)
	
	Select EventMenu()
		Case #m_Quit
			System_Quit()
		Case #m_New
			System\state | #STATE_SILENT
			File_Open("", #True, #True)
			System\state & ~#STATE_SILENT
		Case #m_Open
			If File_Open("", #False, #True)
				File_UpdateIni()
			EndIf
		Case #m_Save
			If File_Save(*CurrentFile)
				File_UpdateIni()
			EndIf
		Case #m_SaveAs
			If File_Save(*CurrentFile, #True)
				File_UpdateIni()
			EndIf
		Case #m_Close
			System\state | #STATE_SILENT
			If File_Close(*CurrentFile)
				File_UpdateIni()
				System_Parse(*CurrentFile, #False)
			EndIf
			System\state & ~#STATE_SILENT
		Case #m_Undo
			Scintilla_Undo(*CurrentFile\editor)
		Case #m_Redo
			Scintilla_Redo(*CurrentFile\editor)
		Case #m_Parse
			System_Parse(*CurrentFile, #True, #False)
		Case #m_ParseRun
			System_Parse(*CurrentFile, #True, #True)
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
			System_Update_VarList(Parser\main, #False, #True)
			System_Update_Monitor(*CPU\IP)
			HideWindow(#w_Monitor, 0)
			MonitorVisible = #True
		Case #m_MonitorUp
			*CPU\IP = MAX(*CPU\IP - 1, 0)
			System_Update_Monitor(*CPU\IP, -1)
		Case #m_MonitorDown
			*CPU\IP = MIN(*CPU\IP + 1, System\programSize - 1)
			System_Update_Monitor(*CPU\IP, 1)
		Case #m_CopyMonitor
			Protected i, lastI, text.s
			For lastI = CountGadgetItems(#g_Monitor) - 1 To 0 Step - 1
				If Trim(GetGadgetItemText(#g_Monitor, lastI, 4))
					For i = 0 To lastI
; 						text + RSet(GetGadgetItemText(#g_Monitor, i, 0), 12)
; 						text + RSet(GetGadgetItemText(#g_Monitor, i, 1), 5)
; 						text + RSet(GetGadgetItemText(#g_Monitor, i, 2), 5)
; 						text + RSet(GetGadgetItemText(#g_Monitor, i, 3), 5)
						text + GetGadgetItemText(#g_Monitor, i, 4) + #NL$
					Next
					Break
				EndIf
			Next
			SetClipboardText(text)
		Case #m_Help
			System_Help()
		Case #m_SearchSel
			If *CurrentFile
				SetGadgetText(#g_SearchText, Scintilla_GetSelText(*CurrentFile\editor))
				Scintilla_SearchStart(*CurrentFile\editor, GetGadgetText(#g_SearchText))
				If GetGadgetText(#g_SearchText) = ""
					SetActiveGadget(#g_SearchText)
				Else
					SetActiveGadget(*CurrentFile\editor)
				EndIf
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
		Case #m_NextFile
			File_Next()
	EndSelect
EndProcedure

Procedure Event_Gadget()
	Select Event()
		Case #PB_Event_Gadget
			Select EventGadget()
				Case #g_FilePanel
					If EventType() = #PB_EventType_Change
						System\state | #STATE_SILENT
						File_Activate(GetGadgetItemData(#g_FilePanel, GetGadgetState(#g_FilePanel)), -1, #True)
						System\state & ~#STATE_SILENT
					EndIf
				Case #g_Error, #g_Monitor
					If EventType() = #PB_EventType_LeftDoubleClick
						System_GotoLine(GetGadgetItemData(EventGadget(), GetGadgetState(EventGadget())))
						File_Activate(*CurrentFile)
					EndIf
				Case #g_Variables
					If EventType() = #PB_EventType_LeftDoubleClick
						System_Variable_Change(GetGadgetItemData(#g_Variables, GetGadgetState(#g_Variables)))
					EndIf
				Case #g_VarSort
					System_Update_VarList(Parser\main, #False, #True)
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
				Case #g_SplitterEditorH, #g_SplitterEditorV
					PostEvent(#PB_Event_SizeWindow, #w_Main, 0)
				Case #g_SplitterMonitor
					PostEvent(#PB_Event_SizeWindow, #w_Monitor, 0)
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
					
					If WindowWidth(#w_Screen, #PB_Window_InnerCoordinate)
						System\SCR_PixelSize = System\SCR_Width / WindowWidth(#w_Screen, #PB_Window_InnerCoordinate)
					EndIf
				Case #w_Monitor
					y = ToolBarHeight(#t_Monitor)
					ResizeGadget(#g_SplitterMonitor, 0, y, WindowWidth(#w_Monitor), WindowHeight(#w_Monitor) - y)
					x = GadgetWidth(#g_VarContainer) - 10
					ResizeGadget(#g_VarSort, 5, 5, x, 25)
					ResizeGadget(#g_Variables, 5, 30, x, GadgetHeight(#g_SplitterMonitor) - 35)
				Case #w_Debug
					ResizeGadget(#g_Debug, 0, 0, WindowWidth(#w_Debug), WindowHeight(#w_Debug))
				Case #w_Help
					ResizeGadget(#g_Help, 5, 5, WindowWidth(#w_Help) - 10, WindowHeight(#w_Help) - 10)
			EndSelect
	EndSelect
EndProcedure

DisableExplicit

IDE_Init()
System_Start(65536, 255)

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

			Select opcode ;- RUN
				Case #OP_MOV
					; value in V-Register to address
					GETVAL(*CPU\V, valF1)
					GETVAL_WRITE(System\nextIP, valI1)
					SETVAL(valI1, valF1)
				Case #OP_GET
					; variable to V-Register
					GETVAL_WRITE(System\nextIP, *CPU\V)
				Case #OP_SET
					; value to variable in V-Register
					GETVAL_READ(System\nextIP, valF1)
					SETVAL(*CPU\V, valF1)
				Case #OP_ADD
					MATH_F(+)
				Case #OP_SUB
					MATH_F(-)
				Case #OP_MUL
					MATH_F(*)
				Case #OP_DIV
					GETVAL(*CPU\V, valF1)
					GETVAL_READ(System\nextIP, valF2)
					If valF2 = 0
						System_Error(System_LineNrByIP(*CPU\IP), "Division by zero")
					Else
						valF1 / valF2
						SETVAL(*CPU\V, valF1)
					EndIf
				Case #OP_SQR
					GETVAL(*CPU\V, valF1)
					If valF1 < 0
						System_Error(System_LineNrByIP(*CPU\IP), "Square root of negative number")
 					Else
						SETVAL(*CPU\V, Sqr(valF1))
					EndIf
				Case #OP_POW
					GETVAL(*CPU\V, valF1)
					GETVAL_READ(System\nextIP, valF2)
					SETVAL(*CPU\V, Pow(valF1, valF2))
				Case #OP_SHL
					MATH_I(<<)
				Case #OP_SHR
					MATH_I(>>)
				Case #OP_AND
					MATH_I(&)
				Case #OP__OR
					MATH_I(|)
				Case #OP_MOD
					MATH_I(%)
				Case #OP_NEG
					GETVAL(*CPU\V, valF1)
					SETVAL(*CPU\V, -valF1)
				Case #OP_INT
					GETVAL(*CPU\V, valI1)
					SETVAL(*CPU\V, valI1)
				Case #OP_NTH
					GETVAL(*CPU\V, valI1)
					valS = Str(valI1)
					GETVAL_READ(System\nextIP, valI2)
					valI1 = Len(valS)
					If valI2 >= valI1
						SETVAL(*CPU\V, 0)
					Else
						SETVAL(*CPU\V, Val(Mid(valS, valI1 - valI2, 1)))
					EndIf
				Case #OP_SGN
					GETVAL(*CPU\V, valF1)
					SETVAL(*CPU\V, Sign(valF1))
				Case #OP_CIL
					GETVAL(*CPU\V, valF1)
					*CPU\RAM(*CPU\V) = Round(valF1, #PB_Round_Up)
				Case #OP_ABS
					GETVAL(*CPU\V, valF1)
					SETVAL(*CPU\V, Abs(valF1))
				Case #OP_MIN
					GETVAL(*CPU\V, valF1)
					GETVAL_READ(System\nextIP, valF2)
					If valF1 < valF2
						SETVAL(*CPU\V, valF2)
						*CPU\FLAGS = 1
					Else
						*CPU\FLAGS = 0
					EndIf
				Case #OP_MAX
					GETVAL(*CPU\V, valF1)
					GETVAL_READ(System\nextIP, valF2)
					If valF1 > valF2
						SETVAL(*CPU\V, valF2)
						*CPU\FLAGS = 1
					Else
						*CPU\FLAGS = 0
					EndIf
				Case #OP_RSD
					GETVAL_READ(System\nextIP, valI1)
					RandomSeed(valI1)
				Case #OP_RND
					SETVAL(*CPU\V, Random(10000000) / 10000000.0)
				Case #OP_IFL
					GETVAL_READ(System\nextIP, valI1)
					If *CPU\FLAGS = valI1
						System\nextIP + 1
					Else
						GETVAL(System\nextIP, System\nextIP)
					EndIf
				Case #OP_IGR
					COMPARE(>, #FLAG_GREATER, #FLAG_LOWER | #FLAG_EQUAL)
				Case #OP_ILO
					COMPARE(<, #FLAG_LOWER, #FLAG_GREATER | #FLAG_EQUAL)
				Case #OP_IEQ
					COMPARE(=, #FLAG_EQUAL, #FLAG_NOTEQUAL)
				Case #OP_IGE
					COMPARE(>=, #FLAG_GREATER | #FLAG_EQUAL, #FLAG_LOWER)
				Case #OP_ILE
					COMPARE(<=, #FLAG_LOWER | #FLAG_EQUAL, #FLAG_GREATER)
				Case #OP_INE
					COMPARE(<>, #FLAG_NOTEQUAL, #FLAG_EQUAL)
				Case #OP_JMF
					GETVAL_READ(System\nextIP, valF1)
					GETNEXTADRMODE()
					GETVAL_READ(System\nextIP, valF2)
					If *CPU\FLAGS = valF1
						System\nextIP = valF2
					EndIf
				Case #OP_JMP
					GETVAL_READ(System\nextIP, valI1)
					System\nextIP = valI1
				Case #OP_PSH
					; push value
					GETVAL_READ(System\nextIP, valF1)
					PUSH(valF1)
				Case #OP_POP
					; pop value
					GETVAL_WRITE(System\nextIP, valAdr)
					POP(valF1)
					SETVAL(valAdr, valF1)
				Case #OP_PUI
					; push instruction pointer
					Push(System\nextIP)
				Case #OP_POI
					; pop instruction pointer
					POP(System\nextIP)
				Case #OP_PUS
					; push stack pointer
					Push(*CPU\SP)
				Case #OP_POS
					; pop stack pointer
					POP(*CPU\SP)
				Case #OP_PUF
					; push flags
					PUSH(*CPU\FLAGS)
				Case #OP_POF
					; pop flags
					POP(*CPU\FLAGS)
				Case #OP_PUV
					; push V Register
					PUSH(*CPU\V)
				Case #OP_POV
					; pop V Register
					POP(*CPU\V)
				Case #OP_ADS
					; add value to stack pointer
					GETVAL_READ(System\nextIP, valI1)
					*CPU\SP + valI1
				Case #OP_SCR
					; open screen
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

 						;SetFrameRate(120)
						
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
				Case #OP_CLS
					; clear screen
					GETVAL(System\ADR_COL_Front, valL)
					ClearScreen(RGB(25,25,50))
					valI2 = ArraySize(*CPU\VRAM())
					If valI2 >= 0
						FillMemory(@*CPU\VRAM(0), valI2 * SizeOf(long), valL, TypeOf(valL))
					EndIf
				Case #OP_BMS
					; set char size
					GETVAL_READ(System\nextIP, valI1)
					SETVAL(System\ADR_BMP_W, valI1)
					GETNEXTADRMODE()
					GETVAL_READ(System\nextIP, valI1)
					SETVAL(System\ADR_BMP_H, valI1)
				Case #OP_BMM
					; set char mode
					GETVAL_READ(System\nextIP, valI1)
					SETVAL(System\ADR_BMP_MODE, valI1)				
				Case #OP_BXY
					; set char position
					GETVAL_READ(System\nextIP, valI1)
					SETVAL(System\ADR_BMP_X, valI1)
					
					GETNEXTADRMODE()
					GETVAL_READ(System\nextIP, valI1)
					SETVAL(System\ADR_BMP_Y, valI1)
				Case #OP_BMO
					; move char position
					GETVAL_READ(System\nextIP, valI1)
					GETVAL(System\ADR_BMP_X, valI2)
					SETVAL(System\ADR_BMP_X, valI1 + valI2)
					
					GETNEXTADRMODE()
					GETVAL_READ(System\nextIP, valI1)
					GETVAL(System\ADR_BMP_Y, valI2)
					SETVAL(System\ADR_BMP_Y, valI1 + valI2)
				Case #OP_BMP
					; write char
					Define source, x, y, bx, by
					Define bmpW, bmpH, bmpX, bmpY, bmpMode, scrW, scrH
					Define adrR, adrV, adrStart, adrAdd, adrSub
					Define color, collision, colID, colF, colB
					
					GETVAL_READ(System\nextIP, source)
					
					If source >= 0 And source < System\RAM_Size
						scrW = System\SCR_Width
						scrH = System\SCR_Height
						GETVAL(System\ADR_Collision, collision)
						GETVAL(System\ADR_COL_Front, colF)
						GETVAL(System\ADR_COL_Back, colB)
						GETVAL(System\ADR_BMP_X, bmpX)
						GETVAL(System\ADR_BMP_Y, bmpY)
						GETVAL(System\ADR_BMP_W, bmpW)
						GETVAL(System\ADR_BMP_H, bmpH)
						GETVAL(System\ADR_BMP_MODE, bmpMode)
						GETVAL(System\ADR_CollisionID, colID)
						colID << 8
						
						bmpW - 1
						bmpH - 1
						
						Select bmpMode
							Case 0 ; normal mode
								adrStart = source
								adrAdd = 1
								adrSub = 0
							Case 1 ; rotate 90°
								adrStart = source + bmpH * (bmpW + 1)
								adrAdd = -(bmpW + 1)
								adrSub = (bmpW + 1) * (bmpH + 1) + 1
								Swap bmpW, bmpH
							Case 2 ; rotate 180°
								adrStart = source + (bmpW + 1) * (bmpH + 1) - 1
								adrAdd = -1
								adrSub = 0
							Case 3 ; rotate 270°
								adrStart = source + bmpW
								adrAdd = bmpW + 1
								adrSub = -(bmpW + 1) * (bmpH + 1) - 1
								Swap bmpW, bmpH
							Case 4 ; flip x-axis
								adrStart = source + bmpW
								adrAdd = -1
								adrSub =  bmpW * 2 + 2
							Case 5 ; flip y-axis
								adrStart = source + bmpH * (bmpW + 1)
								adrAdd = 1
								adrSub = -(bmpW + 1) * 2
							Default ; normal mode
								adrStart = source
								adrAdd = 1
								adrSub = 0
						EndSelect
						
						If colF
							
							adrR = adrStart
							by = bmpY
							For y = 0 To bmpH
								bx = bmpX
								adrV = bx + by * scrW
								For x = 0 To bmpW
									If bx >= 0 And bx < scrW And by >= 0 And by < scrH
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
									bx + 1
								Next
								adrR + adrSub
								by + 1
							Next
							
						Else		
							
							adrR = adrStart
							by = bmpY
							For y = 0 To bmpH
								bx = bmpX
								adrV = bx + by * scrW
								For x = 0 To bmpW
									If bx >= 0 And bx < scrW And by >= 0 And by < scrH
										color = *CPU\RAM(adrR)
										If color
											If collision = 0
												collision = *CPU\VRAM(adrV) >> 8
												If collision
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
									bx + 1
								Next
								adrR + adrSub
								by + 1
							Next
							
						EndIf
					EndIf
				Case #OP_PAL
					; set palette mode on/off
					GETVAL_READ(System\nextIP, *CPU\RAM(System\ADR_Palette))
				Case #OP_CLF
					; set front color
					GETVAL_READ(System\nextIP, valI1)
					SETVAL(System\ADR_COL_Front, valI1)
				Case #OP_CLB
					; set back color
					GETVAL_READ(System\nextIP, valI1)
					SETVAL(System\ADR_COL_Back, valI1)
				Case #OP_PLT
					Define x, y, adr
					
					GETVAL_READ(System\nextIP, x)
					GETNEXTADRMODE()
					GETVAL_READ(System\nextIP, y)
					adr = x + y * System\SCR_Width
					If adr >= 0 And adr < System\VRAM_Size
						GETVAL(System\ADR_COL_Front, *CPU\VRAM(adr))
					EndIf
				Case #OP_DRW
					Define x, y, scrW, scrH, adrV, c.a, palette
					
					If System\SCR_Active
						GETVAL(System\ADR_Palette, palette)
						If StartDrawing(ScreenOutput())
							scrW = System\SCR_Width - 1
							scrH = System\SCR_Height - 1
							adrV = 0
							
							If palette = 0
								For y = 0 To scrH
									For x = 0 To scrW
										Plot(x, y, *CPU\VRAM(adrV))
										adrV + 1
									Next
								Next
							Else
								For y = 0 To scrH
									For x = 0 To scrW
										c = *CPU\VRAM(adrV) 
										Plot(x, y, *CPU\RAM(System\ADR_Color + c))
										adrV + 1
									Next
								Next
							EndIf
							StopDrawing()
							
							FlipBuffers()
						EndIf
					EndIf
				Case #OP_DLY
					Define curIP, nextIP
					
					If System\wait = 0
						curIP = System\nextIP
						GETVAL_READ(System\nextIP, valI1)
						System\wait = System\time + valI1
						nextIP = System\nextIP
						System\nextIP = curIP
					ElseIf System\time >= System\wait
						System\wait = 0
						System\nextIP = nextIP
					Else
						Delay(5)
					EndIf
				Case #OP_INP
					If System\SCR_Active
						ExamineMouse()
						ExamineKeyboard()
						
						*CPU\FLAGS = KeyboardPushed(#PB_Key_All)

						SETVAL(System\ADR_MOUSE_X, DesktopUnscaledX(WindowMouseX(#w_Screen)) * System\SCR_PixelSize)
						SETVAL(System\ADR_MOUSE_Y, DesktopUnscaledY(WindowMouseY(#w_Screen)) * System\SCR_PixelSize)
						Define mouseB = 0
						
						If MouseButton(#PB_MouseButton_Left)
							mouseB | #Button_Left
						EndIf
						If MouseButton(#PB_MouseButton_Right)
							mouseB | #Button_Right
						EndIf
						
						SETVAL(System\ADR_MOUSE_B, mouseB)
					Else
						*CPU\FLAGS = 0
					EndIf
				Case #OP_KEY
					GETVAL_READ(System\nextIP, valI1)
					*CPU\FLAGS = Bool(KeyboardPushed(valI1))
				Case #OP_SNP
					GETVAL_READ(System\nextIP, valI1)
					GETNEXTADRMODE()
					GETVAL_READ(System\nextIP, valI2)
					
					If SoundSystemOK
						If valI1
							If IsSound(valI1)
								If valI2 = 0
									StopSound(valI1)
								ElseIf valI2 = 2
									PauseSound(valI1)
								Else
									PlaySound(valI1)
								EndIf
							EndIf
						Else
							If valI2 = 2
								PauseSound(#PB_All)
							Else
								StopSound(#PB_All)
							EndIf
						EndIf
					EndIf
				Case #OP_SNS
					GETVAL_READ(System\nextIP, valI1)
					
					If SoundSystemOK
						*CPU\FLAGS = -1
						If IsSound(valI1)
							Select SoundStatus(valI1)
								Case #PB_Sound_Stopped : *CPU\FLAGS = 0
								Case #PB_Sound_Playing : *CPU\FLAGS = 1
								Case #PB_Sound_Paused : *CPU\FLAGS = 2
							EndSelect
						EndIf
					EndIf
				Case #OP_DBG
					Define *token.TOKEN
					
					GETVAL_READ(System\nextIP, *token)
					GETNEXTADRMODE()
					GETVAL_READ(System\nextIP, valF1)
					
					valS = GetGadgetItemText(#g_Debug, CountGadgetItems(#g_Debug) - 1)
					If *token
						valI1 = ValF1
						valS + Trim(TokenText(*token), #DOUBLEQUOTE$)
						valS = ReplaceString(valS, "%i", Str(valI1))
						valS = ReplaceString(valS, "%c", Str(valI1 % 255))
						valS = ReplaceString(valS, "%f", StrD(valF1))
					Else
						valS = StrD(valF1)
					EndIf
					
					RemoveGadgetItem(#g_Debug, CountGadgetItems(#g_Debug) - 1)
	 				AddGadgetItem(#g_Debug, -1, ReplaceString(valS, "\n", #NL$))
					HideWindow(#w_Debug, 0, #PB_Window_ScreenCentered)
				Case #OP_HLT
					System_Error(System_LineNrByIP(*CPU\IP) + 1, "HALT - PROGRAM PAUSED!", #True)
					System_RunState((RunState & ~(#STATE_PAUSE | #STATE_STEPOUT)) | (#STATE_STEP | #STATE_RUN))
				Case #OP_END
					System\state | #STATE_END
					System_CloseScreen(#True)
					System_RunState(0)
				Default
					GETVAL(*CPU\IP, valF1)
					System_Error(System_LineNrByIP(*CPU\IP), "Illegal opcode: " + FSTR(valF1))
					System\state | #STATE_END
					System_RunState(0)
			EndSelect
			
			If System\wait <= 0
				*CPU\IP = System\nextIP
			EndIf
			
			If SYSTEM_HASERROR()
				System_RunState(RunState & ~(#STATE_RUN | #STATE_STEPOUT))
			EndIf
			
			If (RunState & #STATE_STEPOUT)
				If (opcode = #OP_POI) And (System\callDepth < System\exitDepth)
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
	ico_file_new:
	IncludeBinary "_ico\file_new.png"
	ico_file_open:
	IncludeBinary "_ico\file_open.png"
	ico_file_save:
	IncludeBinary "_ico\file_save.png"
	ico_file_close:
	IncludeBinary "_ico\file_close.png"
	ico_undo:
	IncludeBinary "_ico\undo.png"
	ico_redo:
	IncludeBinary "_ico\redo.png"
	ico_compile_run:
	IncludeBinary "_ico\compile_run.png"
	ico_compile:
	IncludeBinary "_ico\compile.png"
	ico_run:
	IncludeBinary "_ico\run.png"
	ico_step:
	IncludeBinary "_ico\step.png"
	ico_stepout:
	IncludeBinary "_ico\stepout.png"
	ico_monitor:
	IncludeBinary "_ico\monitor.png"
	ico_help:
	IncludeBinary "_ico\help.png"
	ico_copy:
	IncludeBinary "_ico\copy.png"

	Opcodes:
	; opcode, nrParams, size, name
	Data.i #OP_MOV, 1, 2 : Data.s "MOV,Mov"
	Data.i #OP_GET, 1, 2 : Data.s "GET,Get"
	Data.i #OP_SET, 1, 2 : Data.s "SET,="
	Data.i #OP_ADD, 1, 2 : Data.s "ADD,+"
	Data.i #OP_SUB, 1, 2 : Data.s "SUB,-"
	Data.i #OP_MUL, 1, 2 : Data.s "MUL,*"
	Data.i #OP_DIV, 1, 2 : Data.s "DIV,/"
	Data.i #OP_SQR, 0, 1 : Data.s "SQR,Sqr"
	Data.i #OP_POW, 1, 2 : Data.s "POW,^"
	Data.i #OP_SHL, 1, 2 : Data.s "SHL,<<"
	Data.i #OP_SHR, 1, 2 : Data.s "SHR,>>"
	Data.i #OP_AND, 1, 2 : Data.s "AND,&&"
	Data.i #OP__OR, 1, 2 : Data.s "OR,||"
	Data.i #OP_MOD, 1, 2 : Data.s "MOD,%"
	Data.i #OP_INT, 0, 1 : Data.s "INT,Floor"
	Data.i #OP_CIL, 0, 1 : Data.s "CIL,Ceil"
	Data.i #OP_ABS, 0, 1 : Data.s "ABS,Abs"
	Data.i #OP_NEG, 0, 1 : Data.s "NEG,Neg"
	Data.i #OP_NTH, 1, 2 : Data.s "NTH,Nth"
	Data.i #OP_MIN, 1, 2 : Data.s "MIN,Min"
	Data.i #OP_MAX, 1, 2 : Data.s "MAX,Max"
	Data.i #OP_SGN, 0, 1 : Data.s "SGN,Sgn"
	Data.i #OP_RSD, 1, 2 : Data.s "RSD,Seed"
	Data.i #OP_RND, 0, 1 : Data.s "RND,Rnd"
	Data.i #OP_IFL, 1, 3 : Data.s "IFL,Is"
	Data.i #OP_IGR, 1, 3 : Data.s "IGR,>"
	Data.i #OP_IGE, 1, 3 : Data.s "IGE,>="
	Data.i #OP_ILO, 1, 3 : Data.s "ILO,<"
	Data.i #OP_ILE, 1, 3 : Data.s "ILE,<="
	Data.i #OP_IEQ, 1, 3 : Data.s "IEQ,=="
	Data.i #OP_INE, 1, 3 : Data.s "INE,<>"
	Data.i #OP_JMP, 1, 2 : Data.s "JMP,Jmp"
	Data.i #OP_JMF, 2, 3 : Data.s "JMF,JmpF"
	Data.i #OP_PSH, 1, 2 : Data.s "PSH,Push"
	Data.i #OP_POP, 1, 2 : Data.s "POP,Pop"
	Data.i #OP_PUI, 0, 1 : Data.s "PUI,PushI"
	Data.i #OP_POI, 0, 1 : Data.s "POI,PopI"
	Data.i #OP_PUS, 0, 1 : Data.s "PUS,PushS"
	Data.i #OP_POS, 0, 1 : Data.s "POS,PopS"
	Data.i #OP_PUV, 0, 1 : Data.s "PUV,PushV"
	Data.i #OP_POV, 0, 1 : Data.s "POV,PopV"
	Data.i #OP_PUF, 0, 1 : Data.s "PUF,PushF"
	Data.i #OP_POF, 0, 1 : Data.s "POF,PopF"
	Data.i #OP_ADS, 1, 2 : Data.s "ADS,AddSP"
	Data.i #OP_SCR, 2, 3 : Data.s "SCR,Screen"
	Data.i #OP_CLS, 0, 1 : Data.s "CLS,Cls"
	Data.i #OP_DRW, 0, 1 : Data.s "DRW,Draw"
	Data.i #OP_BMS, 2, 3 : Data.s "BMS,SetSize"
	Data.i #OP_BXY, 2, 3 : Data.s "BXY,SetXY"
	Data.i #OP_BMO, 2, 3 : Data.s "BMO,MoveXY"
	Data.i #OP_BMM, 1, 2 : Data.s "BMM,SetMode"
	Data.i #OP_BMP, 1, 2 : Data.s "BMP,Bitmap"
	Data.i #OP_PLT, 2, 3 : Data.s "PLT,Plot"
	Data.i #OP_PAL, 1, 2 : Data.s "PAL,Palette"
	Data.i #OP_CLF, 1, 2 : Data.s "CLF,ColorF"
	Data.i #OP_CLB, 1, 2 : Data.s "CLB,ColorB"
	Data.i #OP_DLY, 1, 2 : Data.s "DLY,Delay"
	Data.i #OP_INP, 0, 1 : Data.s "INP,Input"
	Data.i #OP_KEY, 1, 2 : Data.s "KEY,Key"
	Data.i #OP_SNP, 2, 3 : Data.s "SNP,Play"
	Data.i #OP_SNS, 1, 2 : Data.s "SNS,PlayState"
	Data.i #OP_DBG, 2, 3 : Data.s "DBG,Debug"
	Data.i #OP_HLT, 0, 1 : Data.s "HLT,Halt"
	Data.i #OP_KIL, 0, 1 : Data.s "KIL,Kill"
	Data.i #OP_END, 0, 1 : Data.s "END,End"
	Data.i 0, 0, 0
EndDataSection
;}
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 3267
; FirstLine = 3261
; Folding = ---------------
; Markers = 3262
; EnableXP
; DPIAware
; DllProtection
; UseIcon = _ico\icon.ico
; Executable = ShoCo.exe
; DisableDebugger