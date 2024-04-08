; License for Scintilla and SciTE
; 
; Copyright 1998-2003 by Neil Hodgson <neilh@scintilla.org>
; 
; All Rights Reserved 
; 
; Permission to use, copy, modify, and distribute this software and its 
; documentation for any purpose and without fee is hereby granted, 
; provided that the above copyright notice appear in all copies and that 
; both that copyright notice and this permission notice appear in 
; supporting documentation. 
; 
; NEIL HODGSON DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS 
; SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY 
; AND FITNESS, IN NO EVENT SHALL NEIL HODGSON BE LIABLE FOR ANY 
; SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES 
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, 
; WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER 
; TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE 
; OR PERFORMANCE OF THIS SOFTWARE. 

EnableExplicit

CompilerIf #PB_Compiler_Version < 610
	CompilerIf #PB_Compiler_OS = #PB_OS_Windows
		CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
			If InitScintilla("_editor\Scintilla32.dll") = 0
				MessageRequester("", "InitScintilla failed", #PB_MessageRequester_Error)
				End
			EndIf
		CompilerElse
			If InitScintilla("_editor\Scintilla.dll") = 0
				MessageRequester("", "InitScintilla failed", #PB_MessageRequester_Error)
				End
			EndIf
		CompilerEndIf
	CompilerEndIf
CompilerEndIf

CompilerIf Defined(SCI_SETILEXER, #PB_Constant) = 0
	#SCI_SETILEXER = #SCI_SETLEXER
CompilerEndIf

CompilerIf Defined(SCI_SETTARGETRANGE, #PB_Constant) = 0
	#SCI_SETTARGETRANGE = 2686
CompilerEndIf

CompilerIf Defined(SCFIND_NONE, #PB_Constant) = 0
	#SCFIND_NONE = 0
CompilerEndIf

Structure SCI_DICTENTRY
	type.a
	startPos.i
	endPos.i
	text.s
	usage.i
	count.i
EndStructure

Structure SCI_GADGET
	ID.i
	CursorPos.i
	PreviousCursorPos.i
	dirty.i
	
	*keyWord.SCI_DICTENTRY
	
	Map dict.SCI_DICTENTRY(8096)
EndStructure

Global NewMap Scintilla.SCI_GADGET()
Global *SCI_SEARCHTEXT, SCI_SEARCHTEXTLENGTH, *SCI_REPLACETEXT, SCI_REPLACETEXTLENGTH, SCI_SEARCHPOS, SCI_SEARCHFLAGS
Global Dim SCI_CHARTYPE.a(255)

Enumeration
	#Style_Space
	#Style_Comment
	#Style_NonKeyword
	#Style_Sub
	#Style_Keyword
	#Style_Constant
	#Style_String
	#Style_Label
	#Style_Field
	#Style_Number
	#Style_Operator
	#Style_Bracket
	#Style_Separator
	#Style_NewLine
	#Style_Annotation
EndEnumeration

Declare Scintilla_AutoComplete(*scintilla.SCI_GADGET)
Declare Scintilla_AutoIndent(sci, pos)
Declare Scintilla_HighlightClear(sci)
Declare Scintilla_HighlightWord(sci)
Declare Scintilla_HilightBraces(sci, pos)
Declare Scintilla_CaseCorrection(sci, *dict.SCI_DICTENTRY, startPos, endPos)
Declare Scintilla_AddDictEntry(*scintilla.SCI_GADGET, text.s, startPos, endPos, type)
Declare Scintilla_RemoveDictEntry(*scintilla.SCI_GADGET, startPos, endPos)
Declare Scintilla_AutoMarginWidth(sci)

Procedure Scintilla_Min(v1, v2)
	If v1 < v2
		ProcedureReturn v1
	EndIf
	ProcedureReturn v2
EndProcedure

Procedure Scintilla_Max(v1, v2)
	If v1 > v2
		ProcedureReturn v1
	EndIf
	ProcedureReturn v2
EndProcedure

Procedure Scintilla_IsNumber(*number.Character)
	While *number\c
		Select *number\c
			Case '-', '0' To '9', '.'
			Default
				ProcedureReturn #False
		EndSelect
		*number + SizeOf(Character)
	Wend
	
	ProcedureReturn #True
EndProcedure

Procedure Scintilla_IsBrace(sci, pos)
	Select ScintillaSendMessage(sci, #SCI_GETCHARAT, pos)
		Case '(', ')', '[', ']', '{', '}'
			ProcedureReturn #True
	EndSelect
	ProcedureReturn #False
EndProcedure


Procedure Scintilla_Highlight(*scintilla.SCI_GADGET, endPos)
	Protected line, curPos, startPos, state, prevState, nextState, curState
	Protected text.s, uText.s
	Protected char.a, cType
	Protected sci = *scintilla\ID

	curPos = ScintillaSendMessage(sci, #SCI_GETENDSTYLED, 0, 0)
	line = ScintillaSendMessage(sci, #SCI_LINEFROMPOSITION, curPos, 0)
	If line
		line - 1
	EndIf
	
    curPos = ScintillaSendMessage(sci, #SCI_POSITIONFROMLINE, line, 0)
    ScintillaSendMessage(sci, #SCI_STARTSTYLING, curPos, $1F)
    
    state = #Style_Space
    startPos = curPos
    
    While curPos <= endPos
    	prevState = state
    	If nextState
    		state = nextState
    		nextState = 0
    	EndIf
        
        char = ScintillaSendMessage(sci, #SCI_GETCHARAT, curPos, 0)
        cType = SCI_CHARTYPE(char) 
        
        Select cType
        	Case #Style_Comment
        		If state <> #Style_String
        			state = #Style_Comment
        		EndIf
        	Case #Style_NewLine
        		state = #Style_Space
        	Default
        		If state <> #Style_Comment
        			If cType = #Style_Number And state = #Style_NonKeyword
        				cType = prevState
        			EndIf
        			If cType = #Style_String And state = #Style_String 
        				nextState = #Style_NonKeyword
        			ElseIf state <> #Style_String
        				state = cType
        				If state = #Style_NonKeyword
        					text + Chr(char)
        				EndIf
        			EndIf
            	EndIf
        EndSelect

        If state <> prevState Or curPos = endPos
        	uText = UCase(text)
        	If prevState = #Style_NonKeyword
        		Select curState
         			Case #Style_Constant, #Style_Sub, #Style_Label, #Style_Field
        				prevState = curState
        				
        				If *scintilla\CursorPos < startPos Or *scintilla\CursorPos > curPos
        					Scintilla_AddDictEntry(*scintilla, text, startPos, curPos, #Style_NonKeyword)
        				EndIf
        			Default
        				If FindMapElement(*scintilla\dict(), uText)
        					prevState = *scintilla\dict()\type
         					If text <> *scintilla\dict()\text
        						If *scintilla\CursorPos >= startPos And *scintilla\CursorPos <= curPos
        							*scintilla\keyWord = *scintilla\dict()
        							*scintilla\keyWord\startPos = startPos
        							*scintilla\keyWord\endPos = curPos
        						Else
        							Scintilla_CaseCorrection(sci, *scintilla\dict(), startPos, curPos)
        						EndIf
         					EndIf
         				Else
         					*scintilla\keyWord = #Null
         					
         					prevState = SCI_CHARTYPE(Asc(uText))
        					
        					If Len(text) > 1 And prevState <> #Style_Number And prevState <> #Style_String And prevState <> #Style_Comment
        						If *scintilla\CursorPos < startPos Or *scintilla\CursorPos > curPos
        							Scintilla_AddDictEntry(*scintilla, text, startPos, curPos, #Style_NonKeyword)
        							prevState = #Style_NonKeyword
        						EndIf
        					EndIf
        				EndIf
        		EndSelect
        		
                text = ""
            EndIf
            curState = prevState
            ScintillaSendMessage(sci, #SCI_SETSTYLING, curPos - startPos, prevState)
            startPos = curPos
        EndIf
        
        curPos + 1
    Wend
EndProcedure

;-

Procedure Scintilla_Callback(sci, *scinotify.SCNotification)
	Static userInput
	Protected modified = #False
	Protected u = userInput
	Protected *scintilla.SCI_GADGET = Scintilla(Str(sci))
	If *scintilla = #Null
		ProcedureReturn #False
	EndIf
	
	*scintilla\PreviousCursorPos = *scintilla\CursorPos
	*scintilla\CursorPos = ScintillaSendMessage(sci, #SCI_GETCURRENTPOS, 0, 0)
	
	Select *scinotify\nmhdr\code
		Case #SCN_MODIFIED
			modified = #True
			If *scinotify\modificationType & #SC_MOD_INSERTTEXT
				
			EndIf
			If *scinotify\modificationType & #SC_MOD_DELETETEXT
				Scintilla_RemoveDictEntry(*scintilla, *scinotify\position, *scinotify\position + *scinotify\length)
			EndIf
		Case #SCN_UPDATEUI
			If *scinotify\updated & #SC_UPDATE_SELECTION
				If *scintilla\keyWord
					If *scintilla\CursorPos < *scintilla\keyWord\startPos Or *scintilla\CursorPos > *scintilla\keyWord\endPos
						Scintilla_CaseCorrection(sci, *scintilla\keyWord, *scintilla\keyWord\startPos, *scintilla\keyWord\endPos)
						*scintilla\keyWord = #Null
					EndIf	
				EndIf
				Scintilla_HighlightWord(sci)
			EndIf
		Case #SCN_CHARADDED
			ScintillaSendMessage(sci, #SCI_BEGINUNDOACTION, 0, 0)
			userInput = 1
			Scintilla_HighlightClear(sci)
			If *scinotify\ch = #CR Or *scinotify\ch = #LF
				Scintilla_AutoIndent(sci, *scintilla\CursorPos)
			Else
				Scintilla_AutoComplete(*scintilla)
			EndIf
			ScintillaSendMessage(sci, #SCI_ENDUNDOACTION, 0, 0)
		Case #SCN_STYLENEEDED
			Scintilla_Highlight(*scintilla, *scinotify\position)
			userInput = 0
		Case #SCN_SAVEPOINTLEFT
			*scintilla\dirty = 1
		Case #SCN_SAVEPOINTREACHED
			*scintilla\dirty = 0
	EndSelect
	
	If modified Or *scintilla\CursorPos <> *scintilla\PreviousCursorPos
		Scintilla_HilightBraces(sci, *scintilla\CursorPos)
		Scintilla_AutoMarginWidth(sci)
	EndIf
EndProcedure

;-

Procedure Scintilla_Gadget(ID, X, Y, Width, Height)
	Protected c
	Protected bColor = RGB(30,30,35)
	Protected *scintilla.SCI_GADGET
	
	For c = 0 To 255
		Select c
			Case 0
			Case Asc("'")
				SCI_CHARTYPE(c) = #Style_Comment
			Case Asc(#DOUBLEQUOTE$)
				SCI_CHARTYPE(c) = #Style_String
			Case #CR, #LF
				SCI_CHARTYPE(c) = #Style_NewLine
			Case ' ', #TAB
				SCI_CHARTYPE(c) = #Style_Space
			Case '(', ')', '{', '}', '[', ']'
				SCI_CHARTYPE(c) = #Style_Bracket
			Case '+', '-', '*', '/', '^', '%', '!', '=', '<', '>'
				SCI_CHARTYPE(c) = #Style_Operator
			Case '~'
				SCI_CHARTYPE(c) = #Style_Field
			Case ':'
				SCI_CHARTYPE(c) = #Style_Label
			Case '$'
				SCI_CHARTYPE(c) = #Style_Sub
			Case '#'
				SCI_CHARTYPE(c) = #Style_Constant
			Case '|'
				SCI_CHARTYPE(c) = #Style_Separator
			Case '0' To '9'
				SCI_CHARTYPE(c) = #Style_Number
			Default
				SCI_CHARTYPE(c) = #Style_NonKeyword
		EndSelect
	Next
	
	If ID = #PB_Any
		ID = ScintillaGadget(#PB_Any, X, Y, WIDTH, Height, @Scintilla_Callback())
	Else
		ScintillaGadget(ID, X, Y, WIDTH, Height, @Scintilla_Callback())		
	EndIf
	
	If IsGadget(ID)
		*scintilla = AddMapElement(Scintilla(), Str(ID))
		If *scintilla
			*scintilla\ID = ID
			ForEach *Opcode()
				Scintilla_AddDictEntry(*scintilla, *Opcode()\name, 0, 0, #Style_Keyword)
			Next
			ForEach KeyWord()
				Scintilla_AddDictEntry(*scintilla, KeyWord()\name, 0, 0, #Style_Keyword)
			Next
		EndIf
		
		ScintillaSendMessage(ID, #SCI_SETILEXER, 0, 0)
		ScintillaSendMessage(ID, #SCI_STYLESETBACK, #STYLE_DEFAULT, bColor)
		
		Define *font = UTF8(FontName)
		If *font
			ScintillaSendMessage(ID, #SCI_STYLESETFONT, #STYLE_DEFAULT, *font)
			FreeMemory(*font)
		EndIf
		
		ScintillaSendMessage(ID, #SCI_STYLESETSIZE, #STYLE_DEFAULT, FontHeight)
		ScintillaSendMessage(ID, #SCI_STYLECLEARALL, 0, 0)
		
		ScintillaSendMessage(ID, #SCI_SETSELBACK, 1, RGB(255,255,255))
		;ScintillaSendMessage(ID, #SCI_SETSELECTIONLAYER, #SC_LAYER_UNDER_TEXT, 0)
		ScintillaSendMessage(ID, #SCI_SETSELALPHA, 50,0)
		;ScintillaSendMessage(ID, #SCI_SETELEMENTCOLOUR, #SC_ELEMENT_SELECTION_BACK, RGBA(255,255,255,64))
		;ScintillaSendMessage(ID, #SCI_SETSELBACK, #SC_ELEMENT_SELECTION_INACTIVE_BACK, RGBA(60,60,65,128))

		ScintillaSendMessage(ID, #SCI_SETCARETFORE, RGB(255,255,255), 0)
		ScintillaSendMessage(ID, #SCI_SETCARETLINEBACK, RGB(50,50,50), 0)
		ScintillaSendMessage(ID, #SCI_SETCARETWIDTH, 2, 0)
		ScintillaSendMessage(ID, #SCI_SETCARETSTICKY, 1, 0)
		ScintillaSendMessage(ID, #SCI_SETCARETLINEVISIBLEALWAYS, 1, 0)
		
		ScintillaSendMessage(ID, #SCI_SETRECTANGULARSELECTIONMODIFIER, #SCMOD_ALT, 0)
		ScintillaSendMessage(ID, #SCI_SETMULTIPLESELECTION, 1, 0)
		ScintillaSendMessage(ID, #SCI_SETMULTIPASTE, #SC_MULTIPASTE_EACH, 0)
		ScintillaSendMessage(ID, #SCI_SETADDITIONALSELECTIONTYPING, 1, 0)
		 
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_Comment, RGB(106,155,85))
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_Keyword, RGB(200,135,195))
		ScintillaSendMessage(ID, #SCI_STYLESETBOLD, #Style_Keyword, 1)
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_NonKeyword, RGB(155,220,255))
		ScintillaSendMessage(ID, #SCI_STYLESETBOLD, #Style_Sub, 1)
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_Sub, RGB(220,220,170))
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_Constant, RGB(235,150,130))
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_String, RGB(205,225,200))
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_Label, RGB(85,255,215))
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_Field, RGB(155,155,255))
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_Number, RGB(180,220,180))
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_Operator, RGB(220,140,130))
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_Bracket, RGB(255,255,255))
		ScintillaSendMessage(ID, #SCI_STYLESETBOLD, #Style_Bracket, 1)
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_Separator, RGB(255,255,255))
		ScintillaSendMessage(ID, #SCI_STYLESETBOLD, #Style_Separator, 1)
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_Space, RGB(0,0,0))
		ScintillaSendMessage(ID, #SCI_STYLESETBACK, #Style_Annotation, RGB(255,185,185))
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #Style_Annotation, RGB(128,0,0))		
		
		ScintillaSendMessage(ID, #SCI_SETMARGINTYPEN, 0, #SC_MARGIN_NUMBER)
		ScintillaSendMessage(ID, #SCI_SETMARGINWIDTHN, 0, 50)
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #STYLE_LINENUMBER, RGB(150,150,145))
		ScintillaSendMessage(ID, #SCI_STYLESETBACK, #STYLE_LINENUMBER, RGB(40,40,35))
				
		ScintillaSendMessage(ID, #SCI_ANNOTATIONSETVISIBLE, 1, 0)
		ScintillaSendMessage(ID, #SCI_SETINDENTATIONGUIDES, #SC_IV_LOOKBOTH, 0)
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #STYLE_INDENTGUIDE, RGB(128,128,128))
		
		ScintillaSendMessage(ID, #SCI_SETTABWIDTH, 4, 0)
		ScintillaSendMessage(ID, #SCI_SETUSETABS, 1, 0)
		ScintillaSendMessage(ID, #SCI_SETINDENT, 4, 0)
		ScintillaSendMessage(ID, #SCI_SETBACKSPACEUNINDENTS, 1, 0)
		
		ScintillaSendMessage(ID, #SCI_INDICSETSTYLE, 0, #INDIC_PLAIN)
		ScintillaSendMessage(ID, #SCI_INDICSETFORE, 0, RGB(185,195,255))
		ScintillaSendMessage(ID, #SCI_INDICSETALPHA, 0, 85)
		ScintillaSendMessage(ID, #SCI_INDICSETUNDER, 0, 1)
		ScintillaSendMessage(ID, #SCI_SETINDICATORCURRENT, 0, #INDIC_PLAIN)
		;ScintillaSendMessage(ID, #SCI_INDICSETOUTLINEALPHA,0, 128)
		
		;ScintillaSendMessage(ID, #SCI_SETWHITESPACEBACK, 1, RGB(255,255,255))
		
		ScintillaSendMessage(ID, #SCI_STYLESETBOLD, #STYLE_BRACEBAD, 1)
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #STYLE_BRACEBAD, RGB(255,128,128))
		ScintillaSendMessage(ID, #SCI_STYLESETBACK, #STYLE_BRACEBAD, RGB(128,64,64))
		ScintillaSendMessage(ID, #SCI_STYLESETBOLD, #STYLE_BRACELIGHT, 1)
		ScintillaSendMessage(ID, #SCI_STYLESETFORE, #STYLE_BRACELIGHT, RGB(128,255,128))
		ScintillaSendMessage(ID, #SCI_STYLESETBACK, #STYLE_BRACELIGHT, RGB(64,128,64))
		
		ScintillaSendMessage(ID, #SCI_SETUNDOCOLLECTION, 1, 0)
	EndIf
	
	ProcedureReturn IsGadget(ID)
EndProcedure
	
Procedure.s Scintilla_GetText(sci)
	Protected size, *buffer, text.s
	size = ScintillaSendMessage(sci, #SCI_GETLENGTH, 0, 0)
	If size > 0
		*buffer = AllocateMemory((size * 4) + 1, #PB_Memory_NoClear)
		If *buffer
			ScintillaSendMessage(sci, #SCI_GETTEXT, size, *buffer)
			text = PeekS(*buffer, -1, #PB_UTF8)
			FreeMemory(*buffer)
		EndIf
	EndIf
	ProcedureReturn text
EndProcedure

Procedure.s Scintilla_SetText(sci, text.s)
	Protected *buffer
	If text
		*buffer = UTF8(text)
		If *buffer
			ScintillaSendMessage(sci, #SCI_SETTEXT, 0, *buffer)
			FreeMemory(*buffer)
		EndIf
	Else
		ScintillaSendMessage(sci, #SCI_CLEARALL, 0, 0)
	EndIf
EndProcedure

Procedure.s Scintilla_GetSelText(sci)
	Protected size, *text, text.s
	size = ScintillaSendMessage(sci, #SCI_GETSELTEXT, 0, 0)
	If size > 0
		*text = AllocateMemory(size * 4 + 1)
		If *text
			ScintillaSendMessage(sci, #SCI_GETSELTEXT, 0, *text)
			text = PeekS(*text, -1, #PB_UTF8)
			FreeMemory(*text)
		EndIf
	EndIf
	ProcedureReturn text
EndProcedure

Procedure Scintilla_GetCursorLineNr(sci)
	Protected pos
	pos = ScintillaSendMessage(sci, #SCI_GETCURRENTPOS, 0, 0)
	ProcedureReturn ScintillaSendMessage(sci, #SCI_LINEFROMPOSITION, pos, 0)
EndProcedure

Procedure Scintilla_GetCursorCharNr(sci)
	Protected pos, line
	pos = ScintillaSendMessage(sci, #SCI_GETCURRENTPOS, 0, 0)
	line = ScintillaSendMessage(sci, #SCI_LINEFROMPOSITION, pos, 0)
	ProcedureReturn pos - ScintillaSendMessage(sci, #SCI_POSITIONFROMLINE, line, 0)
EndProcedure

Procedure Scintilla_SetCursorPosition(sci, line, char)
	Protected pos, scroll
	pos = ScintillaSendMessage(sci, #SCI_POSITIONFROMLINE, line, 0) + char
	ScintillaSendMessage(sci, #SCI_GOTOPOS, pos, 0)
	
	scroll = ScintillaSendMessage(sci, #SCI_VISIBLEFROMDOCLINE, line, 0) - ScintillaSendMessage(sci, #SCI_GETFIRSTVISIBLELINE, 0, 0)
	ScintillaSendMessage(sci, #SCI_LINESCROLL, 0, scroll)
EndProcedure

Procedure Scintilla_GetCarret(sci)
	ProcedureReturn ScintillaSendMessage(sci, #SCI_GETCURRENTPOS, 0, 0)
EndProcedure

Procedure Scintilla_SetCarret(sci, pos)
	ScintillaSendMessage(sci, #SCI_GOTOPOS, pos, 0)
EndProcedure

Procedure Scintilla_SetSelection(sci, pos)
	ScintillaSendMessage(sci, #SCI_SETANCHOR, pos, 0)
EndProcedure

Procedure Scintilla_GetSelection(sci)
	ProcedureReturn ScintillaSendMessage(sci, #SCI_GETANCHOR, 0, 0)
EndProcedure

Procedure Scintilla_Scroll(sci, direction)
	Protected line
	line = Scintilla_Max(0, ScintillaSendMessage(sci, #SCI_GETFIRSTVISIBLELINE, 0, 0) + direction)
	ScintillaSendMessage(sci, #SCI_SETFIRSTVISIBLELINE, line, 0)
EndProcedure

Procedure Scintilla_SetErrorLine(sci, line, text.s)
	Protected *text = UTF8(text)
	If *text
		ScintillaSendMessage(sci, #SCI_ANNOTATIONSETTEXT, line, *text)
		ScintillaSendMessage(sci, #SCI_ANNOTATIONSETSTYLE, line, #Style_Annotation)
		FreeMemory(*text)
	EndIf
EndProcedure

Procedure Scintilla_ClearError(sci)
	ScintillaSendMessage(sci, #SCI_ANNOTATIONCLEARALL, 0, 0)	
EndProcedure

Procedure Scintilla_CanUndo(sci)
	ProcedureReturn ScintillaSendMessage(sci, #SCI_CANUNDO, 0, 0)	
EndProcedure

Procedure Scintilla_ClearUndo(sci)
	ProcedureReturn ScintillaSendMessage(sci, #SCI_EMPTYUNDOBUFFER, 0, 0)	
EndProcedure

Procedure Scintilla_SetSavePoint(sci)
	If FindMapElement(Scintilla(), Str(sci))
		Scintilla()\dirty = 0
	EndIf
	ProcedureReturn ScintillaSendMessage(sci, #SCI_SETSAVEPOINT, 0, 0)	
EndProcedure

Procedure Scintilla_IsDirty(sci)
	If FindMapElement(Scintilla(), Str(sci))
		ProcedureReturn Scintilla()\dirty
	EndIf
EndProcedure

Procedure Scintilla_HilightBraces(sci, pos)
	Protected bracePos1 = -1
	Protected bracePos2 = -1
	
	If (pos > 0) And Scintilla_IsBrace(sci, pos - 1)
		bracePos1 = pos - 1
	ElseIf Scintilla_IsBrace(sci, pos)
		bracePos1 = pos
	EndIf
	
	If bracePos1 >= 0
		bracePos2 = ScintillaSendMessage(sci, #SCI_BRACEMATCH, bracePos1, 0)
 		If (bracePos2 = -1)
 			ScintillaSendMessage(sci, #SCI_BRACEBADLIGHT, bracePos1, bracePos2)
 		Else
 			ScintillaSendMessage(sci, #SCI_BRACEHIGHLIGHT, bracePos1, bracePos2)
 		EndIf
	Else
		ScintillaSendMessage(sci, #SCI_BRACEHIGHLIGHT, -1, -1)
	EndIf
EndProcedure
			
Procedure Scintilla_Search(sci, startPos, endPos)
	ScintillaSendMessage(sci, #SCI_SETTARGETSTART, startPos, 0)
	ScintillaSendMessage(sci, #SCI_SETTARGETEND, endPos, 0)
	ScintillaSendMessage(sci, #SCI_SETSEARCHFLAGS, SCI_SEARCHFLAGS, 0)
	SCI_SEARCHPOS = ScintillaSendMessage(sci, #SCI_SEARCHINTARGET, SCI_SEARCHTEXTLENGTH, *SCI_SEARCHTEXT)
	If SCI_SEARCHPOS >= 0
		startPos = ScintillaSendMessage(sci, #SCI_GETTARGETSTART, 0, 0)
		endPos = ScintillaSendMessage(sci, #SCI_GETTARGETEND, 0, 0)
		ScintillaSendMessage(sci, #SCI_SETSEL, startPos, endPos)
	EndIf
	ProcedureReturn SCI_SEARCHPOS
EndProcedure

Procedure Scintilla_SearchPrevious(sci)
	If *SCI_SEARCHTEXT
		SCI_SEARCHPOS = Scintilla_Min(ScintillaSendMessage(sci, #SCI_GETCURRENTPOS, 0, 0), ScintillaSendMessage(sci, #SCI_GETANCHOR, 0, 0))
		If Scintilla_Search(sci, SCI_SEARCHPOS, 0) = -1
			ProcedureReturn Scintilla_Search(sci, ScintillaSendMessage(sci, #SCI_GETLENGTH, 0, 0), 0)
		EndIf
	EndIf
	ProcedureReturn #True
EndProcedure

Procedure Scintilla_SearchNext(sci)
	If *SCI_SEARCHTEXT
		SCI_SEARCHPOS = Scintilla_Max(ScintillaSendMessage(sci, #SCI_GETCURRENTPOS, 0, 0), ScintillaSendMessage(sci, #SCI_GETANCHOR, 0, 0))
		If Scintilla_Search(sci, SCI_SEARCHPOS, ScintillaSendMessage(sci, #SCI_GETLENGTH, 0, 0)) = -1
			ProcedureReturn Scintilla_Search(sci, 0, ScintillaSendMessage(sci, #SCI_GETLENGTH, 0, 0))
		EndIf
	EndIf
	ProcedureReturn #True
EndProcedure

Procedure Scintilla_SearchStart(sci, text.s, replace.s = "", replaceLength = -1)
	If *SCI_SEARCHTEXT
		FreeMemory(*SCI_SEARCHTEXT)
		*SCI_SEARCHTEXT = #Null
	EndIf
	If *SCI_REPLACETEXT
		FreeMemory(*SCI_REPLACETEXT)
		*SCI_REPLACETEXT = #Null
	EndIf
	
	*SCI_SEARCHTEXT = UTF8(text)
	SCI_SEARCHTEXTLENGTH = Len(text)
	
	If replaceLength >= 0
		*SCI_REPLACETEXT = UTF8(replace)
		SCI_REPLACETEXTLENGTH = Len(replace)
	EndIf
EndProcedure

Procedure Scintilla_AddDictEntry(*scintilla.SCI_GADGET, text.s, startPos, endPos, type)
	Protected key.s = UCase(text)
	Protected *entry.SCI_DICTENTRY = FindMapElement(*scintilla\dict(), key)

	If *entry = #Null
		*entry = AddMapElement(*scintilla\dict(), key, #PB_Map_NoElementCheck)
		If *entry
			*entry\type = type
			*entry\startPos = startPos
			*entry\endPos = endPos
			*entry\text = text
			*entry\usage = 1
		EndIf
	EndIf
EndProcedure
                				
Procedure Scintilla_RemoveDictEntry(*scintilla.SCI_GADGET, startPos, endPos)
	ProcedureReturn
	ForEach *scintilla\dict()
		If *scintilla\dict()\type <> #Style_Keyword
; 			If startPos >= *scintilla\dict()\startPos And endPos < *scintilla\dict()\endPos
; 				DeleteMapElement(*scintilla\dict())
; 			EndIf
		EndIf
	Next
EndProcedure    
    
Procedure Scintilla_CaseCorrection(sci, *dict.SCI_DICTENTRY, startPos, endPos)
	If *dict\type = #Style_Keyword
		Protected *text = UTF8(*dict\text)
		If *text
			ScintillaSendMessage(sci , #SCI_SETUNDOCOLLECTION, 0, 0);
			ScintillaSendMessage(sci, #SCI_SETTARGETRANGE, startPos, endPos)
			ScintillaSendMessage(sci, #SCI_REPLACETARGET, -1, *text)
			ScintillaSendMessage(sci , #SCI_SETUNDOCOLLECTION, 1, 0);
			FreeMemory(*text)
		EndIf
	EndIf
EndProcedure

Procedure Scintilla_AutoComplete(*scintilla.SCI_GADGET)
	Protected sci = *scintilla\ID
	Protected startWord.s, words.s,  result, *list, length, dictLen
	Protected txtRange.SCTextRange

    txtRange\chrg\cpMax = ScintillaSendMessage(sci, #SCI_GETCURRENTPOS,0, 0)
    txtRange\chrg\cpMin = ScintillaSendMessage(sci, #SCI_WORDSTARTPOSITION, txtRange\chrg\cpMax, 1)
    length = txtRange\chrg\cpMax - txtRange\chrg\cpMin
    If length >= 1
    	txtRange\lpstrText = AllocateMemory(length * 4 + 1)
    	If txtRange\lpstrText
    		result = ScintillaSendMessage(sci, #SCI_GETTEXTRANGE, 0, @txtRange)
    		If result >= 0
    			startWord = UCase(PeekS(txtRange\lpstrText, result, #PB_UTF8))
    			FreeMemory(txtRange\lpstrText)
    			
    			ForEach *scintilla\dict()
    				If Left(MapKey(*scintilla\dict()), result) = startWord
    					words + *scintilla\dict()\text + " "
    				EndIf
    			Next
    			
    			words = Trim(words)
    			If words
    				*list = UTF8(words)
    				If *list
    					ScintillaSendMessage(sci, #SCI_AUTOCSETIGNORECASE, 1, 0)
    					ScintillaSendMessage(sci, #SCI_AUTOCSETORDER, #SC_ORDER_PERFORMSORT)
    					ScintillaSendMessage(sci, #SCI_AUTOCSHOW, length, *list)
    					FreeMemory(*list)
    				EndIf
    			EndIf
    		EndIf
    	EndIf
    
    EndIf
    
    ProcedureReturn result
EndProcedure

Procedure Scintilla_AutoIndent(sci, pos)
	Protected lineInd, tabSize
	Protected currentLine = ScintillaSendMessage(sci, #SCI_LINEFROMPOSITION, pos, 0)
	If currentLine > 0
		lineInd = ScintillaSendMessage(sci, #SCI_GETLINEINDENTATION, currentLine - 1, 0)
		If lineInd
			ScintillaSendMessage(sci, #SCI_SETLINEINDENTATION, currentLine, lineInd)
			tabSize = ScintillaSendMessage(sci, #SCI_GETTABWIDTH, 0, 0)
			If tabSize
				lineInd = lineInd / tabSize + lineInd % tabSize
				ScintillaSendMessage(sci, #SCI_GOTOPOS, ScintillaSendMessage(sci, #SCI_POSITIONFROMLINE, currentLine, 0) + lineInd)
			EndIf
		EndIf
	EndIf
EndProcedure

Procedure Scintilla_BlockComment(sci, commentChar, uncomment = 0)
	Protected line, char, c, posStart, posEnd, lineStart, lineEnd, *text
	
	*text = UTF8(Chr(commentChar))
	If *text
		posStart = ScintillaSendMessage(sci, #SCI_GETSELECTIONSTART, 0, 0)
		posEnd = ScintillaSendMessage(sci, #SCI_GETSELECTIONEND, 0, 0)

		lineStart = ScintillaSendMessage(sci, #SCI_LINEFROMPOSITION, posStart, 0)
		lineEnd = ScintillaSendMessage(sci, #SCI_LINEFROMPOSITION, posEnd, 0)
		
		ScintillaSendMessage(sci, #SCI_BEGINUNDOACTION, 0, 0)
		
		For line = lineEnd To lineStart Step -1
			posStart = ScintillaSendMessage(sci, #SCI_POSITIONFROMLINE, line, 0)
			
			If uncomment
				posEnd = ScintillaSendMessage(sci, #SCI_GETLINEENDPOSITION, line, 0)
				For char = posStart To posEnd
					Select ScintillaSendMessage(sci, #SCI_GETCHARAT, char, 0)
						Case ' ', #TAB
						Case commentChar
							ScintillaSendMessage(sci, #SCI_DELETERANGE, char, 1)
							Break
						Default 
							Break
					EndSelect
				Next
			Else
				ScintillaSendMessage(sci, #SCI_INSERTTEXT, posStart, *text)
			EndIf
		Next
		
		posStart = ScintillaSendMessage(sci, #SCI_POSITIONFROMLINE, lineStart, 0)
		posEnd = ScintillaSendMessage(sci, #SCI_GETLINEENDPOSITION, lineEnd, 0)
		ScintillaSendMessage(sci, #SCI_SETSEL, posStart, posEnd)
		
		ScintillaSendMessage(sci, #SCI_ENDUNDOACTION, 0, 0)
		
		FreeMemory(*text)
	EndIf                    
EndProcedure

Procedure Scintilla_GetCurrentWord(sci, *txtRange.SCTextRange)
	Protected pos, result
	
    pos = ScintillaSendMessage(sci, #SCI_GETCURRENTPOS,0, 0)
    *txtRange\chrg\cpMin = ScintillaSendMessage(sci, #SCI_WORDSTARTPOSITION, pos, 1)
    *txtRange\chrg\cpMax = ScintillaSendMessage(sci, #SCI_WORDENDPOSITION, pos, 1)
    
    *txtRange\lpstrText = AllocateMemory((*txtRange\chrg\cpMax - *txtRange\chrg\cpMin) * 4 + 1)
    If *txtRange\lpstrText
    	result = ScintillaSendMessage(sci, #SCI_GETTEXTRANGE, 0, *txtRange)
    EndIf
    
    ProcedureReturn result
EndProcedure

Procedure Scintilla_HighlightClear(sci)
	Protected length
	length = ScintillaSendMessage(sci, #SCI_GETLENGTH, 0, 0)
	ScintillaSendMessage(sci, #SCI_SETINDICATORCURRENT, 0, 0)
	ScintillaSendMessage(sci, #SCI_INDICATORCLEARRANGE, 0, length)	
EndProcedure

Procedure Scintilla_HighlightWord(sci)
	Protected count, found, selStart, selEnd
	Protected txtFind.SCTextToFind, txtRange.SCTextRange
	
	selStart = ScintillaSendMessage(sci, #SCI_GETSELECTIONNSTART, 0, 0)
	selEnd = ScintillaSendMessage(sci, #SCI_GETSELECTIONEND, 0, 0)
	
	Scintilla_HighlightClear(sci)

	If selStart = selEnd
        ProcedureReturn
    ElseIf ScintillaSendMessage(sci, #SCI_LINEFROMPOSITION, selStart, 0) <> ScintillaSendMessage(sci, #SCI_LINEFROMPOSITION, selEnd, 0)
    	ProcedureReturn
    EndIf
    
    If Scintilla_GetCurrentWord(sci, txtRange) >= 0
    	If selStart < txtRange\chrg\cpMin Or selEnd > txtRange\chrg\cpMax
    		ProcedureReturn	
    	EndIf
    	
    	txtFind\lpstrText = txtRange\lpstrText
    	txtFind\chrg\cpMin = 0
    	txtFind\chrg\cpMax = ScintillaSendMessage(sci, #SCI_GETLENGTH, 0, 0)
    	
    	found = ScintillaSendMessage(sci, #SCI_FINDTEXT, #SCFIND_WHOLEWORD, txtFind)    	
    	While found > -1 And txtFind\chrgText\cpMax > txtFind\chrgText\cpMin
    		ScintillaSendMessage(sci, #SCI_INDICATORFILLRANGE, txtFind\chrgText\cpMin, txtFind\chrgText\cpMax - txtFind\chrgText\cpMin)
    		count + 1
    		
    		txtFind\chrg\cpMin = txtFind\chrgText\cpMax
    		found = ScintillaSendMessage(sci, #SCI_FINDTEXT, #SCFIND_WHOLEWORD, txtFind)
    	Wend
    EndIf
    
    If txtFind\lpstrText
    	FreeMemory(txtFind\lpstrText)
    EndIf
    
    ProcedureReturn count
EndProcedure

Procedure Scintilla_AutoMarginWidth(sci)
	Protected nrLines = ScintillaSendMessage(sci, #SCI_GETLINECOUNT, 0, 0)
	Protected *lineTxt = UTF8("_" + Str(nrLines))
	If *lineTxt
		Protected width = ScintillaSendMessage(sci, #SCI_TEXTWIDTH, #STYLE_LINENUMBER, *lineTxt)
		ScintillaSendMessage(sci, #SCI_SETMARGINWIDTHN, 0, width)
		FreeMemory(*lineTxt)
	EndIf
EndProcedure

Procedure Scintilla_Undo(sci)
	If FindMapElement(Scintilla(), Str(sci))
		ScintillaSendMessage(Scintilla()\ID, #SCI_AUTOCCANCEL, 0, 0)
		ScintillaSendMessage(Scintilla()\ID, #SCI_UNDO, 0, 0)
	EndIf
EndProcedure

Procedure Scintilla_Redo(sci)
	If FindMapElement(Scintilla(), Str(sci))
		ScintillaSendMessage(Scintilla()\ID, #SCI_AUTOCCANCEL, 0, 0)
		ScintillaSendMessage(Scintilla()\ID, #SCI_REDO, 0, 0)
	EndIf
EndProcedure
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 361
; FirstLine = 351
; Folding = --------
; EnableXP
; Executable = ..\ShoCo.exe