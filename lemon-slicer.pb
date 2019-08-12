#VER$  = "1.0.0"         ; by Tristano Ajmone | MIT License | PureBasic 5.70 LTS
#DATE$ = "2019/08/12"
; ******************************************************************************
; *                                                                            *
; *                                Lemon Slicer                                *
; *                                                                            *
; *              A de-amalgamator for the Lemon parser generator               *
; *                                                                            *
; *                             by Tristano Ajmone                             *
; *                                                                            *
;{******************************************************************************
; The Lemon parser generator, like all tools from the SQLite suite, is released
; in single amalgamated source files ("lemon.c" and "lempar.c"). This is done to
; reduce the number of dependency files and to achieve higher speed optimization
; (5-10% gain).
;
; Today, the "lemon.c" file only survives in its amalgamated form, the original
; split source files are no longer available ("lempar.c" has always been a
; single source file). In the SQLite project, all updates to the Lemon code are
; done directly in the amalgamated "lemon.c" file.
;
; This tools takes the Lemon parser source files from the current folder and
; creates a deamalgamated version in the "/sliced/" folder. It was created in
; order to maintain an always up-to-date split-sources version of Lemon for the
; Lemon Grove project:
;
;   https://github.com/tajmone/lemon-grove
;
; The "lempar.c" file is just copied over to the output folder (as is), whereas
; "lemon.c" is split into its original source files. The required `#include`
; directives are added at the end of the new "lemon.c" file, to include all the
; split files in the correct order in which they appeared, thus ensuring that
; "lemon.c" will compile correctly.
;}------------------------------------------------------------------------------

;-/// Settings ///
#outDir = "sliced"

CompilerIf #PB_Compiler_ExecutableFormat <> #PB_Compiler_Console
  CompilerError "You must compile this as a Console application."
CompilerEndIf

Global srcF, outF, curF
Declare Abort(errMsg$)

;-/// Setup ///
OpenConsole("Lemon Slicer")

;- Print Header
title$ = "# Lemon Slicer v"+ #VER$ +", by Tristano Ajmone #"
PrintN(#Empty$)
PrintN(LSet("", Len(title$), "#"))
PrintN(title$)
PrintN(LSet("", Len(title$), "#"))
PrintN(~"\nOutput directory: ."+ #PS$ + #outDir + #PS$)

;- Check that Lemon sources are present
If FileSize("lemon.c") < 0 Or FileSize("lempar.c") < 0
  Abort(~"Missing Lemon source files.\nThis tool requires \"lemon.c\" and "+
        ~"\"lempar.c\" to be present in the current folder.")
EndIf

;- Open Lemon source file
srcF = ReadFile(#PB_Any, "lemon.c")
If Not srcF : Abort(~"Couldn't open \"lemon.c\".") : EndIf

;- Initialize output folder
outDirPath.s = GetCurrentDirectory() + #outDir

Select FileSize(#outDir)
  Case -2
    ; // Out dir exists, do nothing.
  Case -1
    ; /// Out dir doesn't exist, create it.
    If Not CreateDirectory(#outDir)
      Abort(~"Unable to create \"" + #outDir + ~"\" folder.")
    EndIf
  Default
    ; /// There's already a file with that name.
    Abort(~"A file named \"" + #outDir + ~"\" prevents creating an output "+
          ~"folder with that name.\nPlease rename or delete that file.")
EndSelect

;- Delete old files in output folder
outDirObj = ExamineDirectory(#PB_Any, outDirPath, "*.*")
If outDirObj
  While NextDirectoryEntry(outDirObj)
    If DirectoryEntryType(outDirObj) = #PB_DirectoryEntry_File
      Select GetExtensionPart(DirectoryEntryName(outDirObj))
        Case "c", "h"
          DeleteFile(outDirPath + #PS$ + DirectoryEntryName(outDirObj))
      EndSelect
    EndIf
  Wend
  FinishDirectory(outDirObj)
EndIf

;- Copy "lempar.c" to out-folder
If Not CopyFile("lempar.c", #outDir + #PS$ + "lempar.c")
  Abort(~"Failed to copy \"lempar.c\" to output folder.")
EndIf

SetCurrentDirectory(outDirPath)

;- Create output source
outF = OpenFile(#PB_Any, "lemon.c")
If Not outF
  Abort(~"Couldn't create \""+ #outDir + #PS$ + ~"lemon.c\".")
EndIf

;-/// Process Lemon source
#SplitPattern = "** From the file"
cntFile = 1
curF = outF

While Not Eof(srcF)
  line.s = ReadString(srcF)
  If Left(line, 3) = "/**" And  FindString(line, #SplitPattern)
    newF.s = StringField(line, 2, ~"\"")
    WriteStringN(outF, ~"#include \""+ newF + ~"\"")
    If curF <> outF
      FlushFileBuffers(curF)
      CloseFile(curF)
    EndIf
    curF = OpenFile(#PB_Any, newF)
    If Not curF
      Abort(~"Couldn't create \""+ #outDir + #PS$ + newF + ~"\".")
    EndIf
    cntFile +1
  Else
    WriteStringN(curF, line)
  EndIf
Wend

CloseFile(srcF)
FlushFileBuffers(curF)
CloseFile(curF)
FlushFileBuffers(outF)
CloseFile(outF)

;-/// Print report ///
PrintN(~"\nTotal files generated: "+ Str(cntFile) +".")

;-/// Wrap up and exit ///
PrintN(~"\n/// Done ///")
CloseConsole()
End

;-/// Procedures ///
Procedure Abort(errMsg$)
  ConsoleError(~"\n** ERROR! **\n"+ errMsg$ +~"\n\n/// Aborting ///")
  If IsFile(srcF) : CloseFile(srcF) : EndIf
  If IsFile(outF) : CloseFile(outF) : EndIf
  If IsFile(curF) : CloseFile(curF) : EndIf
  End 1
EndProcedure

;{==============================================================================
;-                                 MIT License
; ==============================================================================
;
; Copyright (c) 2019 Tristano Ajmone <tajmone@gmail.com>
; https://github.com/tajmone/lemon-slicer
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;}------------------------------------------------------------------------------
