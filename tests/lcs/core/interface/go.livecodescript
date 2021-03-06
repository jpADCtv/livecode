script "CoreInterfaceGo"
/*
Copyright (C) 2016 LiveCode Ltd.

This file is part of LiveCode.

LiveCode is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License v3 as published by the Free
Software Foundation.

LiveCode is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License
along with LiveCode.  If not see <http://www.gnu.org/licenses/>.  */

on TestGoStackUnquotedName
   -- unquoted literal chunk parsing exception for `go stack "stack foo"`
   local tStackName
   create stack "stackToGo"
   put the short name of it into tStackName
   
   local tToGo
   put "stack stackToGo" into tToGo
   
   try
      go tToGo
   catch tError
   end try
   
   TestAssert "unquoted literal chunk parsing exception for go stack", \
      tError is empty
end TestGoStackUnquotedName

on TestGoCardUnquotedName
   -- unquoted literal chunk parsing exception for `go "card foo of this stack"`
   local tStackName
   create stack
   put the short name of it into tStackName
   
   create card "cardToGo"
   local tToGo
   put "card cardToGo" && the long id of stack tStackName into tToGo
   
   try
      go tToGo
   catch tError
   end try
   
   TestAssert "unquoted literal chunk parsing exception for go card", \
      tError is empty
end TestGoCardUnquotedName

local sStackFileName
command _TestCreateStack pBinary
   local tStack
   put "stackToGo" into tStack
   
   if pBinary then
      create stack tStack
   else
      create script only stack tStack
   end if
   
   put the tempname into sStackFileName
   save stack tStack as sStackFileName
   delete stack tStack
   return tStack for value
end _TestCreateStack

command _TestCleanupStack
   delete file sStackFileName
end _TestCleanupStack

command _TestGoStackUrl pWhich
   local tStack
   _TestCreateStack pWhich is "binary"
   put it into tStack
   go url ("file:" & sStackFileName)
   TestDiagnostic the result
   TestAssert "go" && pWhich && "stack url", there is a stack tStack
   _TestCleanupStack
end _TestGoStackUrl

on TestGoBinaryStackUrl
   _TestGoStackUrl "binary"
end TestGoBinaryStackUrl

on TestGoScriptOnlyStackUrl
   _TestGoStackUrl "script only"
end TestGoScriptOnlyStackUrl
